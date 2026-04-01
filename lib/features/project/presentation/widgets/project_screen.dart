import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/features/project/domain/entities/task_list.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/project_screen_cubit.dart';
import 'package:project_collaboration_app/utils/logger.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          _isAddingNewTaskList
              ? AppBar(
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
              )
              : AppBar(
                title: Text(widget.projectName),
                backgroundColor: Color(widget.backgroundColorValue),
              ),
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
                            width: 225,
                            height: 75,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child:
                                      _isAddingNewTaskList
                                          ? TextField(
                                            decoration: InputDecoration(
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

  List<Widget> _buildTaskLists(List<TaskList> taskLists) {
    return taskLists
        .map(
          (taskList) => SizedBox(
            height: 75,
            width: 225,
            child: Card(child: Center(child: Text(taskList.name))),
          ),
        )
        .toList();
  }
}
