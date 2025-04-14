import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:catalogat_app/core/constants/app_constants.dart';

class PdfService {
  PdfService._();

  static Future<File?> generateOrdersPdf(OrderPdfFileEntity order) async {
    final pdf = pw.Document();

    final arabicFont = pw.Font.ttf(await rootBundle.load("assets/fonts/Cairo-Regular.ttf"));

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
          base: arabicFont,
          bold: arabicFont,
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
                    "المندوب : ${order.representativeName}" ,
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
                      _buildArabicCell('المجموع', isHeader: true),  // Total
                      _buildArabicCell('الكمية', isHeader: true),    // Quantity
                      _buildArabicCell('اسم المنتج', isHeader: true), // Product Name
                      _buildArabicCell('كود المنتج', isHeader: true), // Product Code
                    ],
                  ),
                  // Data rows (RTL order)
                  ...order.products.map((product) {
                    return pw.TableRow(
                      children: [
                        _buildArabicCell("${product.totalPrice?.formatAsCurrency()} ${globalKey.currentContext!.l10n.currency}"),
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
    final arabicFormat = DateFormat('d MMMM y', AppConstants.arabicLanguageCode);
    final formattedDate = arabicFormat.format(DateTime.now());
    final fullPath = "${downloadsDir.path}/${order.customerName} - $formattedDate.pdf";
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
        style: isHeader
            ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
            : null,
      ),
    );
  }
}