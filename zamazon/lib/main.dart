import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:zamazon/models/bottomNavBarBLoC.dart';
import 'package:zamazon/models/settings_BLoC.dart';
import 'package:zamazon/views/SettingsPage.dart';
import 'package:zamazon/controllers/SignIn-SignUpForm.dart';
import 'package:zamazon/views/checkoutPage.dart';
import 'package:zamazon/views/homePage.dart';
import 'package:zamazon/views/ProductPage.dart';
import 'package:zamazon/views/orderHistory.dart';
import 'package:zamazon/views/viewAllCategoryProducts.dart';
import 'package:zamazon/webscraping/scrapeProducts.dart';
import 'package:zamazon/views/newUserInfoPage.dart';
import 'package:zamazon/views/orderTrackMap.dart';
import 'models/Product.dart';
import 'models/productModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
        // Provide a list of products from firestore
        StreamProvider<List<Product>>(
          create: (context) => ProductModel().getProducts(),
          initialData: const [],
        ),

        // Provides current theme (light or dark mode) and language
        ChangeNotifierProvider<SettingsBLoC>(
          create: (context) => SettingsBLoC(
            // initialize provider with saved values from previous session
            isDarkMode: prefs.getBool('isDarkMode'),
            languageCode: prefs.getString('languageCode'),
          ),
        ),

        // for improved performance when updating the bottomNavBar
        ChangeNotifierProvider<BottomNavBarBLoC>(
          create: (context) => BottomNavBarBLoC(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // this app is designed for portrait mode (vertical phone orientation)
    // this prevents the orientation from changing when the phone is sideways.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // provides user's chosen theme and language
    var settingsProvider = Provider.of<SettingsBLoC>(context);

    return StreamBuilder<User?>(
      // listens for when user signs in and logs outs.
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('MAIN ERROR: ${snapshot.error.toString()}');
        }

        // data loaded successfully, show actual app
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Zamazon Demo',
          locale: Locale(settingsProvider.languageCode ?? 'en'),
          themeMode: settingsProvider.themeMode,
          theme: CustomThemes.lightTheme,
          darkTheme: CustomThemes.darkTheme,

          // automatic resizes every part of the app based on the breakpoints.
          builder: (context, child) => ResponsiveWrapper.builder(child,
              defaultScale: true,
              maxWidth: 1200,
              minWidth: 450,
              breakpoints: const [
                ResponsiveBreakpoint.resize(450, name: MOBILE),
                ResponsiveBreakpoint.autoScale(800, name: TABLET),
                ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                ResponsiveBreakpoint.autoScale(1200, name: DESKTOP),
                ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ]),

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
                    title: arguments['title'],
                    specificProducts: arguments['specificProducts'],
                  );
                });
              case '/CheckOut':
                return MaterialPageRoute(builder: (context) {
                  return CheckOutPage(
                    checkOutItems: arguments['checkOutItems'],
                    sumOfCart: arguments['sumOfCart'],
                    numOfItems: arguments['numOfItems'],
                  );
                });
              case '/OrderTrackMap':
                return MaterialPageRoute(builder: (context) {
                  return OrderTrackMap(
                    deliveryAddress: arguments['deliveryAddress'],
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
            '/OrderHistory': (context) => const OrderHistory(),
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
