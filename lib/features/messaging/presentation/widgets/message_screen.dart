import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/conversation.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/message_screen_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 48),
            MessageSearchBar(
              onTap: () {
                context.push(Routes.userSearch, extra: Routes.messages);
              },
            ),
            SizedBox(height: 48),
            Expanded(
              child:
                  BlocBuilder<MessageScreenCubit, UiState<List<Conversation>>>(
                    builder:
                        (context, state) => switch (state) {
                          Success<List<Conversation>>(:final data) =>
                            ListView.builder(
                              itemCount: data.length,
                              itemBuilder:
                                  (context, index) => _ConversationListTile(
                                    conversation: data[index],
                                    onTap: () {
                                      context.push(
                                        Routes.conversationWithId(
                                          data[index].uid,
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          _ => SizedBox(),
                        },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationListTile extends StatelessWidget {
  const _ConversationListTile({
    required this.conversation,
    required this.onTap,
  });

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(onTap: onTap, title: Text(conversation.lastMessage));
  }
}

class MessageSearchBar extends StatelessWidget {
  const MessageSearchBar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "Search users...",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
