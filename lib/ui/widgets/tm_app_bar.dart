import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/controllers/auth_controller.dart';
import 'package:task_manager_ostad/ui/screens/profile_screen.dart';

import '../screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreenOpen) {
          return;
        }
        ;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage: AuthController.profileImage != null
                  ? FileImage(File(AuthController.profileImage!.path))
                  : null,
              child: AuthController.profileImage == null
                  ? Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AuthController.userData?.fullName ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    AuthController.userData?.email ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                await AuthController.clearUserData();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()),
                    (predicate) => false);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
