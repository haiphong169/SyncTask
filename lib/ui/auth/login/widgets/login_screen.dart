import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/routing/routes.dart';
import 'package:project_collaboration_app/ui/auth/login/view_models/login_view_model.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';
import 'package:project_collaboration_app/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginViewModel, VoidUiState>(
      bloc: widget.viewModel,
      listener: (_, _) {},
      builder: (context, state) {
        final isLoading = state is Loading<void>;
        final isError = state is Error<void>;

        return Scaffold(
          appBar: AppBar(title: const Text('Login'), centerTitle: true),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    const Text('Email'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'myemail@example.com',
                      ),
                      validator: (v) => Validators.validateEmail(v),
                    ),
                    const SizedBox(height: 16),

                    const Text('Password'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter password',
                      ),
                      validator:
                          (v) => Validators.validateGenericStringField(
                            v,
                            'Password',
                          ),
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                FocusScope.of(context).unfocus();
                                widget.viewModel.login(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.0),
                        child:
                            isLoading
                                ? CircularProgressIndicator()
                                : Text('Login'),
                      ),
                    ),
                    if (isError) ...[
                      const SizedBox(height: 4),
                      Text(
                        state.message,
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium!.copyWith(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            context.go(Routes.register);
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
