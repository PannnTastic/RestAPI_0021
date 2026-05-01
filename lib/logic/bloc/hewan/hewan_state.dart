part of 'hewan_bloc.dart';

sealed class HewanState extends Equatable {
  const HewanState();

  @override
  List<Object> get props => [];
}

final class HewanInitial extends HewanState {}

final class HewanLoading extends HewanState {}

final class HewanLoaded extends HewanState {
  final List<HewanModel> hewanList;

  const HewanLoaded(this.hewanList);

  @override
  List<Object> get props => [hewanList];
}

final class HewanDetailLoaded extends HewanState {
  final HewanModel hewan;

  const HewanDetailLoaded(this.hewan);

  @override
  List<Object> get props => [hewan];
}

final class HewanCreatedSuccess extends HewanState {}

final class HewanError extends HewanState {
  final String message;

  const HewanError(this.message);

  @override
  List<Object> get props => [message];
}
