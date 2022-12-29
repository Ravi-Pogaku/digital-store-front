import 'package:flutter/material.dart';
import '../models/Product.dart';
import 'priceWidget.dart';

// class DealWidget extends StatelessWidget {
//   const DealWidget({Key? key, required this.product}) : super(key: key);

//   final Product product;

//   @override
//   Widget build(BuildContext context) {
//     return Column(children: [
//       Row(
//         children: [
//           PriceWidget(product: product),
//           Flexible(
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               // ${product!.savings!.substring(18,21)}
//               child: Text("${product.savings}",
//                   style: const TextStyle(fontSize: 25, color: Colors.red)),
//             ),
//           ),
//         ],
//       ),
//       Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
//             // ${product!.savings!.substring(18,21)}
//             child: const Text("Was: ",
//                 style: TextStyle(
//                     // fontSize: 25
//                     // decoration: TextDecoration.lineThrough
//                     )),
//           ),
//           // Container(
//           //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
//           //   // ${product!.savings!.substring(18,21)} // percentage off
//           //   child: Text("\$${product.retailPrice}",
//           //       style: const TextStyle(
//           //           // fontSize: 25
//           //           decoration: TextDecoration.lineThrough)),
//           // ),
//         ],
//       )
//     ]);
//   }
// }
