import 'package:qscan/base/base_bloc.dart';

class HomeInit extends BaseBlocState {
  const HomeInit();

  @override
  List<Object> get props => [];
}

class SaveRecordsSuccess extends BaseBlocState {
  final String message;

  const SaveRecordsSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SaveRecordsError extends BaseBlocState {
  final String message;

  const SaveRecordsError(this.message);

  @override
  List<Object> get props => [message];
}

class RecordsValidationSuccess extends BaseBlocState {
  const RecordsValidationSuccess();
}

class RecordsValidationError extends BaseBlocState {
  final String message;

  const RecordsValidationError(this.message);

  @override
  List<Object> get props => [message];
}
