import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_event.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/chat_state.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/conversation_bloc.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
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
    return Scaffold(
      body: BlocListener<ConversationBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<ConversationBloc, ChatState>(
                    builder:
                        (context, state) => switch (state) {
                          ChatReady(:final messages) => ListView.builder(
                            itemCount: messages.length,
                            itemBuilder:
                                (context, index) => Text(messages[index].text),
                          ),
                          ChatLoading() => Center(
                            child: CircularProgressIndicator(),
                          ),
                          _ => SizedBox(),
                        },
                  ),
                ),
                SizedBox(height: 16),
                // input field
                Row(
                  children: [
                    Expanded(child: TextField(controller: _controller)),
                    IconButton(
                      onPressed: () {
                        context.read<ConversationBloc>().add(
                          MessageSent(_controller.text),
                        );
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
      ),
    );
  }
}
