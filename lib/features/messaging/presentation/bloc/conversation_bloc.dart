import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/get_conversation_messages_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';

class ConversationBloc extends Bloc<ChatEvent, ChatState> {
  ConversationBloc({
    required this.conversationId,
    required GetConversationMessagesUsecase getConversationMessagesUsecase,
    required SendMessageUsecase sendMessageUsecase,
    required GetUsersByUidsUseCase getUsersByUids,
    required SessionProvider sessionProvider,
    required this.partnerUid,
  }) : _getConversationMessagesUsecase = getConversationMessagesUsecase,
       _sendMessageUsecase = sendMessageUsecase,
       _getUsersByUids = getUsersByUids,
       _session = sessionProvider,
       super(ChatEmpty(null, null)) {
    on<Initialization>(_init);

    on<MessageSent>(_sendMessage);

    on<MessageUpdated>(
      (event, emit) => emit(
        ChatReady(state.currentUser, state.partner, messages: event.messages),
      ),
    );

    on<MessageError>(
      (event, emit) =>
          emit(ChatError(event.message, state.currentUser, state.partner)),
    );

    on<UsersUpdated>(
      (event, emit) => emit(
        state.copyWithUsers(
          currentUser: event.currentUser,
          partner: event.partner,
        ),
      ),
    );
  }

  final GetConversationMessagesUsecase _getConversationMessagesUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final GetUsersByUidsUseCase _getUsersByUids;
  final SessionProvider _session;
  final String partnerUid;
  StreamSubscription<List<Message>>? _subscription;
  final String conversationId;

  Future<void> _init(Initialization event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading(state.currentUser, state.partner));
      final currentUser = _session.user!;
      final partner = (await _getUsersByUids([partnerUid])).first;
      add(UsersUpdated(currentUser, partner));
      final messageStream = _getConversationMessagesUsecase(conversationId);
      _subscription?.cancel();
      _subscription = messageStream.listen(
        (messages) => add(MessageUpdated(messages)),
        onError: (e) => add(MessageError(e.toString())),
      );
    } on Exception catch (e) {
      emit(ChatError(e.toString(), state.currentUser, state.partner));
    }
  }

  Future<void> _sendMessage(MessageSent event, Emitter<ChatState> emit) async {
    try {
      await _sendMessageUsecase(event.text, conversationId);
    } on Exception {
      emit(ChatError("Can't send message.", state.currentUser, state.partner));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
