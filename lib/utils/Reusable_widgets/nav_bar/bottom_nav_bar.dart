import 'package:flutter/material.dart';

import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:provider/provider.dart';

class BottomNavBarWidget extends StatefulWidget {
  const BottomNavBarWidget({super.key});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    return Consumer<NavBarProvider>(
      builder: (context, value, child) => BottomNavigationBar(
        currentIndex: navBarProvider.currentPageIndex,
        onTap: (index) {
          navBarProvider.tapOnNavBarItem(index, context);
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                navBarProvider.currentPageIndex != 0
                    ? Icons.home_outlined
                    : Icons.home,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                navBarProvider.currentPageIndex != 1
                    ? Icons.explore_outlined
                    : Icons.explore,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                navBarProvider.currentPageIndex != 2
                    ? Icons.favorite_border_outlined
                    : Icons.favorite,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                navBarProvider.currentPageIndex != 3
                    ? Icons.shopping_cart_outlined
                    : Icons.shopping_cart,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                navBarProvider.currentPageIndex != 4
                    ? Icons.account_circle_outlined
                    : Icons.account_circle,
              ),
              label: ""),
        ],
      ),
    );
  }
}