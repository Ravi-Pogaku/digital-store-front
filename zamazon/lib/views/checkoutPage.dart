import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/userModel.dart';
import 'package:zamazon/widgets/buildCheckOutItem.dart';
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
        return Scaffold(
          extendBody: true,
          appBar: DefaultAppBar(
            context,
            title: Text(FlutterI18n.translate(context, "CheckoutPage.appbar")),
          ),
          body: (snapshot.data!.name != 'Default')
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                      itemCount: checkOutItems.length,
                      itemBuilder: (context, index) {
                        return BuildCheckOutItem(
                            scwlItem: checkOutItems[index]);
                      }),
                )
              : const Center(child: CircularProgressIndicator()),
          bottomNavigationBar: (snapshot.data!.name != 'Default')
              ? ConfirmPurchaseWidget(
                  checkedOutItems: checkOutItems,
                  sumOfCart: sumOfCart,
                  width: MediaQuery.of(context).size.width,
                  user: snapshot.data as CusUser,
                  numOfItems: numOfItems,
                )
              : const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
