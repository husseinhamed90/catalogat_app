import 'dart:io';
import 'dart:isolate';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;

class PdfService {
  PdfService._();

  static Future<Uint8List> _downloadImageInIsolate(String url) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_imageDownloadIsolate, [url, receivePort.sendPort]);
    return await receivePort.first as Uint8List;
  }

  static void _imageDownloadIsolate(List<dynamic> args) async {
    final url = args[0] as String;
    final sendPort = args[1] as SendPort;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        sendPort.send(response.bodyBytes);
      } else {
        sendPort.send(Uint8List(0)); // fallback empty image
      }
    } catch (_) {
      sendPort.send(Uint8List(0));
    }
  }

  static Future<File?> generateOrdersPdf(OrderPdfFileEntity order) async {
    final pdf = pw.Document();

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Amiri-Regular.ttf"),
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
          icons: arabicFont,
          italic: arabicFont,
          boldItalic: arabicFont,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                children: [
                  // Company Name on the Left
                  pw.Text(
                    "المندوب : ${order.representativeName}",
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                  // Spacer to push the rest of the content to the right if needed
                  pw.Spacer(),
                ],
              ),
            ),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                children: [
                  pw.Text(
                    "العميل : ${order.customerName}",
                    style: const pw.TextStyle(fontSize: 16),
                  ),
                  // Spacer to push the rest of the content to the right if needed
                  pw.Spacer(),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(3),
                  3: pw.FlexColumnWidth(2),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey200,
                    ),
                    children: [
                      _buildArabicCell('المجموع', isHeader: true), // Total
                      _buildArabicCell('الكمية', isHeader: true), // Quantity
                      _buildArabicCell(
                        'اسم المنتج',
                        isHeader: true,
                      ), // Product Name
                      _buildArabicCell(
                        'كود المنتج',
                        isHeader: true,
                      ), // Product Code
                    ],
                  ),
                  // Data rows (RTL order)
                  ...order.products.map((product) {
                    return pw.TableRow(
                      children: [
                        _buildArabicCell(
                          "${product.totalPrice?.formatAsCurrency()} ${globalKey.currentContext!.l10n.currency}",
                        ),
                        _buildArabicCell(product.quantity.toString()),
                        _buildArabicCell(product.productName ?? ""),
                        _buildArabicCell(product.productCode ?? ""),
                      ],
                    );
                  }),
                ],
              ),
            ),
            pw.SizedBox(height: 15),
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Text(
                "اجمالي قيمة الطلب : ${order.totalPrice.formatAsCurrency()} ${globalKey.currentContext!.l10n.currency}",
                style: const pw.TextStyle(fontSize: 16),
              ),
            ),
          ];
        },
      ),
    );

    final downloadsDir = Directory('/storage/emulated/0/Download/orders');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    final arabicFormat = DateFormat(
      'd MMMM y',
      AppConstants.arabicLanguageCode,
    );
    final formattedDate = arabicFormat.format(DateTime.now());
    final fullPath =
        "${downloadsDir.path}/${order.customerName} - $formattedDate.pdf";
    final file = File(fullPath);
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(fullPath);
    return file;
  }

  static Future<File?> generateProductsPdf(BrandEntity brand) async {
    final pdf = pw.Document();

    final arabicFont = pw.Font.ttf(
      await rootBundle.load("assets/fonts/Amiri-Regular.ttf"),
    );

    Map<String, Uint8List> imageCache = {};
    for (final product in brand.products) {
      if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
        try {
          final bytes = await _downloadImageInIsolate(product.imageUrl!);
          if (bytes.isNotEmpty) {
            imageCache[product.id!] = bytes;
          }
        } catch (e) {
          // Optional: Log error for this product
        }
      }
    }

    final imageBytes = await rootBundle.load(Assets.images.imgPlaceholder.path);

    pw.Widget productCard(ProductEntity product) {
      return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Container(
          width: 130,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(12),
            color: PdfColors.white,
          ),
          padding: const pw.EdgeInsets.all(5),
          child: pw.Column(
            children: [
              pw.Container(
                width: 120,
                height: 70,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.only(
                    topLeft: pw.Radius.circular(12),
                    topRight: pw.Radius.circular(12),
                  ),
                ),
                child: pw.Image(
                  pw.MemoryImage(
                      product.imageUrl == null || product.imageUrl!.isEmpty
                          ? imageBytes.buffer.asUint8List()
                          : imageCache[product.id!]!
                  ),
                  fit: pw.BoxFit.contain,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 8),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                          textAlign: pw.TextAlign.center,
                          maxLines: 3,
                          overflow: pw.TextOverflow.span,
                          product.name ?? "",
                          style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.normal, fontSize: 12)
                      ),
                    ),
                    pw.SizedBox(height: 3),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        maxLines: 1,
                        style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.bold, fontSize: 14),
                        product.productCode ?? "",
                      ),
                    )
                  ],
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: double.infinity,
                      padding: pw.EdgeInsets.symmetric(horizontal: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Directionality(
                              textDirection: pw.TextDirection.rtl,
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: globalKey.currentContext!.l10n.price_1_value,
                                      style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.normal, fontSize: 12),
                                    ),
                                    pw.TextSpan(
                                      text: "${product.price1?.formatAsCurrency() ?? ""} ${globalKey.currentContext!.l10n.currency} ",
                                      style: pw.TextStyle(color: PdfColors.red, fontWeight: pw.FontWeight.normal, fontSize: 12),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                              )
                          ),
                          pw.SizedBox(height: 5),
                          pw.FittedBox(
                              child: pw.Directionality(
                                  textDirection: pw.TextDirection.rtl,
                                  child: pw.Text(
                                      style: pw.TextStyle(color: PdfColors.black, fontWeight: pw.FontWeight.normal, fontSize: 12),
                                      maxLines: 1,
                                      globalKey.currentContext!.l10n.price_2_value((product.price2 ?? 0.0).formatAsCurrency())
                                  )
                              )
                          )
                        ],
                      ),
                    ),
                  ]
              ),
              pw.SizedBox(height: 15),
            ],
          ),
        )
      );
    }

    pdf.addPage(
      pw.MultiPage(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        margin: const pw.EdgeInsets.all(20),
        maxPages: 2000,
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
          icons: arabicFont,
          italic: arabicFont,
          boldItalic: arabicFont,
        ),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Wrap(
              spacing: 5,
              runSpacing: 5,
              children: brand.products.map((p) => productCard(p)).toList(),
            ),
          ];
        },
      ),
    );

    final downloadsDir = Directory('/storage/emulated/0/Download/brands');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    final fullPath = "${downloadsDir.path}/${brand.name}.pdf";
    final file = File(fullPath);
    await file.writeAsBytes(await pdf.save());
    OpenFile.open(fullPath);
    return file;
  }

  static pw.Widget _buildArabicCell(String text, {bool isHeader = false}) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        textDirection: pw.TextDirection.rtl,
        textAlign: pw.TextAlign.center,
        style: isHeader ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }
}