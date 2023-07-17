import '../../base/base_bloc.dart';

class ViewRecordsStateSuccess extends BaseBlocState {
  final List<String> recordsList;

  const ViewRecordsStateSuccess(this.recordsList);

  @override
  List<Object> get props => [recordsList];
}

class ViewRecordsStateError extends BaseBlocState {
  final String message;

  const ViewRecordsStateError(this.message);

  @override
  List<Object> get props => [message];
}

class RecordsSyncStateSuccess extends BaseBlocState {
  final String message;

  const RecordsSyncStateSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RecordsSyncStateError extends BaseBlocState {
  final String message;

  const RecordsSyncStateError(this.message);

  @override
  List<Object> get props => [message];
}
