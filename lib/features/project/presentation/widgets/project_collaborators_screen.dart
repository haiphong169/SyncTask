import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/core/ui/user_circle_avatar.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/project_collaborators_screen_cubit.dart';
import 'package:project_collaboration_app/features/user/domain/entities/user.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProjectCollaboratorsScreen extends StatelessWidget {
  const ProjectCollaboratorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCollaboratorsScreenCubit, UiState<List<User>>>(
      listener: (context, state) {
        if (state is Error<List<User>>) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Collaborators')),
          body: switch (state) {
            Loading<List<User>>() => Center(child: CircularProgressIndicator()),
            Success<List<User>>(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final user = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: UserCircleAvatar(avatar: user.avatar),
                    title: Text(user.username),
                  ),
                );
              },
            ),
            _ => SizedBox(),
          },
        );
      },
    );
  }
}
