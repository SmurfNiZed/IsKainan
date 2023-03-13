import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iskainan/main.dart';
import 'package:iskainan/pages/Home/food_list.dart';
import 'package:iskainan/pages/Home/vendor_list.dart';
import 'package:iskainan/widgets/big_text.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../utils/colors.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  late PersistentTabController _controller;


  // BACKUP IN CASE PLUGIN NAV BAR STOPS WORKING

  // List pages = [
  //   MainPage(),
  //   Container(child: Center(child: BigText(text: "History?"))),
  //   Container(child: Center(child: BigText(text: "Favorites?"))),
  //   Container(child: Center(child: BigText(text: "Profile Page for Vendors?"))),
  // ];

  void onTapNav(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  // BACKUP IN CASE PLUGIN NAV BAR STOPS WORKING

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: pages[_selectedIndex],
  //     bottomNavigationBar: BottomNavigationBar(
  //       elevation: 70,
  //       selectedItemColor: AppColors.mainColor,
  //       unselectedItemColor: Colors.grey,
  //       showSelectedLabels: false,
  //       showUnselectedLabels: false,
  //       selectedFontSize: 0.0,
  //       unselectedFontSize: 0.0,
  //       currentIndex: _selectedIndex,
  //       onTap: onTapNav,
  //       items: const [
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.home,),
  //           label: "Home"
  //         ),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.archive,),
  //             label: "History"
  //         ),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.star,),
  //             label: "Favorites"
  //         ),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.person_2_rounded,),
  //             label: "Profile"
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override initState(){
      super.initState();
      _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      MainPage(),
      VendorList(),
      FoodList(),
      Container(child: Center(child: BigText(text: "About Us"))),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_rounded),
        title: ("Home"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.storefront),
        title: ("All Vendors"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fastfood_rounded),
        title: ("All Food"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person_3_fill),
        title: ("Me"),
        activeColorPrimary: AppColors.mainColor,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white, // Default is Colors.white.
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style12, // Choose the nav bar style with this property.
    );
  }
}
