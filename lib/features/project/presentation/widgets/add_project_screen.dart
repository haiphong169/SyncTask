import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_collaboration_app/features/project/presentation/bloc/add_project_cubit.dart';
import 'package:project_collaboration_app/utils/ui_state.dart';
import 'package:project_collaboration_app/utils/validators.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  static const List<Color> _colorOptions = [
    Color(0xFF6C63FF),
    Color(0xFF43C6AC),
    Color(0xFFFF6584),
    Color(0xFFFFB347),
    Color(0xFF4FC3F7),
    Color(0xFF81C784),
    Color(0xFFBA68C8),
    Color(0xFFFF7043),
  ];

  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _selectedColor = _colorOptions.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddProjectCubit, VoidUiState>(
      listener: (context, state) {
        if (state is Success<void>) {
          context.pop();
        } else if (state is Error<void>) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is Loading<void>;

        return Scaffold(
          appBar: AppBar(
            title: const Text('New Project'),
            centerTitle: true,
          ),
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
                      'Project name',
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'e.g. Mobile App Redesign',
                      ),
                      validator:
                          (v) => Validators.validateGenericStringField(
                            v,
                            'Project name',
                          ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Background color'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          _colorOptions.map((color) {
                            final isSelected = color == _selectedColor;
                            return GestureDetector(
                              onTap:
                                  () => setState(() => _selectedColor = color),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Theme.of(context).colorScheme.onSurface
                                            : Colors.transparent,
                                    width: 3,
                                  ),
                                  boxShadow:
                                      isSelected
                                          ? [
                                            BoxShadow(
                                              color: color.withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                          : [],
                                ),
                                child:
                                    isSelected
                                        ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                        : null,
                              ),
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (!_formKey.currentState!.validate()) return;
                                FocusScope.of(context).unfocus();
                                context.read<AddProjectCubit>().addProject(
                                  _nameController.text.trim(),
                                  _selectedColor.value,
                                );
                              },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child:
                            isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Create Project'),
                      ),
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
