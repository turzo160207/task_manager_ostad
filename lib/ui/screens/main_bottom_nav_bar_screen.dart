import 'package:flutter/material.dart';
import 'package:task_manager_ostad/ui/screens/cancelled_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/completed_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/new_task_screen.dart';
import 'package:task_manager_ostad/ui/screens/progress_task_screen.dart';
import 'package:task_manager_ostad/ui/utils/app_colors.dart';

import '../widgets/tm_app_bar.dart';

class MainBottomNavBarScreen extends StatefulWidget {
  const MainBottomNavBarScreen({Key? key}) : super(key: key);

  @override
  State<MainBottomNavBarScreen> createState() => _MainBottomNavBarScreenState();
}

class _MainBottomNavBarScreenState extends State<MainBottomNavBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    InProgressTaskScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'New'),
          NavigationDestination(
              icon: Icon(Icons.check_box), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
          NavigationDestination(
              icon: Icon(Icons.access_time_outlined), label: 'InProgress'),
        ],
      ),
    );
  }
}


