import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/login_request.dart';
import 'package:story_ku/provider/login_provider.dart';
import 'package:story_ku/ui/register/register_bottom_sheet.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/form_validator.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_scaffold.dart';
import 'package:story_ku/widget/secondary_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) => _onRegisterPressed());
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(body: _provider(context));
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>(
      create: (context) => LoginProvider(ApiService()),
      child: _body(context),
    );
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
        const SizedBox(height: 16),
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
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              border: 
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: validatePassword,
          ),
          const SizedBox(height: 16),
          Consumer<LoginProvider>(builder: (context, provider, _) {
            _handleLoginState(provider);

            return PrimaryButton(
              text: "Login",
              onPressed: () => _onLoginPressed(provider),
            );
          }),
          const SizedBox(height: 8),
          SecondaryButton(
            text: "Register",
            onPressed: () => _onRegisterPressed(),
          ),
        ],
      ),
    );
  }

  _onLoginPressed(LoginProvider provider) {
    if (_formKey.currentState?.validate() == true) {
      provider.login(_getLoginRequest());
    }
  }

  _onRegisterPressed() => showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: ((context) => const RegisterBottomSheet()),
      );

  _handleLoginState(LoginProvider provider) {
    switch (provider.loginState) {
      case ResultState.loading:
        EasyLoading.show();
        break;
      case ResultState.hasData:
        break;
      case ResultState.noData:
      case ResultState.error:
        EasyLoading.showError(provider.loginMessage);
        break;
      default:
        break;
    }
  }

  _getLoginRequest() => LoginRequest(
        email: _emailController.text,
        password: _passwordController.text,
      );
}
