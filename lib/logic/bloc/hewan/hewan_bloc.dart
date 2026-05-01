import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/repositories/hewan_repository.dart';
import '../../../data/models/hewan_model.dart';
import 'dart:developer' as developer;

part 'hewan_event.dart';
part 'hewan_state.dart';

class HewanBloc extends Bloc<HewanEvent, HewanState> {
  final HewanRepository repository;

  HewanBloc({required this.repository}) : super(HewanInitial()) {
    on<FetchHewan>((event, emit) async {
      emit(HewanLoading());
      try {
        final list = await repository.getAllHewan();
        emit(HewanLoaded(list));
        developer.log('✓ FetchHewan: ${list.length} data dimuat', name: 'HewanBloc');
      } catch (e) {
        emit(HewanError(e.toString()));
        developer.log('✗ FetchHewan Error: $e', name: 'HewanBloc');
      }
    });

    on<CreateHewan>((event, emit) async {
      emit(HewanLoading());
      try {
        await repository.createHewan(event.data);
        emit(HewanCreatedSuccess());
        developer.log('✓ CreateHewan: Berhasil menambah data', name: 'HewanBloc');
        add(const FetchHewan());
      } catch (e) {
        emit(HewanError(e.toString()));
        developer.log('✗ CreateHewan Error: $e', name: 'HewanBloc');
      }
    });

    on<UpdateHewan>((event, emit) async {
      emit(HewanLoading());
      try {
        await repository.updateHewan(event.id, event.data);
        emit(HewanCreatedSuccess());
        developer.log('✓ UpdateHewan: id=${event.id} berhasil diupdate', name: 'HewanBloc');
        add(const FetchHewan());
      } catch (e) {
        emit(HewanError(e.toString()));
        developer.log('✗ UpdateHewan Error: $e', name: 'HewanBloc');
      }
    });

    on<DeleteHewan>((event, emit) async {
      try {
        await repository.deleteHewan(event.id);
        emit(HewanCreatedSuccess());
        developer.log('✓ DeleteHewan: id=${event.id} berhasil dihapus', name: 'HewanBloc');
        add(const FetchHewan());
      } catch (e) {
        emit(HewanError(e.toString()));
        developer.log('✗ DeleteHewan Error: $e', name: 'HewanBloc');
      }
    });
  }
}
