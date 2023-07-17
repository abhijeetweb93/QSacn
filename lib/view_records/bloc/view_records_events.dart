import 'package:equatable/equatable.dart';
import 'package:qscan/base/base_bloc.dart';


class InitViewRecords extends BaseBlocEvent {
  const InitViewRecords();

  @override
  List<Object> get props => [];
}

class SyncRecords extends BaseBlocEvent {
  final List<String> dataList;

  const SyncRecords(this.dataList);

  @override
  List<Object> get props => [dataList];
}