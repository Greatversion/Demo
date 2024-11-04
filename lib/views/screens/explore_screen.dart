// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mambo/providers/explore_action_provider.dart';
import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Reusable_widgets/explore/category_tiles_widget.dart';
import 'package:mambo/utils/Reusable_widgets/explore/explore_all_button.dart';
import 'package:mambo/utils/Reusable_widgets/explore/product_tiles_widget.dart';
import 'package:mambo/utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/category_view_model.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/utils/No%20Internet/no_internet_widget.dart';
import 'package:provider/provider.dart';

// ExploreScreen is a StatefulWidget that displays a screen for exploring categories and products
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    // Fetching categories and products after the initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);

      // If categories are not loaded yet, fetch them
      if (categoryProvider.categories.isEmpty) {
        categoryProvider.fetchCategories(context);
      }

      // Fetch products
      productProvider.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Providers to access various data and functionalities
    final ConnectivityService connectivityService =
        Provider.of<ConnectivityService>(context);
    final navBarProvider = Provider.of<NavBarProvider>(context);
    // Text labels for different sections
    const String tagLine1 = "Get inspired! Perfect fits for you";
    const String tagLine2 = "Explore all Products";

    return WillPopScope(
      onWillPop: () async {
        navBarProvider.tapOnNavBarItem(0, context);

        return false; // Prevent the default pop behavior
      },
      child: Scaffold(
        // Main body of the screen
        body: (!connectivityService.isOnline)
            ? const NoInternetWidget()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 14), // Padding around the body
                child: SafeArea(
                  child: SingleChildScrollView(
                    // Allows the content to scroll vertically if it overflows the screen
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar to navigate to the product search screen
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: TextFormField(
                            readOnly: true, // Makes the field non-editable
                            onTap: () {
                              // Navigate to the product search screen when tapped
                              Navigator.pushNamed(
                                  context, RoutesName.productSearchScreen);
                            },
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              hintText: "Search...", // Placeholder text
                              hintStyle: AppStyles.semiBoldText,
                              prefixIcon: const Icon(
                                  Icons.search), // Icon inside the search bar
                              contentPadding: const EdgeInsets.all(
                                  2), // Padding inside the field
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    29), // Rounded corners
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Section header for categories
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            tagLine1,
                            style: AppStyles.explorePageHeader,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Grid view displaying categories
                        if (AppConst.isDeviceAPhone())
                          SizedBox(
                            height: 340, // Fixed height for the grid view
                            width: double.infinity, // Full width
                            child: Consumer<CategoryProvider>(
                                builder: (context, categoryProvider, child) {
                              // Handle different states for the categories section
                              if (categoryProvider.isLoading) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator()); // Loading indicator
                              } else if (categoryProvider
                                  .errorMessage.isNotEmpty) {
                                debugPrint(categoryProvider.errorMessage);
                                return const Center(
                                    child: Text(
                                        "Something went wrong, Restart the App.")); // Error message
                              } else {
                                // Display categories in a horizontal grid view
                                return GridView.builder(
                                  itemCount: categoryProvider.categories
                                      .length, // Number of categories
                                  scrollDirection:
                                      Axis.horizontal, // Horizontal scrolling
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent:
                                        133, // Height of each grid item
                                    crossAxisCount:
                                        2, // Number of items per row
                                  ),
                                  itemBuilder: (context, index) {
                                    // Create a grid item for each category
                                    return CategoryTilesWidget(index: index);
                                  },
                                );
                              }
                            }),
                          )
                        else
                          SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Consumer<CategoryProvider>(
                                builder: (context, categoryProvider, child) {
                              // Handle different states for the categories section
                              if (categoryProvider.isLoading) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator()); // Loading indicator
                              } else if (categoryProvider
                                  .errorMessage.isNotEmpty) {
                                debugPrint(categoryProvider.errorMessage);
                                return const Center(
                                    child: Text(
                                        "Something went wrong !")); // Error message
                              } else {
                                // Display categories in a horizontal grid view
                                return ListView.builder(
                                  itemCount: categoryProvider.categories
                                      .length, // Number of categories
                                  scrollDirection:
                                      Axis.horizontal, // Horizontal scrolling
                                  itemExtent: 200,
                                  itemBuilder: (context, index) {
                                    // Create a grid item for each category
                                    return CategoryTilesWidget(index: index);
                                  },
                                );
                              }
                            }),
                          ),
                        const SizedBox(height: 10),
                        // Section header for products
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Text(
                            tagLine2,
                            style: AppStyles.explorePageHeader,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Grid view displaying products
                        Consumer2<ExploreactionProvider, ProductProvider>(
                          builder: (context, exploreProvider, productProvider,
                              child) {
                            // Display products in a staggered grid view
                            return MasonryGridView.builder(
                              itemCount: exploreProvider.isExploreButtonTapped
                                  ? productProvider.products!
                                      .length // Number of products to display
                                  : 6, // Display a default number of items if button is not tapped
                              shrinkWrap:
                                  true, // Size the grid view to fit its content
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable scrolling
                              gridDelegate:
                                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of items per row
                              ),
                              itemBuilder: (context, index) {
                                // Create a grid item for each product
                                return ProductTilesWidget(index: index);
                              },
                            );
                          },
                        ),
                        // Display 'Explore All' button based on the state and connectivity
                        const SizedBox(height: 5),
                        Consumer<ExploreactionProvider>(
                          builder: (context, exploreProvider, child) {
                            return exploreProvider.isExploreButtonTapped
                                ? const SizedBox() // Hide button if already tapped
                                : const ExploreAllButton(); // Show 'Explore All' button
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        // Bottom navigation bar for navigating the app
        bottomNavigationBar: const BottomNavBarWidget(),
      ),
    );
  }
}
