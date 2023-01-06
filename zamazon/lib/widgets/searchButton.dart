import 'package:flutter/material.dart';
import 'customSearchDelegate.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        // when a user taps a result, it will be returned here.
        await showSearch(context: context, delegate: CustomSearchDelegate());
      },
      icon: const Icon(Icons.search),
    );
  }
}
