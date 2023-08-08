import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/detail_story.dart';
import 'package:story_ku/provider/detail_story_provider.dart';
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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (story.photoUrl != null)
              Image.network(
                story.photoUrl!,
              ),
            const SizedBox(height: 16, width: double.maxFinite),
            Text(
              story.name ?? "-",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              story.description ?? "-",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
