part of 'hewan_bloc.dart';

sealed class HewanEvent extends Equatable {
  const HewanEvent();

  @override
  List<Object> get props => [];
}

class FetchHewan extends HewanEvent {
  const FetchHewan();
}

class CreateHewan extends HewanEvent {
  final Map<String, dynamic> data;

  const CreateHewan({required this.data});

  @override
  List<Object> get props => [data];
}

class UpdateHewan extends HewanEvent {
  final int id;
  final Map<String, dynamic> data;

  const UpdateHewan({required this.id, required this.data});

  @override
  List<Object> get props => [id, data];
}

class DeleteHewan extends HewanEvent {
  final int id;

  const DeleteHewan({required this.id});

  @override
  List<Object> get props => [id];
}
