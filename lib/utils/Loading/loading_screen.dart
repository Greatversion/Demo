// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mambo/utils/Loading/animated_loading_indicator.dart';
import 'package:mambo/utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart';
import 'package:mambo/utils/app.styles.dart';

class LoadingScreen extends StatelessWidget {
  final String screenName;
  const LoadingScreen({
    super.key,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: screenName == "ReelScreen" ||
              screenName == "ExplorePage" ||
              screenName == "CategoryScreen"
          ? null
          : AppBar(
              surfaceTintColor: Colors.white,
              centerTitle: true,
              leading: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: AppStyles.backIconSize,
                ),
              ),
              title: Text(
                screenName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
      body: const Center(
        child: SimpleLoadingIndicator(),
      ),
      bottomNavigationBar: const BottomNavBarWidget(),
    );
  }
}
