import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/config/routing/routes.dart';
import 'package:project_collaboration_app/features/messaging/domain/usecases/conversation/check_existing_conversation_usecase.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_bloc.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_event.dart';
import 'package:project_collaboration_app/features/user/presentation/bloc/search_user_state.dart';
import 'package:project_collaboration_app/features/user/presentation/widgets/user_search_bar.dart';
import 'package:project_collaboration_app/utils/result.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({
    super.key,
    required this.origin,
    required this.usecase,
  });
  final String origin;
  final CheckExistingConversationUsecase usecase;

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 36),
            UserSearchBar(
              onChanged: (query) {
                context.read<SearchUserBloc>().add(SearchQueryChanged(query));
              },
              onClear: () {
                _controller.clear();
                context.read<SearchUserBloc>().add(SearchCleared());
              },
              textController: _controller,
              focusNode: _focusNode,
            ),
            SizedBox(height: 36),
            Expanded(
              child: BlocBuilder<SearchUserBloc, SearchUserState>(
                builder: (context, state) {
                  switch (state) {
                    case SearchInitial():
                      return SizedBox.shrink();

                    case SearchLoading():
                      return Center(child: CircularProgressIndicator());

                    case SearchEmpty():
                      return Center(child: Text("No users found"));

                    case SearchError():
                      return Center(child: Text(state.message));

                    case SearchSuccess():
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (_, i) {
                          final user = state.users[i];
                          return ListTile(
                            title: Text(user.username),
                            onTap: () async {
                              final partnerUid = user.uid;
                              if (widget.origin == Routes.messages) {
                                final result = await widget.usecase(partnerUid);

                                switch (result) {
                                  case Ok(data: final conversationId):
                                    if (conversationId != null && mounted) {
                                      context.push(
                                        Routes.conversationWithId(
                                          conversationId,
                                        ),
                                      );
                                    } else {
                                      context.push(
                                        Routes.mockConversationWithId(
                                          partnerUid,
                                        ),
                                      );
                                    }

                                  case Failure():
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Failed to check conversation',
                                        ),
                                      ),
                                    );
                                }
                              }
                            },
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
