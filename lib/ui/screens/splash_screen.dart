import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_ostad/ui/controllers/auth_controller.dart';
import 'package:task_manager_ostad/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager_ostad/ui/screens/sign_in_screen.dart';
import 'package:task_manager_ostad/ui/utils/assets_path.dart';

import '../widgets/screen_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    await AuthController.getAccessToken();
    if(AuthController.isLoggedIn()) {
      await AuthController.getUserData();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainBottomNavBarScreen(),
        ),
      );
    } else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(
            AssetsPath.logo,
            width: 120,
          ),
        ),
      ),
    );
  }
}
