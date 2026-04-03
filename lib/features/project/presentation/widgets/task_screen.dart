import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/task_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({super.key, required this.taskName});
  final String taskName;
  Task? latestTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskName),
        actions: [
          IconButton(
            onPressed: () {
              context.read<TaskCubit>().deleteTask();
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocListener<TaskCubit, UiState<Task>>(
        listener: (context, state) {
          if (state is Error<Task>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is OnNavigationPop<Task>) {
            context.pop();
          } else if (state is Success<Task>) {
            latestTask = state.data;
          }
        },
        child: BlocBuilder<TaskCubit, UiState<Task>>(
          builder: (context, state) {
            return Stack(
              children: [
                if (state is Success<Task>) ...[
                  _taskDetails(context, state.data),
                ] else if (state is Loading<Task>) ...[
                  latestTask != null
                      ? _taskDetails(context, latestTask!)
                      : SizedBox(),
                  Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _taskDetails(BuildContext context, Task task) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 32),
          Container(
            color: colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.read<TaskCubit>().checkTask(newValue);
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
                  Text(
                    task.name,
                    style: textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
