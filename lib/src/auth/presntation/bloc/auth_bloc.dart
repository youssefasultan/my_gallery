import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:my_gallery/src/auth/domain/entites/user_entity.dart';
import 'package:my_gallery/src/auth/domain/usecases/sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
  })  : _signIn = signIn,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
  }

  final SignIn _signIn;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    ).then(
      (value) => value.fold(
        (failure) => emit(AuthError(message: failure.errorMessage)),
        (user) => emit(SignedIn(user)),
      ),
    );
  }
}
