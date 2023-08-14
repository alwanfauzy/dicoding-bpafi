import 'package:flutter/material.dart';
import 'package:story_ku/data/model/story.dart';

class StoryItem extends StatelessWidget {
  final Story story;
  final VoidCallback onStoryClicked;

  const StoryItem({super.key, required this.story, required this.onStoryClicked});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: InkWell(
        onTap: onStoryClicked,
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(story.photoUrl ?? ""),
              fit: BoxFit.cover,
              opacity: 0.5,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              story.name ?? "",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }
}
