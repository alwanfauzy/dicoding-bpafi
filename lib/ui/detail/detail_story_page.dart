import 'package:flutter/material.dart';
import 'package:story_ku/widget/safe_scaffold.dart';

class DetailStoryPage extends StatelessWidget {
  const DetailStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScaffold(
      appBar: AppBar(title: const Text("Detail Story")),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _image(context),
          _description(context),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: Theme.of(context).dividerColor),
    );
  }

  Widget _description(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16, width: double.maxFinite),
        Text(
          "Description",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          "Lorem ipsum dolor sit",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
