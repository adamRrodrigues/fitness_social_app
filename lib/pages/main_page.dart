import 'package:fitness_social_app/pages/discover_page.dart';
import 'package:fitness_social_app/pages/fitnesstracker_page.dart';
import 'package:fitness_social_app/pages/home_page.dart';
import 'package:fitness_social_app/pages/profile_page.dart';
import 'package:fitness_social_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  PageController pageController = PageController();

  List<Widget> pages = const [
    FitnesstrackerPage(),
    DiscoverPage(),
    HomePage(),
    ProfilePage()
  ];

  Auth auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pages,
          ),
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(
                  top:
                      BorderSide(color: Theme.of(context).colorScheme.primary)),
              color: Theme.of(context).colorScheme.background,
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                child: GNav(
                  rippleColor: Theme.of(context).colorScheme.secondary,
                  hoverColor: Theme.of(context).colorScheme.primary,
                  gap: 8,
                  activeColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .backgroundColor,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Theme.of(context)
                      .bottomNavigationBarTheme
                      .selectedItemColor!,
                  color: Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
                  tabs: const [
                    GButton(
                      icon: Icons.monitor_heart_outlined,
                      // text: 'Home',
                    ),
                    GButton(
                      icon: Icons.explore_outlined,
                      // text: 'Discover',
                    ),
                    GButton(
                      icon: Icons.feed_outlined,
                      // text: 'My Fitness',
                    ),
                    GButton(
                      icon: Icons.person_2_outlined,
                      // text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                      pageController.jumpToPage(_selectedIndex);
                    });
                  },
                ),
              ),
            )));
  }
}
