import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/notifications.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import '../models/settings_BLoC.dart';
import '../models/shoppingCartWishListItem.dart';
import '../models/shoppingCartWishListModel.dart';

class ConfirmPurchaseWidget extends StatelessWidget {
  ConfirmPurchaseWidget({
    super.key,
    required this.width,
    required this.sumOfCart,
    required this.user,
    required this.numOfItems,
    required this.checkedOutItems,
  });

  final List<ShoppingCartWishListItem> checkedOutItems;
  final double width;
  final double sumOfCart;
  final CusUser user;
  final int numOfItems;

  final _notifications = Notifications();

  final SCWLModel _scwlModel = SCWLModel();

  void _sendDeliveryNotif(String notifBody) async {
    _notifications.sendNotificationNow(
      'Your order has been delivered!',
      notifBody,
      'payloadpayloadpayload',
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle regularTextStyle = const TextStyle(fontSize: 16);

    _notifications.init();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      // height: MediaQuery.of(context).size.height/3,
      decoration: BoxDecoration(
          color: Provider.of<SettingsBLoC>(context).isDarkMode
              ? Colors.grey[500]
              : Colors.orange,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // NAME
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FlutterI18n.translate(context, "ConfirmPurchase.name"),
                style: regularTextStyle,
              ),
              Text(
                '${user.name}',
                style: regularTextStyle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          // ADDRESS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                FlutterI18n.translate(context, "ConfirmPurchase.address"),
                style: regularTextStyle,
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Text(
                  '${user.address}',
                  style: regularTextStyle,
                  softWrap: true,
                  maxLines: 7,
                ),
              )
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // BLACK LINE
          const Divider(
            thickness: 2,
            color: Colors.black87,
          ),

          // TOTAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FlutterI18n.translate(context, "ConfirmPurchase.total"),
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                sumOfCart.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          // CONFIRM BUTTON
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(width - 100, 40),
              ),
              onPressed: () {
                _scwlModel.addToOrderHistory(checkedOutItems);

                // Pop to homepage
                Navigator.popUntil(context, (route) => route.isFirst);

                // Order confirmation snackbar
                showSnackBar(context,
                    FlutterI18n.translate(context, "ConfirmPurchase.deliver"));

                // Send order delivered notification
                String notifBody = 'Your order of $numOfItems item(s) has been '
                    'delivered to ${user.name} at ${user.address}';

                _sendDeliveryNotif(notifBody);
              },
              child: Text(
                  FlutterI18n.translate(context, "ConfirmPurchase.confirm"),
                  style: const TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
