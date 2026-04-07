import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/auth/domain/repositories/session_provider.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/add_conversation_usecase.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/message/send_message_usecase.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/user/domain/usecases/get_users_by_uids_usecase.dart';

class MockConversationBloc extends Bloc<ChatEvent, ChatState> {
  MockConversationBloc({
    required this.partnerId,
    required AddConversationUsecase addConversationUseCase,
    required SendMessageUsecase sendMessageUseCase,
    required GetUsersByUidsUseCase getUsersByUids,
    required SessionProvider sessionProvider,
  }) : _addConversationUsecase = addConversationUseCase,
       _sendMessageUsecase = sendMessageUseCase,
       _getUsersByUids = getUsersByUids,
       _session = sessionProvider,
       super(ChatEmpty(null, null)) {
    on<Initialization>(_init);

    on<ConversationCreated>(_createConversation);

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

  final String partnerId;
  final AddConversationUsecase _addConversationUsecase;
  final SendMessageUsecase _sendMessageUsecase;
  final GetUsersByUidsUseCase _getUsersByUids;
  final SessionProvider _session;
  StreamSubscription<List<Message>>? _subscription;
  late final String conversationId;

  Future<void> _init(Initialization event, Emitter<ChatState> emit) async {
    try {
      final currentUser = _session.user!;
      final partner = (await _getUsersByUids([partnerId])).first;
      add(UsersUpdated(currentUser, partner));
    } on Exception catch (e) {
      emit(ChatError(e.toString(), state.currentUser, state.partner));
    }
  }

  Future<void> _createConversation(
    ConversationCreated event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading(state.currentUser, state.partner));

    final result = await _addConversationUsecase(partnerId, event.text);

    conversationId = result.$2;
    _subscription?.cancel();
    _subscription = result.$1.listen(
      (messages) => add(MessageUpdated(messages)),
      onError: (e) => add(MessageError(e.toString())),
    );
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
