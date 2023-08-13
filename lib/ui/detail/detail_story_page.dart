import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/detail_story.dart';
import 'package:story_ku/provider/detail_story_provider.dart';
import 'package:story_ku/provider/map_provider.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/widget/centered_loading.dart';
import 'package:story_ku/widget/custom_error.dart';

class DetailStoryPage extends StatelessWidget {
  final String storyId;

  const DetailStoryPage({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.titleDetailStory)),
      body: _provider(context),
    );
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<DetailStoryProvider>(
      create: (context) => DetailStoryProvider(ApiService(), storyId),
      builder: (context, child) => _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer<DetailStoryProvider>(
      builder: (context, provider, _) {
        switch (provider.state) {
          case ResultState.loading:
            return const CenteredLoading();
          case ResultState.hasData:
            return _content(context, provider.story);
          case ResultState.error:
          case ResultState.noData:
            return CustomError(
              message: provider.message,
              onRefresh: () => provider.getDetailStory(storyId),
            );
          default:
            return Container();
        }
      },
    );
  }

  Widget _content(BuildContext context, Story story) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (story.photoUrl != null) _image(context, story.photoUrl!),
        _information(context, story),
        if (story.lat != null) _map(context, LatLng(story.lat!, story.lon!)),
      ],
    );
  }

  Widget _image(BuildContext context, String url) {
    return Image.network(
      url,
      height: 200,
      width: double.maxFinite,
      fit: BoxFit.fill,
    );
  }

  Widget _information(BuildContext context, Story story) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            story.name ?? "-",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            story.description ?? "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _map(BuildContext context, LatLng location) {
    return Expanded(
      child: ChangeNotifierProvider(
        create: (context) => MapProvider(ApiService(), location),
        builder: (context, child) {
          return Consumer<MapProvider>(
            builder: (context, provider, _) {
              switch (provider.state) {
                case ResultState.loading:
                  return const CenteredLoading();
                case ResultState.hasData:
                  return GoogleMap(
                    markers: {
                      Marker(
                        markerId: MarkerId(location.toString()),
                        position: location,
                        infoWindow: InfoWindow(
                          title: provider.address,
                          snippet: location.toString(),
                        ),
                      )
                    },
                    initialCameraPosition: CameraPosition(
                      target: location,
                      zoom: 18,
                    ),
                  );
                case ResultState.error:
                case ResultState.noData:
                  return CustomError(
                    message: provider.message,
                    onRefresh: () => provider.getAddress(location),
                  );
                default:
                  return Container();
              }
            },
          );
        },
      ),
    );
  }
}
