import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zamazon/models/settings_BLoC.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

// main file of app. firebase and streamprovider for products are initialized here.
// Streambuilder listens to authentification state changes, and displays either the
// signin-signup page or homepage accordingly.

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // USED TO POPULATE FIRESTORE. NOT NEEDED AGAIN AFTER THE FIRST TIME UNLESS
  // MORE PRODUCTS ARE REQUIRED.
  //WebScraper().scrapeProducts();

  // used to retrieve user settings, i.e. light/darkmode and selected language.
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // PROVIDES LIST OF ALL PRODUCTS FROM FIRESTORE
        StreamProvider<List<Product>>(
          create: (context) => ProductModel().getProducts(),
          initialData: const [],
        ),

        // PROVIDES CURRENT THEME (LIGHT OR DARK MODE) AND LANGUAGE
        ChangeNotifierProvider<SettingsBLoC>(
            create: (context) => SettingsBLoC(
                  // initialize provider with saved values from previous session
                  isDarkMode: prefs.getBool('isDarkMode'),
                  languageCode: prefs.getString('languageCode'),
                )),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provides user's chosen theme and language
    var settingsProvider = Provider.of<SettingsBLoC>(context);

    return StreamBuilder<User?>(
      // listens for when user signs in and logs outs.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zamazon Demo',
          locale: Locale(settingsProvider.languageCode ?? 'en'),
          themeMode: settingsProvider.themeMode,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,

          // if snapshot doesn't have data, then it means no user is signed in.
          // so show the sign in page.
          home: (snapshot.hasData) ? const HomePage() : const SignInWidget(),

          // named routes that require parameters
          onGenerateRoute: (settings) {
            final String routeName = settings.name!;
            final Map<String, dynamic> arguments =
                settings.arguments as Map<String, dynamic>;

            switch (routeName) {
              case '/ProductPage':
                return MaterialPageRoute(builder: (context) {
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

          // named routes that don't require parameters
          routes: {
            '/SettingsPage': (context) =>
                const SettingsPageWidget(title: 'Settings'),
            '/NewUserInfoPage': (context) => const NewUserInfoPage(),
            '/SignIn': (context) => const SignInWidget(),
            '/OrderTrackMap': (context) => const OrderTrackMap(),
          },

          // language delegates and supported languages
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
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('fr'),
            Locale('zh'),
            Locale('es'),
            Locale('ja'),
          ],
        );
      },
    );
  }
}
