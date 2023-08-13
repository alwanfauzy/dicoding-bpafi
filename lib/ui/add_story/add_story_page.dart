import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/request/add_story_request.dart';
import 'package:story_ku/provider/add_story_provider.dart';
import 'package:story_ku/routes/list_page_manager.dart';
import 'package:story_ku/routes/location_page_manager.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/primary_button.dart';
import 'package:story_ku/widget/safe_scaffold.dart';
import 'package:story_ku/widget/secondary_button.dart';

class AddStoryPage extends StatefulWidget {
  final VoidCallback onSuccessAddStory;
  final VoidCallback onAddLocationClicked;

  const AddStoryPage(
      {super.key,
      required this.onSuccessAddStory,
      required this.onAddLocationClicked});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
  }

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
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
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
          SecondaryButton(
            text: (_selectedLocation != null)
                ? AppLocalizations.of(context)!.locationLatLng(
                    _selectedLocation!.latitude, _selectedLocation!.longitude)
                : AppLocalizations.of(context)!.titleAddLocation,
            onPressed: () async {
              widget.onAddLocationClicked();
              final locationManager = context.read<LocationPageManager>();
              var result = await locationManager.waitForResult();

              setState(() {
                _selectedLocation = result;
              });
            },
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
        description: _descriptionController.text,
        photo: _selectedImage!,
        lat: _selectedLocation?.latitude,
        lon: _selectedLocation?.longitude,
      );
      provider.addStory(request);
    }
  }

  _handleAddStoryState(AddStoryProvider provider) {
    switch (provider.state) {
      case ResultState.hasData:
        showToast(provider.message);
        afterBuildWidgetCallback(() {
          context.read<ListPageManager>().returnData(true);
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
