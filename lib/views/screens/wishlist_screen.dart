// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart';
import 'package:mambo/utils/Reusable_widgets/wishlist/wishlist_product_tile.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  ErrorMessages errorMessages = ErrorMessages();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth auth = FirebaseAuth.instance;
      Provider.of<WishlistViewModel>(context, listen: false)
          .getUserWishlist(auth.currentUser!.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        navBarProvider.tapOnNavBarItem(0, context);

        return false; // Prevent the default pop behavior
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,

          leading: InkWell(
            onTap: () {
              navBarProvider.tapOnNavBarItem(0, context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: AppStyles.backIconSize,
            ),
          ),
          toolbarHeight: 70, //Modified
          title: const Text(
            "Wishlist",
            style: TextStyle(fontSize: 24),
            // style: AppStyles.boldText,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10), //Modified
          child: Column(
            children: [
              // Fixed search bar
              TextFormField(
                readOnly: true,
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.wishlistSearchScreen);
                },
                cursorHeight: 20,
                decoration: InputDecoration(
                  hintText: "Search in your wishlist...",
                  hintStyle: AppStyles.semiBoldText,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(29),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Expanded scrollable wishlist content
              Expanded(
                child: Consumer2<WishlistViewModel, ProductProvider>(
                  builder: (context, wishlistProvider, productProvider, child) {
                    if (wishlistProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (wishlistProvider.userwishlist.isEmpty) {
                      return ErrorDisplayWidget(
                          msg: errorMessages.wishlistError().message,
                          desc: errorMessages.wishlistError().description);
                    }
                    return RawScrollbar(
                      thickness: 3,
                      // thumbColor: AppColors.primary,
                      child: MasonryGridView.builder(
                        itemCount: wishlistProvider.userwishlist.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          debugPrint(wishlistProvider
                              .userwishlist[index].product!.productId!
                              .toString());
                          return WishlistProductTiles(
                            index: index,
                            productID: wishlistProvider
                                .userwishlist[index].product!.productId!,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}
