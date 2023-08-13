import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/routes/location_page_manager.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/centered_loading.dart';

class AddLocationPage extends StatefulWidget {
  final VoidCallback onSuccessAddStory;

  const AddLocationPage({super.key, required this.onSuccessAddStory});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;
  final Set<Marker> _markers = {};

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.titleAddLocation),
        actions: [
          if (_selectedLocation != null) _selectButton(context),
        ],
      ),
    );
  }

  Widget _selectButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<LocationPageManager>().returnData(_selectedLocation!);
        widget.onSuccessAddStory();
      },
      icon: const Icon(Icons.check),
    );
  }

  Widget _body(BuildContext context) {
    return FutureBuilder(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: snapshot.data!, zoom: 18),
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              markers: _markers,
            );
          } else {
            return const CenteredLoading();
          }
        });
  }

  Future<LatLng> _getCurrentLocation() async {
    final location = Location();
    LocationData locationData;
    try {
      locationData = await location.getLocation();
      return LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0);
    } catch (e) {
      showToast('Error getting current location: $e');
      return const LatLng(0, 0);
    }
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _markers.clear(); // Clear existing markers
      _markers.add(Marker(
        markerId: const MarkerId('selectedLocation'),
        position: latLng,
      ));
    });
  }
}
