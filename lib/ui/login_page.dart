import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_scaffold.dart';
import 'package:story_ku/widget/secondary_button.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
      child: Column(
        children: [
          _loginHeader(context),
          _loginForm(context),
        ],
      ),
    );
  }

  Widget _loginHeader(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/storyku.svg',
          width: 100,
          height: 100,
        ),
        Text(
          "StoryKu",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "Welcome to StoryKu Flutter Version",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "alwanfauzy © 2023",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              labelText: "Email",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: TextEditingController(),
            decoration: InputDecoration(
              labelText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 16),
          PrimaryButton(text: "Login", onPressed: _onLoginPressed),
          const SizedBox(height: 8),
          SecondaryButton(onPressed: () {}, text: "Register"),
        ],
      ),
    );
  }

  _onLoginPressed() {
    if (_formKey.currentState?.validate() == true) {}
  }

  String? _validateEmail(String? value) =>
      !isEmail(value.toString()) ? "Invalid Email Format" : null;

  String? _validatePassword(String? value) => (value!.length < 8)
      ? "Password must contains minimum 8 characters"
      : null;
}
