import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_user_use_case.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class UserCubit extends Cubit<UiState<User>> {
  final GetUserUseCase _getUserUseCase;

  UserCubit({required GetUserUseCase getUserUseCase})
    : _getUserUseCase = getUserUseCase,
      super(UiState<User>.idle());

  void fetchUser() {
    final result = _getUserUseCase();
    switch (result) {
      case Ok<User>():
        emit(UiState.success(result.data));
      case Failure<User>():
        emit(UiState.error(result.error.message));
    }
  }
}
