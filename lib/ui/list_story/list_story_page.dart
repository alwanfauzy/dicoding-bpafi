import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_ku/data/api/api_service.dart';
import 'package:story_ku/data/model/detail_story.dart';
import 'package:story_ku/data/pref/token_pref.dart';
import 'package:story_ku/provider/list_story_provider.dart';
import 'package:story_ku/ui/list_story/add_story_bottom_sheet.dart';
import 'package:story_ku/util/enums.dart';
import 'package:story_ku/widget/story_item.dart';

class ListStoryPage extends StatefulWidget {
  final VoidCallback onLogoutSuccess;

  const ListStoryPage({super.key, required this.onLogoutSuccess});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("List Story"),
        actions: [
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
      case ResultState.hasData:
        return RefreshIndicator(
            onRefresh: () => provider.getStories(),
            child: _gridStories(context, provider.stories));
      case ResultState.error:
      case ResultState.noData:
        return Center(child: Text(provider.message));
      default:
        return const Center(child: CircularProgressIndicator());
    }
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
        (index) => StoryItem(story: stories[index]),
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
      );
}
