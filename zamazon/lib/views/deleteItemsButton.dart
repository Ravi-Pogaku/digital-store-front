import 'package:flutter/material.dart';
import 'package:zamazon/models/shoppingCartWishListModel.dart';

class DeleteAllItemsButton extends StatelessWidget {
  const DeleteAllItemsButton({
    super.key,
    required this.collName,
  });

  final String collName;

  @override
  Widget build(BuildContext context) {
    final SCWLModel model = SCWLModel();

    return IconButton(
      onPressed: () {
        model.deleteAllCartWishList(collName);
      },
      tooltip: 'Delete All Items',
      icon: const Icon(Icons.delete_forever),
    );
  }
}
