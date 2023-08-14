import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/common.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/story.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/provider/list_story_provider.dart';
import 'package:story_ku/routes/list_page_manager.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/util/helper.dart';
import 'package:story_ku/widget/centered_loading.dart';
import 'package:story_ku/widget/custom_error.dart';
import 'package:story_ku/widget/flag_icon.dart';
import 'package:story_ku/widget/story_item.dart';

class ListStoryPage extends StatefulWidget {
  final VoidCallback onLogoutSuccess;
  final Function(String?) onStoryClicked;
  final VoidCallback onAddStoryClicked;

  const ListStoryPage({
    super.key,
    required this.onLogoutSuccess,
    required this.onStoryClicked,
    required this.onAddStoryClicked,
  });

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = ScrollController();
  late ListStoryProvider _listStoryProvider;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_infiniteScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _listStoryProvider.dispose();
  }

  _infiniteScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _listStoryProvider.getStories();
    }
  }

  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      widget.onAddStoryClicked();

      final pageManager = context.read<ListPageManager>();
      final shouldRefresh = await pageManager.waitForResult();

      if (shouldRefresh) {
        _refreshKey.currentState?.show();
      }
    } else if (status.isDenied) {
      showToast(AppLocalizations.of(context)!.permissionDeniedLocation);
    } else if (status.isPermanentlyDenied) {
      showToast(AppLocalizations.of(context)!.permissionDeniedForeverLocation);
    }
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
        onPressed: requestLocationPermission,
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
      _listStoryProvider = provider;

      return _handleListStoryState(provider);
    });
  }

  Widget _handleListStoryState(ListStoryProvider provider) {
    switch (provider.state) {
      case ResultState.noData:
        hasMoreData = false;
        return _content(context, provider);
      case ResultState.loading:
      case ResultState.hasData:
        return _content(context, provider);
      case ResultState.error:
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
      onRefresh: () => provider.getStories(isRefresh: true),
      child: _gridStories(
        context,
        provider.stories,
      ),
    );
  }

  Widget _gridStories(BuildContext context, List<Story> stories) {
    const columnCount = 2;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      controller: _scrollController,
      itemCount: stories.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < stories.length) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 200),
            columnCount: columnCount,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: StoryItem(
                  story: stories[index],
                  onStoryClicked: () =>
                      widget.onStoryClicked(stories[index].id),
                ),
              ),
            ),
          );
        } else if (hasMoreData) {
          return const CenteredLoading();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  _onLogoutPressed() {
    var tokenPref = TokenPref();
    tokenPref.setToken("");

    widget.onLogoutSuccess();
  }
}
