import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/project/domain/entities/project.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/home_screen_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 12, right: 12),
        child: BlocBuilder<HomeScreenCubit, UiState<List<Project>>>(
          builder:
              (context, state) => switch (state) {
                Success(:final data) => Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 100,
                    ),
                    child: _buildProjectList(data),
                  ),
                ),
                Loading() => CircularProgressIndicator(),
                Error(:final message) => Text(message),
                _ => SizedBox(),
              },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.push(Routes.addProject);
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              SizedBox(width: 12),
              Text('Add new project'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectList(List<Project> data) {
    if (data.isEmpty) return SizedBox();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final theme = Theme.of(context);
        final project = data[index];
        return Card(
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: ListTile(
            leading: Container(
              height: 30,
              width: 50,
              color: Color(project.backgroundColorValue),
            ),
            title: Text(data[index].name, style: theme.textTheme.titleMedium),
            onTap: () {
              context.push(Routes.projectWithId(data[index].uid));
            },
          ),
        );
      },
    );
  }
}
