part of 'hewan_bloc.dart';

sealed class HewanState extends Equatable {
  const HewanState();
  
  @override
  List<Object> get props => [];
}

final class HewanInitial extends HewanState {}
