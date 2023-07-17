import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qscan/base/base_bloc.dart';
import 'package:qscan/home/bloc/home_events.dart';
import 'package:qscan/home/bloc/home_state.dart';

import '../../base/util/shared_preferences_utils.dart';

class HomeBloc extends BaseBloc {
  HomeBloc(super.initialState) {
    on<SaveRecords>(_saveRecords);
    on<CheckRecordsValidation>(_isValidRecords);
  }

  void _saveRecords(SaveRecords event, Emitter<BaseBlocState> emit) async {
    emit(StateContentLoading());
    final response = await SharedPreferencesUtils.addMobileNo(event.data);
    await Future.delayed(const Duration(seconds: 1));
    return response ? emit(const SaveRecordsSuccess("Record Saved!")) : emit(const SaveRecordsError("Record Not Saved!"));
  }

  void _isValidRecords(CheckRecordsValidation event, Emitter<BaseBlocState> emit) async {
    emit(StateContentLoading());
    var isValid=event.data.contains("Name:") && event.data.contains("Mobile:") && event.data.contains("Category:");
    return isValid ? emit(const RecordsValidationSuccess()) : emit(const RecordsValidationError("Invalid Records"));
  }
}
