import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import 'package:elkawther/features/health_services/models/measures.dart';

class PdfHelper {
  /// Generates a blood sugar report PDF and opens it
  static Future<void> generateBloodSugarPdf({
    required String lastValue,
    required String lastCondition,
    required String lastEvaluation,
    required List<BloodSugarDataFetched> allResults,
  }) async {
    final pdf = pw.Document();

    // Load Arabic font
    final fontData = await rootBundle.load(
      "assets/fonts/NotoSansArabic-Medium.ttf",
    );
    final ttf = pw.Font.ttf(fontData);

    // Current timestamp
    final now = DateTime.now();
    final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss", "en").format(now);

    const int chunkSize = 200;

    for (var i = 0; i < allResults.length; i += chunkSize) {
      final chunk = allResults.sublist(
        i,
        (i + chunkSize > allResults.length) ? allResults.length : i + chunkSize,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build:
              (pw.Context context) => [
                if (i == 0)
                  pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Text(
                          "تقرير قياس سكر الدم",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "آخر قراءة:",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "القيمة: $lastValue ملغم/ديسيلتر",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "الحالة: $lastCondition",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "تم القياس في: $formattedDate",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "النتيجة: ${lastEvaluation.isNotEmpty ? lastEvaluation : 'غير متوفر'}",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.SizedBox(height: 30),
                        pw.Text(
                          "جميع القراءات السابقة:",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3), // Date
                    1: const pw.FlexColumnWidth(2), // Condition
                    2: const pw.FlexColumnWidth(2), // Value
                    3: const pw.FlexColumnWidth(1), // Index
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children:
                          ["تاريخ القياس", "الحالة", "القيمة", "رقم"].map((
                            header,
                          ) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                header,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl,
                              ),
                            );
                          }).toList(),
                    ),
                    // Data rows
                    ...chunk.map((result) {
                      final index = allResults.indexOf(result) + 1;
                      final measuredAt = DateTime.tryParse(result.measuredAt);

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              measuredAt != null
                                  ? DateFormat(
                                    'yyyy-MM-dd hh:mm a',
                                  ).format(measuredAt)
                                  : '-',
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              arabicCondition(result.conditionType),
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "${result.value}",
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "$index",
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],
        ),
      );
    }

    // Save PDF to file
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/blood_sugar_report.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open PDF
    await OpenFilex.open(file.path);
  }

  static Future<void> generateBloodPressurePdf({
    required String lastSystolic,
    required String lastDiastolic,
    required String lastCondition,
    required String lastEvaluation,
    required List<BloodPressureDataFetched> allResults,
  }) async {
    final pdf = pw.Document();

    // Load Arabic font
    final fontData = await rootBundle.load(
      "assets/fonts/NotoSansArabic-Medium.ttf",
    );
    final ttf = pw.Font.ttf(fontData);

    // Current timestamp
    final now = DateTime.now();
    final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss", "en").format(now);

    const int chunkSize = 200;

    for (var i = 0; i < allResults.length; i += chunkSize) {
      final chunk = allResults.sublist(
        i,
        (i + chunkSize > allResults.length) ? allResults.length : i + chunkSize,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build:
              (pw.Context context) => [
                if (i == 0)
                  pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Text(
                          "تقرير قياس ضغط الدم",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          "آخر قراءة:",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "الضغط الانقباضي: $lastSystolic ملم زئبق",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "الضغط الانبساطي: $lastDiastolic ملم زئبق",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "الحالة: $lastCondition",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "النتيجة: ${lastEvaluation.isNotEmpty ? lastEvaluation : 'غير متوفر'}",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.Text(
                          "تم القياس في: $formattedDate",
                          style: pw.TextStyle(font: ttf),
                        ),
                        pw.SizedBox(height: 30),
                        pw.Text(
                          "جميع القراءات السابقة:",
                          style: pw.TextStyle(
                            font: ttf,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textDirection: pw.TextDirection.rtl,
                        ),
                        pw.SizedBox(height: 10),
                      ],
                    ),
                  ),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3), // Date
                    1: const pw.FlexColumnWidth(2), // Condition
                    2: const pw.FlexColumnWidth(2), // Systolic
                    3: const pw.FlexColumnWidth(2), // Diastolic
                    4: const pw.FlexColumnWidth(1), // Index
                  },
                  children: [
                    // Header row
                    pw.TableRow(
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey300,
                      ),
                      children:
                          [
                            "تاريخ القياس",
                            "الحالة",
                            "الانقباضي",
                            "الانبساطي",
                            "رقم",
                          ].map((header) {
                            return pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(
                                header,
                                style: pw.TextStyle(
                                  font: ttf,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                                textDirection: pw.TextDirection.rtl,
                              ),
                            );
                          }).toList(),
                    ),
                    ...chunk.map((result) {
                      final index = allResults.indexOf(result) + 1;
                      final measuredAt = DateTime.tryParse(result.measuredAt);

                      return pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              measuredAt != null
                                  ? DateFormat(
                                    'yyyy-MM-dd hh:mm a',
                                  ).format(measuredAt)
                                  : '-',
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              arabicCondition(result.conditionType),
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "${result.systolic}",
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "${result.diastolic}",
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "$index",
                              style: pw.TextStyle(font: ttf),
                              textDirection: pw.TextDirection.rtl,
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],
        ),
      );
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/blood_pressure_report.pdf");
    await file.writeAsBytes(await pdf.save());

    await OpenFilex.open(file.path);
  }

  static String arabicCondition(String key) {
    switch (key) {
      case 'fasting':
        return 'صائم';
      case 'after_meal':
        return 'بعد الأكل';
      case 'before_breakfast':
        return 'قبل الإفطار';
      case 'random':
        return 'عشوائي';
      case 'morning':
        return 'صباحي';
      case 'evening':
        return 'مسائي';

      default:
        return key;
    }
  }
}
