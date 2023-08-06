import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/add_story_request.dart';
import 'package:story_ku/provider/add_story_provider.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/helper.dart';
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
  File? _selectedImage;

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeBottomSheet(child: _provider(context));
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<AddStoryProvider>(
      create: (context) => AddStoryProvider(ApiService()),
      child: _body(context),
    );
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
            child: InkWell(
              onTap: () => _selectImage(),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_selectedImage != null)
                    Opacity(
                      opacity: 0.8,
                      child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          child: Image.file(_selectedImage!)),
                    ),
                  Text(
                    "Select Image",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
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
          ),
          const SizedBox(height: 8),
          Consumer<AddStoryProvider>(builder: (context, provider, _) {
            _handleAddStoryState(provider);

            return PrimaryButton(
              isLoading: provider.state == ResultState.loading,
              onPressed: () => _onUploadPressed(provider),
              text: "Upload",
            );
          }),
        ],
      ),
    );
  }

  _onUploadPressed(AddStoryProvider provider) {
    if (_formKey.currentState?.validate() == true && _selectedImage != null) {
      AddStoryRequest request = AddStoryRequest(
          description: _descriptionController.text, photo: _selectedImage!);
      provider.addStory(request);
    }
  }

  _handleAddStoryState(AddStoryProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        showToast(provider.message);
        Navigator.pop(context);
        break;
      case ResultState.error:
      case ResultState.noData:
        showToast(provider.message);
        break;
      default:
        break;
    }
  }

  Future<void> _selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }
}
