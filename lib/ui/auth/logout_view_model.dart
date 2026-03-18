import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/domain/abstract_repositories/auth_repository.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class LogoutViewModel extends Cubit<VoidUiState> {
  LogoutViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(VoidUiState.idle());

  final AuthRepository _authRepository;

  Future<void> logout() async {
    emit(VoidUiState.loading());
    final result = await _authRepository.logout();
    switch (result) {
      case Ok<void>():
        emit(VoidUiState.success(null));
      case Failure<void>():
        emit(
          VoidUiState.error(
            'Something wrong happened, could not sign you out right now',
          ),
        );
    }
  }
}
