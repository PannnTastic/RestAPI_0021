import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hewan_event.dart';
part 'hewan_state.dart';

class HewanBloc extends Bloc<HewanEvent, HewanState> {
  HewanBloc() : super(HewanInitial()) {
    on<HewanEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
