import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app_panel/const/theme_data.dart';
import 'package:store_app_panel/controller/MenuController.dart';
import 'package:store_app_panel/providers/dark_theme_provider.dart';
import 'package:store_app_panel/screens/inner_screens/add_product.dart';
import 'package:store_app_panel/screens/inner_screens/edit_product.dart';
import 'package:store_app_panel/screens/main_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

final Future<FirebaseApp>initialization =Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    DarkThemeProvider themeChangeProvider = DarkThemeProvider();
    return FutureBuilder(
      future: initialization,
      builder: (context,snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(child: Text("App is being initialized"),),
          ),
        );
      }
      else if(snapshot.hasError){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(child: Text("an error has been occured${snapshot.error}"),),
          ),
        );
      }else{
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => CustomMenuController()),
            ChangeNotifierProvider(
              create: (_) {
                return themeChangeProvider;
              },
            )
          ],
          child: Consumer<DarkThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Grocery",
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const MainScreen(),
                routes: {
                  UploadProductFrom.routeName: (context) => const UploadProductFrom(),

                },
              );
            },
          ),
        );
      }}
    );
  }
}
