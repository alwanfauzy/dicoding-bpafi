import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/register_request.dart';
import 'package:story_ku/provider/register_provider.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/form_validator.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_bottom_sheet.dart';

class RegisterBottomSheet extends StatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  State<RegisterBottomSheet> createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
    return SafeBottomSheet(child: _provider(context));
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<RegisterProvider>(
      create: (context) => RegisterProvider(ApiService()),
      child: Column(
        children: [
          _header(context),
          _form(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
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
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          const SizedBox(height: 8),
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
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            validator: validatePassword,
          ),
          const SizedBox(height: 16),
          Consumer<RegisterProvider>(builder: (context, provider, _) {
            _handleRegisterState(provider);

            return PrimaryButton(
              isLoading: provider.registerState == ResultState.loading,
              text: "Register",
              onPressed: () => _onRegisterPressed(provider),
            );
          }),
        ],
      ),
    );
  }

  _onRegisterPressed(RegisterProvider provider) {
    if (_formKey.currentState?.validate() == true) {
      provider.register(_getRegisterRequest());
    }
  }

  _handleRegisterState(RegisterProvider provider) {
    switch (provider.registerState) {
      case ResultState.hasData:
        showToast(provider.registerMessage);
        Navigator.pop(context);
        break;
      case ResultState.noData:
      case ResultState.error:
        showToast(provider.registerMessage);
        break;
      default:
        break;
    }
  }

  _getRegisterRequest() => RegisterRequest(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
}
