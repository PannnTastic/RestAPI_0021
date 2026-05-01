import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event){
    super.onEvent(bloc, event);
    developer.log('Event: $event', name: bloc.runtimeType.toString());
  }

  @override
  void onChange(BlocBase bloc, Change change){
    super.onChange(bloc, change);
    developer.log('Change: ${change.currentState} -> ${change.nextState}', name: bloc.runtimeType.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace){
    super.onError(bloc, error, stackTrace);
    developer.log('Error: $error', name: bloc.runtimeType.toString());
  } 
}