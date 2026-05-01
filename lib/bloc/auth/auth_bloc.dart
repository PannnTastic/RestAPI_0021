import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../data/repositories/auth_repository.dart';
import 'dart:developer' as developer;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final token = await repository.getToken();
      if (token != null) {
        emit(Authenticated(token));
        developer.log('✓ Status: Authenticated (token restored)', name: 'AuthBloc');
      } else {
        emit(Unauthenticated());
        developer.log('Status: Unauthenticated', name: 'AuthBloc');
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      developer.log('Attempting login for: ${event.email}', name: 'AuthBloc');

      try {
        await repository.login(event.email, event.password);

        final token = await repository.getToken();

        if (token != null) {
          emit(Authenticated(token));
          developer.log('✓ Status: Authenticated', name: 'AuthBloc');
        } else {
          throw 'Token tidak ditemukan setelah login';
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('✗ Status: AuthError - $e', name: 'AuthBloc');
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await repository.register(event.name, event.email, event.password);
        emit(Unauthenticated());
        developer.log('✓ Register Success', name: 'AuthBloc');
      } catch (e) {
        emit(AuthError(e.toString()));
        developer.log('✗ Register Error: $e', name: 'AuthBloc');
      }
    });

    on<LogoutRequested>((event, emit) async {
      await repository.deleteToken();
      emit(Unauthenticated());
      developer.log('✓ Logged Out', name: 'AuthBloc');
    });
  }
}
