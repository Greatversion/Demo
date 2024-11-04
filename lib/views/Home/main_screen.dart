// ignore_for_file: deprecated_member_use

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mambo/models/Database%20models/cart_model.dart';
import 'package:mambo/models/Network%20models/product_model.dart' as model;
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/routes/app.routes.dart';
import 'package:mambo/services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/Loading/animated_loading_indicator.dart';
import 'package:mambo/utils/No%20Internet/no_internet_widget.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/view%20models/product_filter_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/views/Home/product_reels_widget.dart';
import '../../utils/Reusable_widgets/nav_bar/bottom_nav_bar.dart';

/// `MainUI` is the main screen of the application, showcasing products in a swipeable view.
class MainUI extends StatefulWidget {
  const MainUI({super.key});

  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  var selectedIndex = 0; // Index of the currently selected product
  late PageController reelPageController; // Controller for the PageView
  bool _isSwiping = false; // Flag to indicate if swiping is happening

  @override
  void initState() {
    super.initState();
    reelPageController =
        PageController(initialPage: selectedIndex); // Initialize PageController

    // Perform post-frame initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init(); // Initialize local notifications
      final provider = Provider.of<ProductProvider>(context, listen: false);

      if (provider.products!.isEmpty) {
        provider.fetchProducts(); // Fetch products if not already loaded
      }
    });
  }

  /// Initialize local notification service.
  init() async {
    await LocalNotificationSevice.initializeNotification();
  }

  @override
  void dispose() {
    reelPageController.dispose(); // Dispose of PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppConst.setHeightWidth(context); // Set dimensions based on context
    CartViewModel cartViewModel =
        Provider.of<CartViewModel>(context, listen: false);
    ProductFilterViewModel productFilterViewModel =
        Provider.of<ProductFilterViewModel>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: const BottomNavBarWidget(), // Bottom navigation bar
      body: WillPopScope(
        onWillPop: () async {
          if (productFilterViewModel.filteredProducts.isNotEmpty) {
            productFilterViewModel.filteredProducts.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MainUI(), // Replace with your desired screen
              ),
            );
          } else {
            SystemNavigator.pop();
          }

          return false; // Prevent the default pop behavior
        },
        child: Consumer3<ProductProvider, ConnectivityService,
            ProductFilterViewModel>(
          builder: (context, productProvider, connectivity,
              productFilterViewModel, child) {
            // Determine the list of products to display
            List<model.ProductModel> productList =
                (productFilterViewModel.filteredProducts.isNotEmpty)
                    ? productFilterViewModel.filteredProducts
                    : productProvider.products!;

            if (!connectivity.isOnline) {
              return const Center(
                  child:
                      NoInternetWidget()); // Show no internet widget if offline
            }
            if (productProvider.isLoading || productFilterViewModel.isLoading) {
              return const SimpleLoadingIndicator(); // Show loading animation while fetching data
            } else if (productList.isEmpty) {
              return Center(
                child: ErrorDisplayWidget(
                    msg: errorMessages.searchResultsError().message,
                    desc: errorMessages
                        .searchResultsError()
                        .description), // Show error if no products found
              );
            } else {
              return PageView.builder(
                scrollDirection:
                    Axis.vertical, // Scroll vertically through products
                itemCount: productList.length,
                controller: reelPageController,
                onPageChanged: (int page) {
                  setState(() {
                    selectedIndex =
                        page; // Update selected index on page change
                  });
                },
                itemBuilder: (context, index) {
                  var product = productList[index];
                  var videoUrl = productProvider
                      .getFeaturedVideo(product); // Get featured video URL

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: NetworkImage(
                          productList[index].id == null
                              ? productList[index - 1]
                                  .images
                                  .first
                                  .src
                                  .toString()
                              : (productList.length == 1 ||
                                      productList[index] == productList.last)
                                  ? productList[index]
                                      .images
                                      .first
                                      .src
                                      .toString()
                                  : productList[index + 1]
                                      .images
                                      .first
                                      .src
                                      .toString(),
                        ),
                      ),
                    ),
                    child: CardSwiper(
                      padding: const EdgeInsets.all(0),
                      numberOfCardsDisplayed: 1,
                      backCardOffset: const Offset(0, 0),
                      scale: 1,
                      cardsCount: productList.length,
                      allowedSwipeDirection:
                          const AllowedSwipeDirection.only(right: true),
                      cardBuilder: (context, cardIndex, percentThresholdX,
                          percentThresholdY) {
                        _isSwiping = percentThresholdX > 100 ||
                            percentThresholdY > 100; // Check if swiping

                        return Stack(
                          children: [
                            // Display product reel widget with video or default
                            (videoUrl != null && videoUrl.isNotEmpty)
                                ? ProductReelWidget(
                                    videoUrl: videoUrl,
                                    index: index,
                                  )
                                : ProductReelWidget(
                                    videoUrl: "",
                                    index: index,
                                  ),
                            if (_isSwiping)
                              Center(
                                child: SvgPicture.asset(
                                  "assets/images/cart.svg",
                                  height: 170,
                                ),
                              ), // Show cart icon if swiping
                          ],
                        );
                      },
                      onSwipe: (previousIndex, currentIndex, direction) async {
                        if (direction == CardSwiperDirection.right) {
                          Map<String, String> selectedAttributes = {};
                          await LocalNotificationSevice.showNotifications(
                            bigPicture: product.images.first.src,
                            notificationLayout: NotificationLayout.BigPicture,
                            title: "Mambo • Cart",
                            body:
                                '${product.name} by ${productFilterViewModel.filteredProducts.isNotEmpty ? product.store!.name : product.store!.shopName} added to Cart',
                          ).then((_) {
                            if (!cartViewModel.isAdded) {
                              // Add product to cart with selected attributes
                              List.generate(product.attributes.length, (index) {
                                selectedAttributes[
                                        product.attributes[index].name!] =
                                    product.attributes[index].options.first;
                              });

                              cartViewModel.addItemInCart(ProductCartModel(
                                productName: product.name!,
                                productPrice: (product.onSale!)
                                    ? product.salePrice!
                                    : product.regularPrice!,
                                productID: product.id!,
                                quantity: 1,
                                productImgUrl: product.images.first.src!,
                                vendorID: product.store!.id!,
                                vendorName: productFilterViewModel
                                        .filteredProducts.isNotEmpty
                                    ? product.store!.name!
                                    : product.store!.shopName!,
                                attributes: product.attributes,
                                selectedAttributes: selectedAttributes,
                              ));
                            }
                          });

                          // Move to the next page if not at the end of the list
                          if (index < productList.length - 1) {
                            reelPageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn,
                            );
                          }
                          return true;
                        }
                        return false;
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
