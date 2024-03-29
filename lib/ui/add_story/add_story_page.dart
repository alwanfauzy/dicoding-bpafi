import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/add_story_request.dart';
import 'package:story_ku/provider/add_story_provider.dart';
import 'package:story_ku/routes/page_manager.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_scaffold.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onSuccessAddStory;

  const AddStoryPage({super.key, required this.onSuccessAddStory});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
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
    return SafeScaffold(
      body: _provider(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleAddStory),
      ),
    );
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<AddStoryProvider>(
      create: (context) => AddStoryProvider(ApiService()),
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
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
        Text(
          AppLocalizations.of(context)!.createStory,
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
                    AppLocalizations.of(context)!.selectImage,
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
              labelText: AppLocalizations.of(context)!.fieldDescription,
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
              text: AppLocalizations.of(context)!.buttonUpload,
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
        afterBuildWidgetCallback(() {
          context.read<PageManager>().returnData(true);
          widget.onSuccessAddStory();
        });
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
