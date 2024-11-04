import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mambo/firebase_options.dart';
import 'package:mambo/providers/app.providers.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/routes/app.routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:provider/provider.dart';

// Entry point of the application
Future<void> main() async {
  // Initialization of Firebase SDK and environment variables

  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures Flutter is initialized before running code
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(
      fileName: '.env'); // Loads environment variables from .env file
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Initializes Firebase with options for the current platform

  await Future.delayed(const Duration(seconds: 2)).then((_) {
    FlutterNativeSplash.remove();
  });
  runApp(
    const MAMBO(),
  );
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => const MAMBO(), // Wrap your app
  //   ),
  // ); // Runs the application by initializing the MAMBO widget
}

// Main application widget
class MAMBO extends StatelessWidget {
  const MAMBO({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<
      NavigatorState>(); // Global key for Navigator, useful for global navigation operations

  @override
  Widget build(BuildContext context) {
    // Locks the device orientation to portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Defines the theme for BottomNavigationBar
    final bottomNavBarTheme = BottomNavigationBarThemeData(
      showSelectedLabels: false, // Hides labels for selected items
      showUnselectedLabels: false, // Hides labels for unselected items
      selectedItemColor: Colors.black, // Color of the selected item
      unselectedLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w100,
          fontSize: 1), // Style of unselected labels
      selectedIconTheme: IconThemeData(
          size: AppStyles.iconSize + 2,
          fill: 1,
          color: Colors.black,
          shadows: const [
            Shadow(color: Colors.black38, blurRadius: 1)
          ]), // Style of selected icons
      unselectedIconTheme: IconThemeData(
        color: Colors.grey[700],
        size: AppStyles.iconSize + 2,
      ),
      selectedLabelStyle: const TextStyle(
          height: 0.04,
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w800), // Style of selected item labels
    );

    // Defines the color scheme for the app
    const appColorScheme = ColorScheme(
      primary: Colors.black,
      primaryContainer: Colors.black,
      surfaceTint: AppColors.black,
      secondary: Colors.black,
      secondaryContainer: Colors.black,
      surface: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    );

    // Main application widget tree
    return MultiProvider(
      providers:
          AppProviders.providers, // Provides various app-wide dependencies
      child: MaterialApp(
        //  locale: DevicePreview.locale(context),
        //   builder: DevicePreview.appBuilder,
        // locale: DevicePreview.locale(context),
        // builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner:
            false, // Shows debug banner, can be set to false for production
        title: dotenv
            .env['APP_NAME']!, // Application title from environment variable
        theme: ThemeData(
          fontFamily: 'Raleway', // Sets the default font for the application
          colorScheme: appColorScheme, // Applies the defined color scheme
          bottomNavigationBarTheme:
              bottomNavBarTheme, // Applies the bottom navigation bar theme
          useMaterial3: true, // Enables Material Design 3
        ),
        initialRoute:
            RoutesName.splashDecider, // Sets the initial route to be loaded
        onGenerateRoute: (settings) =>
            AppRoutes.generatedRoute(settings), // Handles route generation
      ),
    );
  }
}
