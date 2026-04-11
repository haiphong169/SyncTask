import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/inbox/presentation/bloc/inbox_cubit.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InboxCubit, UiState<List<Task>>>(
      listener: (context, state) {
        if (state is Error<List<Task>>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 12),
                    Text(
                      'Inbox',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 36),
                    Expanded(
                      child: Card(
                        margin: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 100,
                        ),

                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 16,
                          ),
                          child: _buildInboxList(
                            context,
                            state.getData() ?? [],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (state is Loading<List<Task>>)
                  Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInboxList(BuildContext context, List<Task> inbox) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: inbox.length,
      itemBuilder: (context, index) {
        final task = inbox[index];
        return Card(
          color: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<InboxCubit>().checkTask(
                        task.projectUid,
                        task.taskListUid,
                        task.uid,
                        newValue,
                      );
                    }
                  },
                  shape: CircleBorder(),
                  checkColor: Colors.white,
                  fillColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green;
                    }
                    return Colors.transparent;
                  }),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.taskWithId(task.uid),
                        extra: {
                          'taskName': task.name,
                          'projectUid': task.projectUid,
                          'taskListUid': task.taskListUid,
                        },
                      );
                    },
                    child: Text(task.name, style: textTheme.titleMedium),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
