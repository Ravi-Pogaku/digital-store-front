import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';

// class needed for searchBar, responsible for building the searchBar and
// showing relevant search terms/products when a user makes a query.

class CustomSearchDelegate extends SearchDelegate {
  final searchTerms = const [
    'Electronics',
    'Computer',
    'Kitchen',
    'Video games',
    'Clothes',
    'Cosmetics',
    'Game console',
    'Shoes',
  ];

  // New actions built on the right of search bar
  @override
  List<Widget>? buildActions(BuildContext context) {
    // x-button for clearing the search bar
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  // Builds thing before the search bar
  @override
  Widget? buildLeading(BuildContext context) {
    // back button to stop searching
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // results of the user's search, shows up after presses button to complete typing, or
  // if user chooses a tag.
  @override
  Widget buildResults(BuildContext context) {
    List<Product> productList = Provider.of<List<Product>>(context);

    List<Product> matches = [];
    for (var product in productList) {
      List categoriesInLowercase =
          product.categories!.map((cat) => cat.toLowerCase()).toList();

      if (categoriesInLowercase
              .any((cat) => cat.contains(query.toLowerCase())) ||
          product.title!.toLowerCase().contains(query.toLowerCase())) {
        matches.add(product);
      }
    }

    // remove duplicate items
    matches = matches.toSet().toList();

    //after finding matches, build a listview of all matched products
    return ListView.separated(
      // if empty, then itemCount is 1 and its just listtile "no products found"
      itemCount: (matches.isNotEmpty) ? matches.length : 1,
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 3,
        );
      },
      itemBuilder: (context, index) {
        return (matches.isNotEmpty)
            ? ListTile(
                title: SizedBox(
                  height: 200,
                  child: Image.network(matches[index].imageUrl!),
                ),
                subtitle: Text(
                  matches[index].title!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // when a product is tapped, show that product's page
                  Navigator.pushNamed(
                    context,
                    "/ProductPage",
                    arguments: {
                      'title': 'Product',
                      'product': matches[index],
                    },
                  );
                },
              )
            : const ListTile(
                title: Text(
                  "No Terms/Products Found",
                  style: TextStyle(fontSize: 20),
                ),
              );
      },
    );
  }

  // shows suggestions for user when typing
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    List<String> matches = [];
    for (var term in searchTerms) {
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matches.add(term);
      }
    }

    if (query.isNotEmpty) {
      for (var product in products) {
        if (product.title!.toLowerCase().contains(query.toLowerCase())) {
          matches.add(product.title!);
        }
      }
    }

    matches = matches.toSet().toList();

    //after finding matches, build a listview of all matches
    return ListView.builder(
      itemCount: (matches.isNotEmpty) ? matches.length : 1,
      itemBuilder: (context, index) {
        return (matches.isNotEmpty)
            ? ListTile(
                title: Text(
                  matches[index],
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  // when item is tapped, close the search bar and return user's
                  // choice which is then used to push route to the selected
                  //product's page
                  query = matches[index];
                  showResults(context);
                },
              )
            : const ListTile(
                title: Text(
                  "No Terms/Products Found",
                  style: TextStyle(fontSize: 20),
                ),
              );
      },
    );
  }
}
