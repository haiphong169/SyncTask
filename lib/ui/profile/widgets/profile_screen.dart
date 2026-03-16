import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_collaboration_app/ui/auth/logout/view_models/logout_view_model.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.viewModel});

  final LogoutViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LogoutViewModel, VoidUiState>(
      bloc: viewModel,
      listener: (_, __) {},
      builder: (context, state) {
        final isLoading = state is Loading<void>;
        final isError = state is Error<void>;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: isLoading ? null : viewModel.logout,
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
          ),
        );
      },
    );
  }
}
