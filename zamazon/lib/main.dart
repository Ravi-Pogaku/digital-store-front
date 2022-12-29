import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamazon/models/themeBLoC.dart';
import 'package:zamazon/views/SettingsPage.dart';
import 'package:zamazon/controllers/SignIn-SignUpForm.dart';
import 'package:zamazon/views/checkoutPage.dart';
import 'package:zamazon/views/homePage.dart';
import 'package:zamazon/views/ProductPage.dart';
import 'package:zamazon/views/viewAllCategoryProducts.dart';
import 'package:zamazon/webscraping/scrapeProducts.dart';
import 'package:zamazon/views/newUserInfoPage.dart';
import 'package:zamazon/views/orderTrackMap.dart';
import 'models/Product.dart';
import 'models/productModel.dart';

// main file of app. firebase and streamprovider for products are initialized here.
// Streambuilder listens to authentification state changes, and displays either the
// signin-signup page or homepage accordingly.

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //await FirebaseAuth.instance.signOut();

  // USED TO POPULATE FIRESTORE. NOT NEEDED AGAIN AFTER THE FIRST TIME.
  //WebScraper().scrapeProducts();

  runApp(
    MultiProvider(
      providers: [
        // PROVIDES LIST OF ALL PRODUCTS FROM FIRESTORE
        StreamProvider<List<Product>>(
          create: (context) => ProductModel().getProducts(),
          initialData: const [],
        ),

        // PROVIDES CURRENT THEME (LIGHT OR DARK MODE)
        ChangeNotifierProvider<ThemeBLoC>(create: (context) => ThemeBLoC()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeBLoC>(context);
    ThemeMode currentTheme = themeProvider.getCurrentTheme();
    print('main: ${currentTheme.toString()}');

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Zamazon Demo',
          themeMode: currentTheme,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          home: (snapshot.hasData)
              ? const HomePage()
              : const SignInWidget(
                  title: 'Sign In',
                ),
          onGenerateRoute: (settings) {
            final String routeName = settings.name!;
            final Map<String, dynamic> arguments =
                settings.arguments as Map<String, dynamic>;
            switch (routeName) {
              case '/ProductPage':
                return MaterialPageRoute(builder: (context) {
                  // Product product = arguments;
                  return ProductPage(
                    title: arguments['title'],
                    product: arguments['product'],
                  );
                });
              case '/CategoryPage':
                return MaterialPageRoute(builder: (context) {
                  return ViewAllCategoryProducts(
                    specificProducts: arguments['specificProducts'],
                  );
                });
              case '/CheckOut':
                return MaterialPageRoute(builder: (context) {
                  return CheckOutPage(
                    title: arguments['title'],
                    checkOutItems: arguments['checkOutItems'],
                    sumOfCart: arguments['sumOfCart'],
                    numOfItems: arguments['numOfItems'],
                  );
                });
              default:
                return MaterialPageRoute(
                    builder: (context) => const HomePage());
            }
          },
          routes: {
            //Routes to other pages
            '/SettingsPage': (context) =>
                const SettingsPageWidget(title: 'Settings'),
            '/NewUserInfoPage': (context) => const NewUserInfoPage(),
            '/SignIn': (context) => const SignInWidget(title: 'Sign In'),
            '/SignUp': (context) => const SignInWidget(title: 'Sign Up'),
            '/OrderTrackMap': (context) => const OrderTrackMap(),
          },
          localizationsDelegates: [
            FlutterI18nDelegate(
              missingTranslationHandler: (key, locale) {
                print(
                    "MISSING KEY: $key, Language Code: ${locale!.languageCode}");
              },
              translationLoader: FileTranslationLoader(
                  useCountryCode: false,
                  fallbackFile: 'fr',
                  basePath: 'assets/i18n'),
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('cn'),
            Locale('sp'),
            Locale('jp'),
          ],
        );
      },
    );
  }
}
