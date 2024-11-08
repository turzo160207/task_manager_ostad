import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/splash_screen.dart';
import 'package:task_manager_ostad/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: TaskManagerApp.navigatorKey,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        textTheme: TextTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
        inputDecorationTheme: _inputDecorationTheme(),
      ),
      home: SplashScreen(),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData(){
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.themeColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        fixedSize: Size.fromWidth(double.maxFinite),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme(){
    return InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      hintStyle: TextStyle(
        fontWeight: FontWeight.w400,
      ),
      border: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder(){
    return OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
    );
  }
}
