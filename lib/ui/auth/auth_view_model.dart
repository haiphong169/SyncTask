import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/domain/models/user.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class AuthViewModel extends Cubit<UiState<User>> {
  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(UiState<User>.idle());

  final AuthRepository _authRepository;

  Future<void> fetchUser() async {
    emit(UiState<User>.loading());
    final result = await _authRepository.user;
    if (result == null) {
      emit(UiState<User>.error("Can't fetch user at the moment"));
      return;
    }
    emit(UiState<User>.success(result!));
  }
}
