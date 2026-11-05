import 'package:dio/dio.dart';
import 'package:elkawther/core/errors/errors.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/features/health_services/models/measures.dart';
import 'package:elkawther/features/health_services/models/pregnancy_calc_model.dart';
import 'package:elkawther/features/health_services/models/vaccines.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:elkawther/features/health_services/models/month_response.dart';
import 'package:elkawther/features/health_services/models/monthly_period_calc_model.dart';
import 'package:elkawther/features/health_services/models/weight_body.dart';
import 'package:elkawther/features/health_services/services/health_services.dart';

class HealthServiceCubit extends Cubit<HealthServcieState> {
  final HealthService _healthService;

  HealthServiceCubit(this._healthService) : super(HealthServicesInitial()) {
    monthlyPeriodCalc = null;
  }

  WeightBody? weightBody;
  MonthlyPeriodCalc? monthlyPeriodCalc;
  PregnancyCalcModel? pregnancyCalc;
  BloodSugarModel? bloodSugarModel;
  List<BloodSugarDataFetched>? bloodSugarModelData;
  List<BloodPressureDataFetched>? bloodPressureModelData;
  BloodMeasureModel? bloodMeasureModel;
  VaccinesModel? vaccinesModel;
  ChildrenResponse? fullVaccinesModel;
  int? updatingVaccineId;

  MonthResponse? currentPeriod;
  PregnancyResultModel? pregnancyResult;

  List<Map<String, dynamic>> weightHistoryData = [];

  Future<void> fetchCurrentPeriodData() async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.currentPeriodData();
      currentPeriod = model;
      emit(HealthServicesPeriodCurrentLoaded(monthResponse: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesErrorPeriod(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(error))),
      );
    }
  }

  Future<void> getPreganacyCalcCurrentData() async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getPreganacyCalcCurrentData();
      pregnancyResult = model;
      emit(HealthServicesCurrentPregnancyLoaded(pregnancyResult: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesErrorPregenancy(
          errors: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(error))),
      );
    }
  }

  Future<void> fetchBodyWeightData({
    required double weight,
    required double height,
    required String unit,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getBodyWeightData(
        weight: weight,
        height: height,
        unit: unit,
      );
      weightBody = model;
      emit(HealthServicesLoaded(weightBody: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  Future<void> fetchPeriodData({
    required String startDayOfCycle,
    required int cycleLength,
    required int periodLength,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getPeriodData(
        cycleLength: cycleLength,
        periodLength: periodLength,
        startDayOfCycle: startDayOfCycle,
      );
      monthlyPeriodCalc = model;
      emit(HealthServicesPeriodLoaded(monthlyPeriodCalc: model));
    } on DioException catch (dioError) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(dioError)),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  Future<void> fetchPregnancyCalcData({
    required String lastPeriodDate,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getPreganacyCalcData(
        lastPeriodDate: lastPeriodDate,
      );
      pregnancyCalc = model;
      emit(HealthServicesPreganacyLoaded(pregnancyCalc: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(error))),
      );
    }
  }

  Future<void> fetchBloodData({
    required int systolic,
    required int diastolic,
    required String conditionType,
    required String measuredAt,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getBloodMesureData(
        conditionType: conditionType,
        diastolic: diastolic,
        measuredAt: measuredAt,
        systolic: systolic,
      );
      bloodMeasureModel = model;
      final allData = await _healthService.getBloodMesureDataFetched();
      bloodPressureModelData = allData;

      emit(
        HealthServicesBloodLoaded(
          bloodMeasureModel: model,
          bloodPressuraData: bloodPressureModelData!,
        ),
      );
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  Future<void> fetchSugarData({
    required int value,
    required String conditionType,
    required String measuredAt,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getBloodSugarMesureData(
        measuredAt: measuredAt,
        conditionType: conditionType,
        value: value,
      );
      bloodSugarModel = model;

      final allData = await _healthService.fetchBloodSugarMeasureData();
      bloodSugarModelData = allData;

      emit(
        HealthServicesSugarLoadedAll(
          bloodPressureData: allData,
          bloodSugarModel: model,
        ),
      );
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(error))),
      );
    }
  }

  Future<void> fetchVaccineData({
    required String babyName,
    required String babyGender,
    required String babyBirth,
    required BuildContext context,
  }) async {
    emit(HealthServicesLoading());

    try {
      final model = await _healthService.getVaccinesData(
        babyName: babyName,
        babyGender: babyGender,
        babyBirth: babyBirth,
      );
      vaccinesModel = model;
      emit(HealthServicesVaccineLoaded(vaccinesModel: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  Future<void> fetchVaccineFullData({required BuildContext context}) async {
    emit(HealthServicesVaccineFullLoading());
    try {
      final model = await _healthService.getVaccinesFullDataChildren();
      fullVaccinesModel = model;
      emit(HealthServicesVaccineFullLoaded(fullVaccinesModel: model));
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(
          message: Errors(message: _getErrorMessage(dioError)),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        emit(
          HealthServicesError(
            message: Errors(message: _getErrorMessage(error)),
          ),
        );
      }
    }
  }

  Future<void> deleteChild(int childId) async {
    emit(ChildDeletedLoading());
    try {
      await _healthService.deleteChild(childId);

      if (fullVaccinesModel != null) {
        fullVaccinesModel!.children.removeWhere((child) => child.id == childId);
      }

      emit(ChildDeletedSuccess());
    } catch (error) {
      emit(ChildDeletedFail(error: _getErrorMessage(error)));
    }
  }

  Future<void> fetchWeightHistory() async {
    emit(HealthServicesLoading());
    try {
      weightHistoryData = await _healthService.getWeightHistory();
      emit(HealthServicesWeightHistoryLoaded(weightHistoryData: weightHistoryData));
    } on DioException catch (dioError) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(dioError))),
      );
    } catch (error) {
      emit(
        HealthServicesError(message: Errors(message: _getErrorMessage(error))),
      );
    }
  }

  Future<void> fetchVaccineStatusData({
    required Child child,
    required int vacId,
    required BuildContext context,
  }) async {
    updatingVaccineId = vacId;
    emit(HealthServicesUpdatingVaccineStatus());

    try {
      final updatedVaccine = await _healthService.updateVaccinesData(
        vacID: vacId,
        isCompleted: true,
      );

      final updatedVaccines =
          child.vaccines.map((v) {
            if (v.id == updatedVaccine.vaccine.id) {
              return Vaccine(
                id: updatedVaccine.vaccine.id,
                childId: updatedVaccine.vaccine.childId,
                vaccineName: updatedVaccine.vaccine.vaccineName,
                description: updatedVaccine.vaccine.description,
                scheduledDate: updatedVaccine.vaccine.scheduledDate,
                isCompleted: updatedVaccine.vaccine.isCompleted,
                createdAt: updatedVaccine.vaccine.createdAt,
                updatedAt: updatedVaccine.vaccine.updatedAt,
              );
            }
            return v;
          }).toList();

      final updatedChild = Child(
        id: child.id,
        userId: child.userId,
        childName: child.childName,
        gender: child.gender,
        birthDate: child.birthDate,
        vaccines: updatedVaccines,
        createdAt: child.createdAt,
        updatedAt: child.updatedAt,
      );

      updatingVaccineId = null;

      emit(HealthServicesChildUpdated(child: updatedChild));

      if (context.mounted) {
        AppSnackBar.success(S.of(context).loaded);
      }
    } on DioException catch (dioError) {
      updatingVaccineId = null;
      if (context.mounted) {
        final message =
            dioError.response?.data["message"] ?? S.of(context).unexpectedError;
        emit(HealthServicesError(message: message));
      }
    } catch (error) {
      updatingVaccineId = null;
      if (context.mounted) {
        emit(HealthServicesError(message: Errors(message: "$error")));
      }
    }
  }

  String _getErrorMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError) {
        return "nointernet";
      }

      final data = error.response?.data;
      if (data is Map<String, dynamic> && data.containsKey("message")) {
        return data["message"].toString();
      } else if (data is String) {
        return data;
      } else if (data is Map<String, dynamic> && data["errors"] != null) {
        final errors = data["errors"] as Map;
        for (var key in ["email", "phone", "name"]) {
          if (errors.containsKey(key) &&
              errors[key] is List &&
              (errors[key] as List).isNotEmpty) {
            return (errors[key] as List).first.toString();
          }
        }
      }

      return error.message ?? "Unexpected server error";
    }
    return error.toString();
  }
}

abstract class HealthServcieState extends Equatable {
  const HealthServcieState();

  @override
  List<Object> get props => [];
}

class HealthServicesInitial extends HealthServcieState {}

class HealthServicesLoading extends HealthServcieState {}

class HealthServicesVaccineFullLoading extends HealthServcieState {}

class HealthServicesUpdatingVaccineStatus extends HealthServcieState {}

class HealthServicesLoaded extends HealthServcieState {
  final WeightBody weightBody;

  const HealthServicesLoaded({required this.weightBody});

  @override
  List<Object> get props => [weightBody];
}

class HealthServicesPeriodLoaded extends HealthServcieState {
  final MonthlyPeriodCalc monthlyPeriodCalc;

  const HealthServicesPeriodLoaded({required this.monthlyPeriodCalc});

  @override
  List<Object> get props => [monthlyPeriodCalc];
}

class HealthServicesPeriodCurrentLoaded extends HealthServcieState {
  final MonthResponse monthResponse;

  const HealthServicesPeriodCurrentLoaded({required this.monthResponse});

  @override
  List<Object> get props => [monthResponse];
}

class HealthServicesPreganacyLoaded extends HealthServcieState {
  final PregnancyCalcModel pregnancyCalc;

  const HealthServicesPreganacyLoaded({required this.pregnancyCalc});

  @override
  List<Object> get props => [pregnancyCalc];
}

class HealthServicesBloodLoaded extends HealthServcieState {
  final BloodMeasureModel bloodMeasureModel;
  final List<BloodPressureDataFetched> bloodPressuraData;

  const HealthServicesBloodLoaded({
    required this.bloodMeasureModel,
    required this.bloodPressuraData,
  });

  @override
  List<Object> get props => [bloodMeasureModel];
}

class HealthServicesVaccineLoaded extends HealthServcieState {
  final VaccinesModel vaccinesModel;

  const HealthServicesVaccineLoaded({required this.vaccinesModel});

  @override
  List<Object> get props => [vaccinesModel];
}

class HealthServicesVaccineFullLoaded extends HealthServcieState {
  final ChildrenResponse fullVaccinesModel;

  const HealthServicesVaccineFullLoaded({required this.fullVaccinesModel});

  @override
  List<Object> get props => [fullVaccinesModel];
}

class HealthServicesError extends HealthServcieState {
  final Errors message;

  const HealthServicesError({required this.message});

  @override
  List<Object> get props => [message];
}

class HealthServicesWeightHistoryLoaded extends HealthServcieState {
  final List<Map<String, dynamic>> weightHistoryData;

  const HealthServicesWeightHistoryLoaded({required this.weightHistoryData});

  @override
  List<Object> get props => [weightHistoryData];
}

class HealthServicesErrorPeriod extends HealthServcieState {
  final Errors message;

  const HealthServicesErrorPeriod({required this.message});

  @override
  List<Object> get props => [message];
}

class HealthServicesChildUpdated extends HealthServcieState {
  final Child child;

  const HealthServicesChildUpdated({required this.child});

  @override
  List<Object> get props => [child];
}

class HealthServicesCurrentPregnancyLoaded extends HealthServcieState {
  final PregnancyResultModel pregnancyResult;

  const HealthServicesCurrentPregnancyLoaded({required this.pregnancyResult});

  @override
  List<Object> get props => [pregnancyResult];
}

class HealthServicesSugarLoadedAll extends HealthServcieState {
  final List<BloodSugarDataFetched> bloodPressureData;
  final BloodSugarModel bloodSugarModel;

  const HealthServicesSugarLoadedAll({
    required this.bloodPressureData,
    required this.bloodSugarModel,
  });

  @override
  List<Object> get props => [bloodPressureData];
}

class HealthServicesErrorPregenancy extends HealthServcieState {
  final Errors errors;

  const HealthServicesErrorPregenancy({required this.errors});

  @override
  List<Object> get props => [errors];
}

class ChildDeletedSuccess extends HealthServcieState {}

class ChildDeletedLoading extends HealthServcieState {}

class ChildDeletedFail extends HealthServcieState {
  final String error;

  const ChildDeletedFail({required this.error});
}
