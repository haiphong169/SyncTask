import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/mock_conversation_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/widgets/chat_bubble.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';

class MockConversationScreen extends StatefulWidget {
  const MockConversationScreen({super.key});

  @override
  State<MockConversationScreen> createState() => _MockConversationScreenState();
}

class _MockConversationScreenState extends State<MockConversationScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MockConversationBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(state),
          body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: switch (state) {
                      ChatEmpty() => Center(
                        child: Text('Send a message to start the conversation'),
                      ),
                      ChatError(:final error) => Center(child: Text(error)),
                      ChatLoading() => Center(
                        child: CircularProgressIndicator(),
                      ),
                      ChatReady(:final messages) => _buildMessageList(
                        messages,
                        state.currentUser!,
                        state.partner!,
                      ),
                      _ => SizedBox(),
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _controller)),
                      IconButton(
                        onPressed: () {
                          if (state is ChatEmpty) {
                            context.read<MockConversationBloc>().add(
                              ConversationCreated(_controller.text),
                            );
                          } else if (state is ChatReady) {
                            context.read<MockConversationBloc>().add(
                              MessageSent(_controller.text),
                            );
                          }
                          _controller.clear();
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageList(
    List<Message> messages,
    final User currentUser,
    final User partner,
  ) {
    final avatarUid = <String, void>{};
    final reversedMessages = messages.reversed.toList();
    for (int i = 0; i < reversedMessages.length; i++) {
      if (i > 0) {
        if (reversedMessages[i].senderUid == currentUser.uid &&
            reversedMessages[i - 1].senderUid == partner.uid) {
          avatarUid[reversedMessages[i - 1].uid] = null;
        }
      }
    }
    if (reversedMessages.last.senderUid == partner.uid) {
      avatarUid[reversedMessages.last.uid] = null;
    }

    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Padding(
          padding: const EdgeInsetsGeometry.symmetric(
            vertical: 4,
            horizontal: 4,
          ),
          child: ChatRow(
            text: message.text,
            time: message.createdAt,
            isMe: message.senderUid == currentUser.uid,
            avatar: avatarUid.containsKey(message.uid) ? partner.avatar : null,
          ),
        );
      },
    );
  }

  AppBar _appBar(ChatState state) {
    if (state.currentUser == null || state.partner == null) {
      return AppBar();
    } else {
      return AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            UserCircleAvatar(avatar: state.partner!.avatar, radius: 28),
            SizedBox(width: 8),
            Text(state.partner!.username),
          ],
        ),
      );
    }
  }
}
