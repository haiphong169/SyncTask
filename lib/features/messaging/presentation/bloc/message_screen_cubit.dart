import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/get_conversation_list_usecase.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class MessageScreenCubit extends Cubit<UiState<List<Conversation>>> {
  final GetConversationListUsecase _getConversationListUsecase;
  StreamSubscription<List<Conversation>>? _subscription;

  MessageScreenCubit({
    required GetConversationListUsecase getConversationListUseCase,
  }) : _getConversationListUsecase = getConversationListUseCase,
       super(UiState.idle());

  Future<void> fetchConversations() async {
    emit(UiState.loading());
    final result = await _getConversationListUsecase();
    switch (result) {
      case Ok<Stream<List<Conversation>>>():
        _subscription?.cancel();
        _subscription = result.data.listen(
          (conversations) => emit(UiState.success(conversations)),
          onError: (e) => AppLogger().e(e),
        );
      case Failure<Stream<List<Conversation>>>():
        emit(UiState.error(result.error.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
