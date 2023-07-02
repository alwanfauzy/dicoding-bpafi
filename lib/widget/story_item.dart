import 'package:flutter/material.dart';
import 'package:story_ku/ui/detail/detail_story_page.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DetailStoryPage())),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(child: Text("Halo")),
        ),
      ),
    );
  }
}
