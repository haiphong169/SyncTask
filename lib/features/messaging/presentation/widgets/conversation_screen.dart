import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/messaging/domain/entities/message.dart';
import 'package:project_collaboration_app/features/messaging/presentation/bloc/conversation_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

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
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ConversationCubit, ConversationState>(
                builder:
                    (context, state) => switch (state) {
                      Success<List<Message>>(:final data) => ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => Text(data[index].text),
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
                    context.read<ConversationCubit>().sendMessage(
                      _controller.text,
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
    );
  }
}
