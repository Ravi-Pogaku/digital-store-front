import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/Product.dart';

import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/widgets/navigateToProductPage.dart';
import 'package:zamazon/widgets/productImage.dart';
import 'package:zamazon/globals.dart';

// class needed for searchBar, responsible for building the searchBar and
// showing relevant search terms/products when a user makes a query.

class CustomSearchDelegate extends SearchDelegate {
  final List<String> searchTerms;

  CustomSearchDelegate({this.searchTerms = categories});

  // New actions built on the right of the search bar
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

  // new actions built on the left of the search bar
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

    Color textColor = Provider.of<SettingsBLoC>(context).isDarkMode
        ? Colors.white
        : Colors.black;

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
        double height = MediaQuery.of(context).size.height;

        return (matches.isNotEmpty)
            ? NavigateToProductPage(
                product: matches[index],
                child: ListTile(
                  title: ProductImage(
                    imageHeight: height * 0.24,
                    backgroundHeight: height * 0.25,
                    backgroundBorder: BorderRadius.circular(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    imageUrl: matches[index].imageUrl!,
                  ),
                  subtitle: Text(
                    matches[index].title!,
                    style: TextStyle(
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                ),
              )
            : nothingFoundFromSearch();
      },
    );
  }

  // shows suggestions for user when typing
  @override
  Widget buildSuggestions(BuildContext context) {
    List<Product> products = Provider.of<List<Product>>(context);
    List<String> matches = [];

    for (var term in searchTerms) {
      // shows matched categories, i.e. Computer, Electronics, etc.
      if (term.toLowerCase().contains(query.toLowerCase())) {
        matches.add(term);
      }
    }

    if (query.isNotEmpty) {
      for (var product in products) {
        // shows matched products, i.e. Metroid Dread Switch Game
        if (product.title!.toLowerCase().contains(query.toLowerCase())) {
          matches.add(product.title!);
        }
      }
    }

    // remove duplicate items
    matches = matches.toSet().toList();

    //after finding matches, build a listview of all matches
    return ListView.separated(
      itemCount: (matches.isNotEmpty) ? matches.length : 1,
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 3,
        );
      },
      itemBuilder: (context, index) {
        return (matches.isNotEmpty)
            ? ListTile(
                title: Text(
                  matches[index],
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  query = matches[index];
                  showResults(context);
                },
              )
            : nothingFoundFromSearch();
      },
    );
  }

  ListTile nothingFoundFromSearch() {
    return const ListTile(
      title: Text(
        "No Terms/Products Found",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
