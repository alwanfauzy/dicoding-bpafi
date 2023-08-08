import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/detail_story.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/provider/list_story_provider.dart';
import 'package:story_ku/ui/list_story/add_story_bottom_sheet.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/widget/centered_loading.dart';
import 'package:story_ku/widget/custom_error.dart';
import 'package:story_ku/widget/flag_icon.dart';
import 'package:story_ku/widget/story_item.dart';

class ListStoryPage extends StatefulWidget {
  final VoidCallback onLogoutSuccess;
  final Function(String?) onStoryClicked;

  const ListStoryPage(
      {super.key, required this.onLogoutSuccess, required this.onStoryClicked});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.titleListStory),
        actions: [
          const FlagIcon(),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _onLogoutPressed,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddStoryPressed,
        child: const Icon(Icons.add),
      ),
      body: _provider(context),
    );
  }

  Widget _provider(BuildContext context) {
    return ChangeNotifierProvider<ListStoryProvider>(
      create: (context) => ListStoryProvider(ApiService()),
      builder: (context, child) => _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Consumer<ListStoryProvider>(builder: (context, provider, _) {
      return _handleListStoryState(provider);
    });
  }

  Widget _handleListStoryState(ListStoryProvider provider) {
    switch (provider.state) {
      case ResultState.loading:
        return const CenteredLoading();
      case ResultState.hasData:
        return _content(context, provider);
      case ResultState.error:
      case ResultState.noData:
        return CustomError(
          message: provider.message,
          onRefresh: () => provider.getStories(),
        );
      default:
        return Container();
    }
  }

  Widget _content(BuildContext context, ListStoryProvider provider) {
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () => provider.getStories(),
      child: _gridStories(
        context,
        provider.stories,
      ),
    );
  }

  Widget _gridStories(BuildContext context, List<Story> stories) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      crossAxisCount: 2,
      shrinkWrap: true,
      children: List.generate(
        stories.length,
        (index) => StoryItem(
          story: stories[index],
          onStoryClicked: () => widget.onStoryClicked(stories[index].id),
        ),
      ),
    );
  }

  _onLogoutPressed() {
    var tokenPref = TokenPref();
    tokenPref.setToken("");

    widget.onLogoutSuccess();
  }

  _onAddStoryPressed() => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: ((context) => const AddStoryBottomSheet()),
      ).then((value) => _refreshKey.currentState?.show());
}
