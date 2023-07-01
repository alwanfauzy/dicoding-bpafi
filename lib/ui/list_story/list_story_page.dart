import 'package:flutter/material.dart';
import 'package:story_ku/ui/list_story/add_story_bottom_sheet.dart';
import 'package:story_ku/widget/story_item.dart';

class ListStoryPage extends StatefulWidget {
  const ListStoryPage({super.key});

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
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onListStoryRefresh,
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        crossAxisCount: 2,
        shrinkWrap: true,
        children: List.generate(100, (index) => StoryItem()),
      ),
    );
  }

  _onLogoutPressed() => Navigator.pop(context);

  _onAddStoryPressed() => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: ((context) => const AddStoryBottomSheet()),
      );

  Future<void> _onListStoryRefresh() {
    return Future(() => null);
  }
}
