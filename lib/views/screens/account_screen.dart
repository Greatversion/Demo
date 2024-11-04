// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart';
import 'package:mambo/utils/Reusable_widgets/profile/container_widget.dart';
import 'package:mambo/utils/Social_Share/social_share.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/auth_view_model.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final SocialShareClass socialShareClass = SocialShareClass();
  final AuthenticationProvider authProvider = AuthenticationProvider();

  // Displays a dialog prompting the user to connect to the internet.
  void showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        shadowColor: const Color.fromARGB(154, 0, 0, 0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(
                Icons.network_check_rounded,
                color: AppColors.primary,
              ),
              SizedBox(
                child: Text(
                  "Please connect to the Network.",
                  style: AppStyles.boldText,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Shows a confirmation dialog for deleting the user's account.
  void showDeleteDialog() {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          if (isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }

          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            elevation: 2,
            children: [
              Text(
                "Delete your Mambo account?",
                style: AppStyles.boldText.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1)),
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: AppStyles.regularText.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )),
                  ),
                  OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      authProvider.deleteUser().then((_) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.loginScreen,
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    child: Text(
                      "Confirm",
                      style: AppStyles.regularText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  // Shows a confirmation dialog for logging out of the account.
  void showLogOutDialog() {
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          if (isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.primary,
            ));
          }
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(20),
            elevation: 2,
            children: [
              Text(
                "Logout from account?",
                style: AppStyles.boldText.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1)),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Cancel",
                      style: AppStyles.regularText.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black)),
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      AuthenticationProvider().signOut().then((_) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.loginScreen,
                          (Route<dynamic> route) => false,
                        );
                      });
                    },
                    child: Text(
                      "Confirm",
                      style: AppStyles.regularText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provides connectivity status and FirebaseAuth instance.
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    final connectivity = Provider.of<ConnectivityService>(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    return WillPopScope(
      onWillPop: () async {
        navBarProvider.tapOnNavBarItem(0, context);

        return false; // Prevent the default pop behavior
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              navBarProvider.tapOnNavBarItem(0, context);
              // Navigate back to the previous screen
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize, // Size of the back arrow icon
            ),
          ),
          automaticallyImplyLeading: true,
          // actions: [
          //   // Padding(
          //   //   padding: const EdgeInsets.symmetric(horizontal: 18),
          //   //   child: GestureDetector(
          //   //     onTap: () {
          //   //       showDialog(
          //   //         context: context,
          //   //         builder: (context) => Dialog(
          //   //           elevation: 2,
          //   //           backgroundColor: Colors.transparent,
          //   //           child: ClipRRect(
          //   //             borderRadius: BorderRadius.circular(25),
          //   //             child: SizedBox(
          //   //                 height: 200,
          //   //                 width: 200,
          //   //                 child:
          //   //                     CachedNetworkImage(imageUrl: user!.photoURL!)),
          //   //           ),
          //   //         ),
          //   //       );
          //   //     },
          //   //     child: connectivity.isOnline
          //   //         ? CircleAvatar(
          //   //             backgroundImage:
          //   //                 CachedNetworkImageProvider(user!.photoURL!),
          //   //           )
          //   //         : const SizedBox(),
          //   //   ),
          //   // ),
          // ],
          title: const Text('Profile Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20.0),
            child: Column(
              children: [
                // User profile information section.
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.11,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color.fromARGB(32, 158, 158, 158),
                      border: Border.all(
                        color: const Color.fromARGB(0, 158, 158, 158),
                        width: 1.5,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          user!.displayName!.toUpperCase(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          user.email!,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options for past orders, saved addresses, reporting errors, and contacting the founder.
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(32, 158, 158, 158),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color.fromARGB(0, 158, 158, 158),
                        width: 1.5,
                      )),
                  child: Consumer<ConnectivityService>(
                    builder: (context, value, child) => Column(
                      children: [
                        ContainerWidget(
                            iconData: Icons.person,
                            data: "My Profile",
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.userProfileScreen);
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.playlist_play_outlined,
                            data: "Past Orders",
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutesName.pastOrder);
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.home,
                            data: "Saved Addresses",
                            onTap: () {
                              Navigator.pushNamed(context, RoutesName.address);
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.error_outline_outlined,
                            data: "Report an error",
                            onTap: () {
                              socialShareClass.sendEmail(
                                  'harshita@mambonow.com',
                                  'Error Report',
                                  'Error Report');
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.call,
                            data: "Talk to the founder",
                            onTap: () {
                              socialShareClass.sendWhatsAppMessage(
                                  '+91 9930285708',
                                  'From:${user.email}\n Message:Service query to Mambo!');
                            }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Options for sharing the app, following social media, and deleting the account.
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(32, 158, 158, 158),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color.fromARGB(0, 158, 158, 158),
                        width: 1.5,
                      )),
                  child: Consumer<ConnectivityService>(
                    builder: (context, value, child) => Column(
                      children: [
                        ContainerWidget(
                            iconData: Icons.share,
                            data: "Share with a friend",
                            onTap: () {
                              socialShareClass.SocialShare(
                                  'Download Mambo from GooglePlay Store.');
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.near_me,
                            data: "Follow our socials",
                            onTap: () {
                              socialShareClass.openInstagramProfile('mambo.in');
                            }),
                        const Divider(
                          color: Color.fromARGB(103, 158, 158, 158),
                        ),
                        ContainerWidget(
                            iconData: Icons.dangerous,
                            data: 'Delete Account',
                            onTap: connectivity.isOnline
                                ? showDeleteDialog
                                : showNoInternetDialog)
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Log out button.
                GestureDetector(
                  onTap: connectivity.isOnline
                      ? showLogOutDialog
                      : showNoInternetDialog,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Container(
                      height: 40,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(25)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 5, bottom: 5),
                        child: Center(
                            child: Text(
                          "Log Out",
                          style: AppStyles.whiteColoredText.copyWith(
                              fontWeight: FontWeight.w400, fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}
