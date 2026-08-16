import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/widgets/pressure_bottom_sheet.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter/material.dart';

import 'package:elkawther/features/health_services/utils/pdf_helper.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class PressureCalc extends StatefulWidget {
  const PressureCalc({super.key});

  @override
  State<PressureCalc> createState() => _PressureCalcState();
}

class _PressureCalcState extends State<PressureCalc> {
  final TextEditingController _systolicController = TextEditingController();
  final TextEditingController _diastolicController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late DateTime _selectedDate;

  String _selectedCondition = 'morning';
  String? _evaluationResult;
  bool _pendingPdfRequest = false;
  List<BloodPressureDataFetched> allResults = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text =
        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
    _timeController.text = "8:00 AM";
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, {bool generatePdf = false}) {
    final systolic = int.tryParse(_systolicController.text.trim());
    final diastolic = int.tryParse(_diastolicController.text.trim());

    if (_systolicController.text.length > 3 ||
        _diastolicController.text.length > 3) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).validateNumber)));
      return;
    }

    if (systolic == null || diastolic == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).requiredFeilds)));
      return;
    }

    final now = DateTime.now();

    final measuredAt = DateFormat('yyyy-MM-dd HH:mm:ss', "en").format(now);

    _pendingPdfRequest = generatePdf;

    final evaluation = HealthLocalCalc.bloodPressureEvaluation(
      systolic,
      diastolic,
    );
    final model = BloodMeasureModel(
      message: 'Success',
      data: BloodPressureData(
        systolic: systolic,
        diastolic: diastolic,
        conditionType: _getArabicCondition(_selectedCondition),
        measuredAt: now,
        evaluation: evaluation,
      ),
    );
    HealthLocalStore.instance.bloodPressure.insert(
      0,
      BloodPressureDataFetched(
        systolic: systolic,
        diastolic: diastolic,
        conditionType: _getArabicCondition(_selectedCondition),
        measuredAt: measuredAt,
      ),
    );
    _evaluationResult = evaluation;
    allResults = List.of(HealthLocalStore.instance.bloodPressure);

    if (!_pendingPdfRequest) {
      pressureBottomSheet(context, model, allResults);
      return;
    }
    _pendingPdfRequest = false;
    PdfHelper.generateBloodPressurePdf(
      lastSystolic: _systolicController.text,
      lastDiastolic: _diastolicController.text,
      lastCondition: PdfHelper.arabicCondition(
        _getArabicCondition(_selectedCondition),
      ),
      lastEvaluation: _evaluationResult ?? '',
      allResults: allResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).blood_pressure,
      subtitle: isAr ? 'قياس وتقييم الضغط' : 'Measure and evaluate BP',
      bottom: Column(
        children: [
          HealthPrimaryButton(
            title: S.of(context).add,
            onPressed: () => _submit(context),
          ),
          const SizedBox(height: 8),
          HealthPrimaryButton(
            title: S.of(context).uploadPdf,
            color: AppColors.teal,
            onPressed: () => _submit(context, generatePdf: true),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          HealthFormCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFieldCustomLabel(
                  label: S.of(context).measuringSystolicBloodPressure,
                ),
                CustomTextFormField(
                  controller: _systolicController,
                  hintText: S.of(context).enterMeasurement,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(
                  label: S.of(context).diastolicBloodPressureMeasurement,
                ),
                CustomTextFormField(
                  controller: _diastolicController,
                  hintText: S.of(context).enterMeasurement,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppPadding.medium),
                TextFieldCustomLabel(label: S.of(context).testCase),
                HealthDropdownBox(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedCondition,
                      items: [
                        DropdownMenuItem(
                          value: 'morning',
                          child: Text(S.of(context).morning),
                        ),
                        DropdownMenuItem(
                          value: 'evening',
                          child: Text(S.of(context).evening),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedCondition = value!),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getArabicCondition(String key) {
    switch (key) {
      case 'morning':
        return 'صباحي';
      case 'evening':
        return 'مسائي';
      default:
        return key;
    }
  }
}
