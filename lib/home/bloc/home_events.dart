import '../../base/base_bloc.dart';

class SaveRecords extends BaseBlocEvent {
  final String data;

  const SaveRecords(this.data);

  @override
  List<Object> get props => [data];
}

class CheckRecordsValidation extends BaseBlocEvent {
  final String data;

  const CheckRecordsValidation(this.data);

  @override
  List<Object> get props => [data];
}
