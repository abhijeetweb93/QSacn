import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseBloc extends Bloc<BaseBlocEvent, BaseBlocState> {
  BaseBloc(BaseBlocState initialState) : super(initialState);
}

abstract class BaseBlocState extends Equatable {
  const BaseBlocState();

  @override
  List<Object> get props => [];
}

abstract class BaseBlocEvent extends Equatable {
  const BaseBlocEvent();
}

class StateContentLoading extends BaseBlocState{}
