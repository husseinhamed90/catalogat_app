import 'dart:io';
import 'package:catalogat_app/core/constants/app_constants.dart';
import 'package:catalogat_app/core/dependencies.dart';
import 'package:catalogat_app/domain/entities/entities.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  PdfService._();

  static Future<File?> generateOrdersPdf(List<OrderEntity> orders) async {
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
              child: pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(2),
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
                  ...orders.map((order) {
                    return pw.TableRow(
                      children: [
                        _buildArabicCell("${order.totalPrice.formatAsCurrency()} ${globalKey.currentContext!.l10n.currency}"),
                        _buildArabicCell(order.quantity.toString()),
                        _buildArabicCell(order.productName),
                        _buildArabicCell(order.productCode),
                      ],
                    );
                  }),
                ],
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
    final fullPath = "${downloadsDir.path}/تقرير اوردرات $formattedDate.pdf";
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