import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:zamazon/models/Product.dart';
import 'package:zamazon/models/productModel.dart';

// I used this program to scrape products from amazon to populate firestore.
// It is not actively called in the program. - Ravi

class WebScraper {
  Future scrapeProducts() async {
    final searchTerms = [
      'electronics',
      'computer',
      'kitchen',
      'video games',
      'clothes',
      'cosmetics',
      'game console',
      'shoes',
    ];
    final baseUrl = 'https://www.amazon.ca/s?k=';
    List<Product> scrapedProducts = [];
    final ProductModel pm = ProductModel();

    print('souping');
    for (String term in searchTerms) {
      final url = Uri.parse(baseUrl + term);
      final response = await http.get(url);
      final soup = BeautifulSoup(response.body);
      final products = soup.findAll('div', id: 'search');

      final sizeOptions =
          (term == 'clothes' || term == 'shoes') ? [1, 2, 3, 4] : [1];
      final categories = [term];
      print('$term: ${products.length}');

      for (var item in products) {
        print('soup');
        List<Product> currScrapedProducts = [];

        final products = item
            .findAll('div', class_: 'sg-col-inner')
            .map((e) {
              String title = e
                      .find('span',
                          class_: 'a-size-base-plus a-color-base a-text-normal')
                      ?.text ??
                  'none';

              String price =
                  e.find('span', class_: 'a-offscreen')?.text ?? 'none';
              String imageURL =
                  e.find('img', class_: 's-image')?.getAttrValue('src') ??
                      'none';
              String rating =
                  e.find('span', class_: 'a-icon-alt')?.text ?? '0.0';
              String numReviews = e
                      .find('span', class_: 'a-size-base s-underline-text')
                      ?.text ??
                  'none';
              String wareHouseAvailability =
                  e.find('span', class_: 'a-size-base a-color-price')?.text ??
                      'In Stock';

              List<int> sizeSelection = sizeOptions;

              return {
                'title': title,
                'price': (price != 'none')
                    ? double.parse(price.replaceAll(RegExp(r'[$,-]'), ''))
                    : 0.0,
                'imageUrl': imageURL,
                'rating': rating.substring(0, 3),
                'numReviews': (numReviews != 'none')
                    ? int.parse(numReviews.replaceAll(RegExp(r'[,()]'), ''))
                    : 0,
                'warehouseAvailability': wareHouseAvailability,
                'sizeSelection': sizeSelection,
                'categories': categories,
              };
            })
            .toList()
            .where((product) =>
                (product['title'] != 'none' && product['price'] != 0.0));

        currScrapedProducts
            .addAll(products.map((product) => Product.fromScrapedMap(product)));

        // too many products slows the app down so we only keep 15 from each category
        // for a total of 120 items
        for (int i = 0; i < 15; i++) {
          pm.insertProduct(currScrapedProducts[i]);
          scrapedProducts.add(currScrapedProducts[i]);
        }
      }
    }

    print(scrapedProducts.length);
    print('souping complete');
  }
}
