import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/utils/result.dart';

class ConversationBloc extends Bloc<ChatEvent, ChatState> {
  ConversationBloc({
    required this.conversationId,
    required GetConversationMessagesUsecase getConversationMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
  }) : _getConversationMessagesUsecase = getConversationMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       super(const ChatEmpty()) {
    on<FetchMessages>(_fetchMessages);

    on<MessageSent>(_sendMessage);

    on<MessageUpdated>(
      (event, emit) => emit(ChatReady(messages: event.messages)),
    );

    on<MessageError>((event, emit) => emit(ChatError(event.message)));
  }

  final GetConversationMessagesUsecase _getConversationMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  StreamSubscription<List<Message>>? _subscription;
  final String conversationId;

  Future<void> _fetchMessages(
    FetchMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await _getConversationMessagesUsecase(conversationId);
    switch (result) {
      case Ok<Stream<List<Message>>>():
        _subscription?.cancel();
        _subscription = result.data.listen(
          (messages) => add(MessageUpdated(messages)),
          onError: (e) => add(MessageError(e.toString())),
        );
      case Failure<Stream<List<Message>>>():
        emit(ChatError(result.error.message));
    }
  }

  Future<void> _sendMessage(MessageSent event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final result = await _sendMessageUsecase(event.text, conversationId);
    if (result is Failure<void>) {
      emit(ChatError(result.error.message));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
