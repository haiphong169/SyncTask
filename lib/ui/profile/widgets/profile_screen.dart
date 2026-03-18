import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/domain/models/user.dart';
import 'package:project_collaboration_app/ui/auth/auth_view_model.dart';
import 'package:project_collaboration_app/ui/auth/logout_view_model.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.logoutViewModel,
    required this.authViewModel,
  });

  final LogoutViewModel logoutViewModel;
  final AuthViewModel authViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<AuthViewModel, UiState<User>>(
              bloc: authViewModel,
              listener: (_, __) {},
              builder: (context, state) {
                return switch (state) {
                  Loading<User>() => CircularProgressIndicator(),
                  Error<User>(:final message) => Text(message),
                  Success<User>(:final data) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundColor: Color(data.avatar.backgroundColor),
                        child: Text(
                          state.data.avatar.initials,
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(state.data.avatar.textColor),
                          ),
                        ),
                      ),
                      Text(data.username),
                    ],
                  ),
                  Idle<User>() => SizedBox(),
                };
              },
            ),
            BlocConsumer<LogoutViewModel, VoidUiState>(
              bloc: logoutViewModel,
              listener: (_, __) {},
              builder: (context, state) {
                final isLoading = state is Loading<void>;
                final isError = state is Error<void>;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: isLoading ? null : logoutViewModel.logout,
                      child:
                          isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Logout'),
                    ),
                    if (isError) ...[
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.red),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
