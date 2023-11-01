import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
//import '../pages/home.dart';
import 'package:untitled4/pages/home.dart';
//import '../controllers/navigator_controllers.dart';
import 'package:untitled4/controllers//navigator_controllers.dart';
//untitled4
class MainNavigator extends StatelessWidget {
   MainNavigator({Key? key}) : super(key: key);

  // Screens
  final List<Widget> screens = const [
    HomePage(),

  ];

  @override
  Widget build(BuildContext context) {
    

    /// Controller
    final _controller = Get.put(NavigatorController());

      return SafeArea(
        child: Scaffold(
          /// Screens
          body: GetBuilder<NavigatorController>(
              id: "0",
              builder: (context) {
                return screens[_controller.currentIndex];
              }),

          /// bottomNavigationBar
          bottomNavigationBar: GetBuilder<NavigatorController>(
              id: "change NavBar Index",
              builder: (context) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                  child: CustomNavigationBar(
                    elevation: 40,
                    iconSize: 30.0,
                    scaleFactor: 0.3,
                    borderRadius: const Radius.circular(20),
                    unSelectedColor: Colors.grey,
                    strokeColor: Colors.white,
                    backgroundColor:  Color.fromARGB(255, 14, 31, 182),
                    selectedColor: Colors.white,
                    isFloating: true,
                    currentIndex: _controller.currentIndex,
                    onTap: (index) {
                      _controller.changeNavBarIndex(index);
                    },
                    items: [
                      /// Home
                      CustomNavigationBarItem(
                        icon: const Icon(
                          LineIcons.home,
                        ),
                      ),

                      /// Wallet
                      CustomNavigationBarItem(
                        icon: const Icon(
                          Icons.groups,
                        ),
                      ),

                      /// User Profile
                      CustomNavigationBarItem(
                        icon: const Icon(
                          LineIcons.user,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ),
      );

  
}
}