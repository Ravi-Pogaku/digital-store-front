import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/userModel.dart';
import 'package:zamazon/widgets/checkOutItem.dart';
import 'package:zamazon/widgets/confirmPurchase.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({
    super.key,
    this.title,
    required this.checkOutItems,
    required this.sumOfCart,
    required this.numOfItems,
  });

  final String? title;
  final List<ShoppingCartWishListItem> checkOutItems;
  final double sumOfCart;
  final int numOfItems;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: CusUser(),
      stream: UserModel().getUserInformation(),
      builder: (context, snapshot) {
        // if data is loading, show loading circle
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: DefaultAppBar(
            title: Text(
              FlutterI18n.translate(context, "CheckoutPage.appbar"),
            ),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.separated(
              itemCount: checkOutItems.length,
              separatorBuilder: (context, index) {
                return const Divider(thickness: 2);
              },
              itemBuilder: (context, index) {
                return BuildCheckOutItem(
                  scwlItem: checkOutItems[index],
                );
              },
            ),
          ),
          bottomNavigationBar: ConfirmPurchaseWidget(
            userAddress: snapshot.data!.address!,
            checkedOutItems: checkOutItems,
            sumOfCart: sumOfCart,
            width: MediaQuery.of(context).size.width,
            user: snapshot.data as CusUser,
            numOfItems: numOfItems,
          ),
        );
      },
    );
  }
}
