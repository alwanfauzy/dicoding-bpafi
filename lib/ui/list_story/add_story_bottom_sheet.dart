import 'package:flutter/material.dart';
import 'package:story_ku/util/form_validator.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_bottom_sheet.dart';

class AddStoryBottomSheet extends StatefulWidget {
  const AddStoryBottomSheet({super.key});

  @override
  State<AddStoryBottomSheet> createState() => _AddStoryBottomSheetState();
}

class _AddStoryBottomSheetState extends State<AddStoryBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeBottomSheet(child: _body(context));
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        _header(context),
        _form(context),
      ],
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text("Add Story", style: Theme.of(context).textTheme.headlineSmall),
        Text(
          "Create and upload your story",
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
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  "Select Image",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            validator: validateEmail,
          ),
          const SizedBox(height: 8),
          PrimaryButton(onPressed: _onUploadPressed, text: "Upload"),
        ],
      ),
    );
  }

  _onUploadPressed() {
    if (_formKey.currentState?.validate() == true) {}
  }
}
