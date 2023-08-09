import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/register_request.dart';
import 'package:story_ku/provider/register_provider.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/form_validator.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_scaffold.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onRegisterSuccess;

  const RegisterPage({super.key, required this.onRegisterSuccess});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    return SafeScaffold(
      body: _provider(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.buttonRegister),
      ),
    );
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<RegisterProvider>(
      create: (context) => RegisterProvider(ApiService()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
        child: Column(
          children: [
            _header(context),
            _form(context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.createAccount,
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
              labelText: AppLocalizations.of(context)!.fieldName,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.fieldEmail,
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
              labelText: AppLocalizations.of(context)!.fieldPassword,
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
              text: AppLocalizations.of(context)!.buttonRegister,
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
        afterBuildWidgetCallback(() => widget.onRegisterSuccess());
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
