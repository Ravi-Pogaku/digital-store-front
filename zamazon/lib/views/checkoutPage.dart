import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:zamazon/controllers/userInfoForm.dart';
import 'package:zamazon/models/shoppingCartWishListItem.dart';
import 'package:zamazon/models/userModel.dart';
import 'package:zamazon/widgets/checkOutItem.dart';
import 'package:zamazon/widgets/confirmPurchase.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/widgets/defaultAppBar.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({
    super.key,
    required this.checkOutItems,
    required this.sumOfCart,
    required this.numOfItems,
  });

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

        if (snapshot.hasError) {
          print('ERROR CHECKOUT: ${snapshot.error.toString()}');
        }

        // if a user skipped entering their information before trying to buy
        // products, then ask them to input that information.
        if (snapshot.data!.name!.isEmpty || snapshot.data!.address!.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Text(
                        'You must input this information in order to purchase products.',
                        style: TextStyle(fontSize: 25, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    UserInfoForm(
                      buttonText: 'Save',
                      initialName: snapshot.data!.name!,
                      initialAddress: snapshot.data!.address!,
                    ),
                  ],
                ),
              ),
            ),
          );
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
