import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:zamazon/models/CusUser.dart';
import 'package:zamazon/notifications.dart';
import 'package:zamazon/widgets/genericSnackBar.dart';
import '../models/shoppingCartWishListItem.dart';
import '../models/shoppingCartWishListModel.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../views/orderTrackMap.dart';

class ConfirmPurchaseWidget extends StatelessWidget {
  ConfirmPurchaseWidget(
      {super.key,
      required this.width,
      required this.sumOfCart,
      required this.user,
      required this.numOfItems,
      required this.checkedOutItems,
      required this.userAddress});

  final List<ShoppingCartWishListItem> checkedOutItems;
  final double width;
  final double sumOfCart;
  final CusUser user;
  final int numOfItems;
  final String userAddress;

  final _notifications = Notifications();

  final SCWLModel _scwlModel = SCWLModel();

  void _sendDeliveryNotif(String notifBody) async {
    // getting duration of delivery from direction API
    final response = await getRoute(await getUserLatLng(userAddress));
    // we get duration in seconds so we change it to minutes
    num duration = response['routes'][0]['duration'] / 60;
    // we find the minutes and second of this duration
    num minutes = (duration).toInt();
    num seconds = ((duration - minutes) * 60).round();

    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    tz.TZDateTime orderDate =
        tz.TZDateTime.now(tz.getLocation(currentTimeZone));
    tz.TZDateTime deliveryDate = orderDate
        .add(Duration(minutes: minutes.toInt(), seconds: seconds.toInt()));

    print('Order Date:   $orderDate');
    print('Deliver Date: $deliveryDate');

    _scwlModel.addToOrderHistory(
        checkedOutItems, userAddress, orderDate, deliveryDate);

    _notifications.sendNotificationLater(
        'Your order has been delivered!', notifBody, '', deliveryDate);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle regularTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white);
    tz.initializeTimeZones();

    _notifications.init();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      // height: MediaQuery.of(context).size.height/3,

      decoration: const BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.only(
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
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                sumOfCart.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
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
