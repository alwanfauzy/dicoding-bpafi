import 'package:flutter/material.dart';
import 'package:story_ku/util/form_validator.dart';
import 'package:story_ku/widget/pill_indicator.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_bottom_sheet.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  State<RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeBottomSheet(
      children: [
        _header(context),
        _form(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        const PillIndicator(),
        Text("Register", style: Theme.of(context).textTheme.headlineSmall),
        Text(
          "Create account to login this app",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: validateEmail,
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: validatePassword,
          ),
          const SizedBox(height: 16),
          PrimaryButton(text: "Register", onPressed: _onRegisterPressed),
        ],
      ),
    );
  }

  _onRegisterPressed() {
    if (_formKey.currentState?.validate() == true) {}
  }
}
