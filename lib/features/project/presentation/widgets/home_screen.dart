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
        padding: const EdgeInsets.only(top: 24, left: 12, right: 12),
        child: Center(
          child: BlocBuilder<HomeScreenCubit, UiState<List<Project>>>(
            builder:
                (context, state) => switch (state) {
                  Success(:final data) => _buildProjectList(data),
                  Loading() => CircularProgressIndicator(),
                  Error(:final message) => Text(message),
                  _ => SizedBox(),
                },
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          context.push(Routes.addProject);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
      itemCount: data.length,
      itemBuilder:
          (context, index) => ListTile(
            title: Text(data[index].name),
            onTap: () {
              context.push(Routes.projectWithId(data[index].uid));
            },
          ),
    );
  }
}
