import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/send_message_usecase.dart';
import 'package:project_collaboration_app/utils/logger.dart';
import 'package:project_collaboration_app/utils/result.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

typedef ConversationState = UiState<List<Message>>;

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit({
    required this.conversationId,
    required GetConversationMessagesUsecase getConversationMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
  }) : _getConversationMessagesUsecase = getConversationMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       super(ConversationState.idle());

  final GetConversationMessagesUsecase _getConversationMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  StreamSubscription<List<Message>>? _subscription;
  final String conversationId;

  Future<void> fetchMessages() async {
    emit(ConversationState.loading());
    final result = await _getConversationMessagesUsecase(conversationId);
    switch (result) {
      case Ok<Stream<List<Message>>>():
        _subscription?.cancel();
        _subscription = result.data.listen(
          (messages) => emit(ConversationState.success(messages)),
          onError: (e) => emit(ConversationState.error(e.toString())),
        );
      case Failure<Stream<List<Message>>>():
        emit(ConversationState.error(result.error.message));
    }
  }

  Future<void> sendMessage(String messageText) {
    AppLogger().d('cubit');
    return _sendMessageUsecase(messageText, conversationId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
