import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/app.router.dart';
import 'core/services/locator.dart';
import 'ui/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(_) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'open_sans',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.deepPurple,
        iconTheme: IconThemeData(
          color: Colors.deepPurple,
        ),
      ),
      debugShowCheckedModeBanner: false,
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      home: HomeView(),
    );
  }
}
