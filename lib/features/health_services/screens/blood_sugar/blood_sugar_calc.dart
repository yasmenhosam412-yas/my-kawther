import 'package:easy_localization/easy_localization.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/core/theme/app_colors.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/features/health_services/data/health_local_calc.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/widgets/sugar_sheet.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:flutter/material.dart';
import 'package:elkawther/features/health_services/utils/pdf_helper.dart';
import 'package:elkawther/features/health_services/widgets/health_service_scaffold.dart';

class BloodSugarCalc extends StatefulWidget {
  const BloodSugarCalc({super.key});

  @override
  State<BloodSugarCalc> createState() => _BloodSugarCalcState();
}

class _BloodSugarCalcState extends State<BloodSugarCalc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  late DateTime _selectedDate;
  String _selectedCondition = "random";
  String? _evaluationResult;
  List<BloodSugarDataFetched>? allResults;
  bool _pendingPdfRequest = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dateController.text.isEmpty) {
      _selectedDate = DateTime.now();
      _dateController.text =
          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      _timeController.text = "8:00 AM";
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return HealthServiceScaffold(
      title: S.of(context).blood_sugar,
      subtitle: isAr ? 'متابعة السكر' : 'Blood sugar follow-up',
      bottom: Column(
        children: [
          HealthPrimaryButton(
            title: S.of(context).calc,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submit(context, generatePdf: false);
              }
            },
          ),
          const SizedBox(height: 8),
          HealthPrimaryButton(
            title: S.of(context).uploadPdf,
            color: AppColors.teal,
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submit(context, generatePdf: true);
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            HealthFormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustomLabel(label: S.of(context).sugarLevel),
                  CustomTextFormField(
                    controller: _valueController,
                    hintText: "99",
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value == null || value.isEmpty
                            ? S.of(context).pleaseEnterValidNumber
                            : null,
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
                            value: 'random',
                            child: Text(S.of(context).random),
                          ),
                          DropdownMenuItem(
                            value: 'fasting',
                            child: Text(S.of(context).fasting),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCondition = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(BuildContext context, {required bool generatePdf}) {
    final value = int.tryParse(_valueController.text.trim()) ?? 0;

    try {
      _pendingPdfRequest = generatePdf;
      final now = DateTime.now();
      final formattedDate = DateFormat("yyyy-MM-dd HH:mm:ss", "en").format(now);
      final evaluation = HealthLocalCalc.sugarEvaluation(
        value,
        _selectedCondition,
      );
      final model = BloodSugarModel(
        message: 'Success',
        data: BloodSugarData(
          value: value,
          conditionType: _selectedCondition,
          measuredAt: now,
          evaluation: evaluation,
        ),
      );
      HealthLocalStore.instance.bloodSugar.insert(
        0,
        BloodSugarDataFetched(
          value: value,
          conditionType: _selectedCondition,
          measuredAt: formattedDate,
        ),
      );
      _evaluationResult = evaluation;
      allResults = List.of(HealthLocalStore.instance.bloodSugar);

      if (!_pendingPdfRequest) {
        sugarBottomSheet(context, model, allResults!);
        return;
      }
      _pendingPdfRequest = false;
      PdfHelper.generateBloodSugarPdf(
        lastValue: _valueController.text,
        lastCondition: PdfHelper.arabicCondition(_selectedCondition),
        lastEvaluation: _evaluationResult ?? '',
        allResults: allResults!,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).pleaseEnterValidNumber)),
      );
    }
  }
}
