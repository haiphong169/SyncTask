import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/project_screen_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({
    super.key,
    required this.projectName,
    required this.backgroundColorValue,
  });

  final String projectName;
  final int backgroundColorValue;

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  String _newTaskListName = '';
  bool _isAddingNewTaskList = false;
  String? _addingTaskListUid;
  String _newTaskName = '';
  List<TaskHeader>? _currentHeaders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        widget.backgroundColorValue,
      ).withValues(alpha: 0.6),
      appBar: _appBar(),
      body: BlocBuilder<ProjectScreenCubit, UiState<List<TaskList>>>(
        builder: (context, state) {
          switch (state) {
            case Success(:final data):
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 16,
                ),
                child: SizedBox(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ..._buildTaskLists(data),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isAddingNewTaskList = true;
                            });
                          },
                          child: SizedBox(
                            width: 250,
                            height: 75,
                            child: Card(
                              color: Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child:
                                      _isAddingNewTaskList
                                          ? TextField(
                                            decoration: InputDecoration(
                                              fillColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.surface,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.blue,
                                                      width: 2,
                                                    ),
                                                  ),
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'List name',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                _newTaskListName = value;
                                              });
                                            },
                                          )
                                          : Icon(Icons.add),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            case Loading():
              return Center(child: CircularProgressIndicator());
            case Error(:final message):
              return Center(child: Text(message));
            default:
              return SizedBox();
          }
        },
      ),
    );
  }

  AppBar _appBar() {
    if (_isAddingNewTaskList) {
      return AppBar(
        title: Text('Add list'),
        actions: [
          IconButton(
            onPressed:
                _newTaskListName.isEmpty
                    ? null
                    : () {
                      context.read<ProjectScreenCubit>().addTaskList(
                        _newTaskListName,
                      );
                      setState(() {
                        _newTaskListName = '';
                        _isAddingNewTaskList = false;
                      });
                    },
            icon: Icon(Icons.done),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              _newTaskListName = '';
              _isAddingNewTaskList = false;
            });
          },
          icon: Icon(Icons.close),
        ),
        backgroundColor: Color(widget.backgroundColorValue),
      );
    } else if (_isAddingNewTask) {
      return AppBar(
        title: Text('Add task'),
        actions: [
          IconButton(
            onPressed:
                _newTaskName.isEmpty
                    ? null
                    : () {
                      context.read<ProjectScreenCubit>().addTask(
                        _addingTaskListUid!,
                        _currentHeaders!,
                        _newTaskName,
                      );
                      setState(() {
                        _addingTaskListUid = null;
                        _currentHeaders = null;
                        _newTaskName = '';
                      });
                    },
            icon: Icon(Icons.check),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            setState(() {
              _newTaskName = '';
              _addingTaskListUid = null;
              _currentHeaders = null;
            });
          },
          icon: Icon(Icons.close),
        ),
      );
    } else {
      return AppBar(
        title: Text(widget.projectName),
        backgroundColor: Color(widget.backgroundColorValue),
      );
    }
  }

  List<Widget> _buildTaskLists(List<TaskList> taskLists) {
    final theme = Theme.of(context);

    return taskLists.map((taskList) {
      return SizedBox(
        width: 250,
        child: Card(
          color: theme.colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        taskList.name,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                  ],
                ),
                taskList.taskHeaders.isEmpty
                    ? SizedBox()
                    : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: taskList.taskHeaders.length,
                      itemBuilder: (context, index) {
                        final header = taskList.taskHeaders[index];
                        return Row(children: [Text(header.name)]);
                      },
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child:
                      _isAddingNewTask && _addingTaskListUid == taskList.uid
                          ? TextField(
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).colorScheme.surface,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Task name',
                            ),
                            onChanged: (value) {
                              setState(() {
                                _newTaskName = value;
                              });
                            },
                          )
                          : TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _addingTaskListUid = taskList.uid;
                                _currentHeaders = taskList.taskHeaders;
                              });
                            },
                            icon: Icon(Icons.add, size: 16, color: Colors.blue),
                            label: Text(
                              'Add task',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  bool get _isAddingNewTask =>
      _addingTaskListUid != null && _currentHeaders != null;
}
