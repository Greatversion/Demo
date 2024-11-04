import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/App%20Tutorial/coach_mark_description.dart';
import 'package:mambo/utils/Reusable_widgets/wishlist/wishlist_animation.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/view%20models/product_filter_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:video_player/video_player.dart';
import 'package:mambo/Services/Notifications/Local%20Notifications/app.local_notification.dart';
import 'package:mambo/models/Network%20models/product_model.dart' as model;
import 'package:mambo/models/Network%20models/search_model.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/apply_filter_button.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/clear_button_widget.dart';
import 'package:mambo/utils/Reusable_widgets/filter_widgets/filter_button_widget.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';

// ignore: must_be_immutable
class ProductReelWidget extends StatefulWidget {
  ProductReelWidget({
    super.key,
    required this.videoUrl,
    required this.index,
  });

  // ignore: prefer_typing_uninitialized_variables
  final index;
  String videoUrl;

  @override
  State<ProductReelWidget> createState() => _ProductReelWidgetState();
}

class _ProductReelWidgetState extends State<ProductReelWidget> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  bool _addedtowishlist = false;
  //since for the vendor filter we have vendorStore name in the name attribute and not in the shopName attribute likewise other filters have in the same so we are tweaking to get the desired result....
  bool isvendorfilterSelected = false;
  bool _tutorialseen = false;
// update UI
  GlobalKey wishListButtonKey = GlobalKey();
  GlobalKey filterButtonKey = GlobalKey();
  GlobalKey reelWidgetKey = GlobalKey();
  GlobalKey reelWidgetKey2 = GlobalKey();
  List<TargetFocus> targets = [];

  // Initialize tutorial targets
  void _initTarget() {
    targets = [
      TargetFocus(
          identify: "reel-press-key",
          keyTarget: reelWidgetKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.5),
                  child: const Icon(
                    Icons.touch_app_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Transform.translate(
                  offset: const Offset(0, -50),
                  child: CoachMarkDescription(
                    text: "Tap to view the Product details.",
                    next: "Next",
                    onNext: () {
                      controller.next();
                    },
                  ),
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "reel-swipe-key",
          keyTarget: reelWidgetKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.5),
                  child: const Icon(
                    Icons.swipe_up,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Transform.translate(
                  offset: const Offset(0, -50),
                  child: CoachMarkDescription(
                    text: "Swipe up to move to the next Product.",
                    next: "Next",
                    onNext: () {
                      controller.next();
                    },
                  ),
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "wishlist-key",
          keyTarget: wishListButtonKey,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.5),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachMarkDescription(
                  text: "Double tap to add to Wishlist.",
                  next: "Next",
                  onNext: () {
                    controller.next();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "reel-right-swipe-key",
          keyTarget: reelWidgetKey,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.5),
                  child: const Icon(
                    Icons.swipe_right,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Transform.translate(
                  offset: const Offset(0, -50),
                  child: CoachMarkDescription(
                    text: "Swipe right to add to Cart.",
                    next: "Next",
                    onNext: () {
                      controller.next();
                    },
                  ),
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "filterbutton-key",
          keyTarget: filterButtonKey,
          contents: [
            TargetContent(
              builder: (context, controller) {
                return Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * 0.5),
                  child: const Icon(
                    Icons.auto_fix_high_sharp,
                    color: Colors.white,
                    size: 100,
                  ),
                );
              },
            ),
            TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return CoachMarkDescription(
                  text: "Select and apply filters.",
                  next: "Next",
                  onNext: () {
                    controller.skip();
                  },
                );
              },
            ),
          ]),
    ];
  }

  // Show tutorial for guiding users
  void _showTutorial() {
    _initTarget();
    var utorialCoachMar = TutorialCoachMark(
      opacityShadow: 0.8,
      alignSkip: Alignment.topRight,
      textStyleSkip: AppStyles.boldText.copyWith(color: Colors.white),
      paddingFocus: 2,
      pulseEnable: false,
      targets: targets,
    )..show(context: context);
  }

  // Check if the tutorial has been shown using SharedPreferences
  Future<void> _checkTutorialStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShown') ?? false;

    if (!tutorialShown) {
      setState(() {
        _tutorialseen = true; // Set to show the tutorial
      });

      // Mark the tutorial as shown for future app launches
      await prefs.setBool('tutorialShown', true);
    }
  }

  // Add these state variables
  List<String> selectedBrands = [];
  List<String> selectedCategories = [];
  String minPrice = '';
  String maxPrice = '';

  @override
  void dispose() {
    if (widget.videoUrl.isNotEmpty && _videoController.value.isInitialized) {
      _videoController.dispose();
      _videoController.pause();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkTutorialStatus(); // Check if the tutorial has been shown before
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (widget.videoUrl.isNotEmpty) {
          _videoController =
              VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
                ..initialize().then((_) {
                  setState(() {
                    _isVideoInitialized = true; // Update initialization status
                  });

                  if (_tutorialseen) {
                    _showTutorial();
                  }
                });
          _videoController.setLooping(true);
          _videoController.play();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  void showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            "Add Filters",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          contentPadding: const EdgeInsets.all(16),
          children: [
            FilterButtonWidget(
              buttonTag: 'Brands',
              onApplyFilters: (searchModel) {
                setState(() {
                  isvendorfilterSelected = true;
                  selectedBrands = searchModel.brands ?? [];
                });
              },
            ),

            FilterButtonWidget(
              buttonTag: "Category",
              onApplyFilters: (searchModel) {
                setState(() {
                  selectedCategories = searchModel.categories ?? [];
                });
              },
            ),
            FilterButtonWidget(
              buttonTag: "Price",
              onApplyFilters: (searchModel) {
                setState(() {
                  minPrice = searchModel.price?.min ?? '';
                  maxPrice = searchModel.price?.max ?? '';
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // APPLY FILTER BUTTON TO SEND A REQUEST TO GET FILTERED PRODUCT REEELS.........
            Consumer<ProductFilterViewModel>(
                builder: (context, productFilterViewModel, child) {
              return ApplyFilterButton(
                onTap: () {
                  Navigator.pop(context);
                  final searchModel = SearchModel(
                    brands: selectedBrands,
                    categories: selectedCategories,
                    price: Price(min: minPrice, max: maxPrice),
                  );
                  debugPrint('Applied Filters: ${searchModel.toJson()}');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // if (selectedBrands.isNotEmpty) {
                    //   productFilterViewModel.NewfilterProductsByVendors(
                    //       selectedBrands);
                    // }
                    // if (selectedCategories.isNotEmpty) {
                    //   productFilterViewModel.NewfilterProductsByCategories(
                    //       selectedCategories);
                    // }
                    // if (maxPrice.isNotEmpty && minPrice.isNotEmpty) {
                    //   productFilterViewModel.NewfilterProductsByPriceRange(
                    //       double.parse(searchModel.price!.min),
                    //       double.parse(searchModel.price!.max));
                    // }
                    productFilterViewModel.applyFilters(
                        vendorNames: selectedBrands,
                        categoryNames: selectedCategories,
                        maxPrice: double.tryParse(maxPrice),
                        minPrice: double.tryParse(minPrice));
                    // productFilterViewModel
                    //     .filterProductsByMultipleStoresAndCategories(
                    //         storeNames: selectedBrands,
                    //         categoryNames: selectedCategories,
                    //         minPrice: double.parse(searchModel.price!.min),
                    //         maxPrice: double.parse(searchModel.price!.max));
                  });

                  // Navigating to the filtered product Reels Widegt.....

                  if (productFilterViewModel.filteredProducts.isNotEmpty &&
                      // ignore: unnecessary_null_comparison
                      productFilterViewModel.filteredProducts != null) {
                    debugPrint(
                        productFilterViewModel.filteredProducts.toString());
                    Navigator.pushNamed(context, RoutesName.mainUi);
                    _videoController.pause();
                  } else {
                    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //     content: Text(
                    //         "Filtered products are Empty, cannot navigate")));
                    debugPrint(
                        'Filtered products are null or empty, cannot navigate');
                    // Navigator.pop(context);
                  }

                  debugPrint(ProductFilterViewModel()
                      .filteredProducts
                      .length
                      .toString());
                },
              );
            }),
            const ClearFilterButton(),
          ],
        );
      },
    );
  }

  double animationHeight = 0;
  double animationWidth = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer3<ProductProvider, WishlistViewModel,
        ProductFilterViewModel>(
      builder:
          (context, reelProvider, wishlistViewModel, filterViewModel, child) {
        final List<model.ProductModel>? reelData =
            filterViewModel.filteredProducts.isNotEmpty
                ? filterViewModel.filteredProducts
                : reelProvider.products;

        final product = reelData![widget.index];
        bool isLiked =
            wishlistViewModel.isItemInWishlist(product.id.toString());
        // WidgetsBinding.instance.addPostFrameCallback((_) {});
        var w = MediaQuery.of(context).size.width;
        var h = MediaQuery.of(context).size.height;

        return GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.productScreen,
              arguments: {
                "isPushedFromReelScreen": true,
                "productID": product.id,
                "index": widget.index,
                "screenName": "ReelScreen",
              },
            );
            if (_videoController.value.isPlaying) {
              _videoController.pause();
            }
          },
          onDoubleTap: () async {
            await LocalNotificationSevice.showNotifications(
                notificationLayout: NotificationLayout.BigPicture,
                bigPicture: product.images.first.src,
                title: "Mambo • Wishlist",
                body:
                    '${product.name} by ${filterViewModel.filteredProducts.isNotEmpty ? product.store!.name : product.store!.shopName} added to Wishlist');

            wishlistViewModel
                .createWishlistItem(
              WishListModel(
                vendor: Vendor(
                  vendorId: product.store!.id!,
                  vendorName: filterViewModel.filteredProducts.isNotEmpty
                      ? product.store!.name
                      : product.store!.shopName,
                  vendorStore: product.store!.shopName,
                ),
                product: Product(
                  productId: product.id,
                  productName: product.name,
                ),
                price: (product.onSale!)
                    ? product.salePrice
                    : product.regularPrice,
                category: product.categories.first.name,
                imageUrl: product.images.first.src,
                createdAt: DateTime.now(),
              ),
            )
                .then((_) {
              setState(() {
                isLiked = true;
                _addedtowishlist = true;
              });
            });
          },
          child: Stack(children: [
            (widget.videoUrl.isNotEmpty && _isVideoInitialized)
                ? SizedBox(
                    width: w,
                    height: h,
                    child: _videoController.value.isInitialized
                        ? VideoPlayer(_videoController)
                        : SizedBox(
                            height: h,
                            width: w,
                            child: CachedNetworkImage(
                                imageUrl: product.images.first.src!)),
                  )
                : Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        height: h,
                        width: w,
                        color: Colors.black,
                        child: FlutterCarousel(
                          options: CarouselOptions(
                              slideIndicator: SequentialFillIndicator(
                                  slideIndicatorOptions:
                                      const SlideIndicatorOptions(
                                          indicatorBackgroundColor:
                                              Color.fromARGB(81, 0, 0, 0),
                                          currentIndicatorColor: Colors.white)),
                              height: h,
                              viewportFraction: 1.0,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 3),
                              indicatorMargin: h / 5.6),
                          items: product.images.map((image) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: h / 6, top: h / 6),
                              child: (image.src!.isNotEmpty ||
                                      image.src != null)
                                  ? CachedNetworkImage(
                                      imageUrl: image.src!,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      placeholder: (context, url) => Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        color: Colors.transparent,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          color: Colors.grey[300],
                                        )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                            Icons.image_not_supported_rounded,
                                            size: 40),
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue),
                                    ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
            // Invisible container to capture gestures for tutorial
            Padding(
              padding: const EdgeInsets.all(10.0),
              // ignore: sized_box_for_whitespace
              child: Container(
                key: reelWidgetKey,
                height: MediaQuery.of(context).size.height -
                    (kBottomNavigationBarHeight + h * 0.17),
                child: _addedtowishlist
                    ? Align(
                        alignment: Alignment.center, // Center the heart icon
                        child: AutoHeartAnimationWidget(),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              // ignore: sized_box_for_whitespace
              child: Container(
                key: reelWidgetKey2,
                height: MediaQuery.of(context).size.height -
                    (kBottomNavigationBarHeight + h * 0.17),
                // ignore: prefer_const_constructors
                child: _addedtowishlist
                    ? Align(
                        heightFactor: MediaQuery.of(context).size.height * 0.8,
                        widthFactor: MediaQuery.of(context).size.height * 0.5,
                        // alignment: Alignment.bottomCenter,
                        child: AutoHeartAnimationWidget())
                    : null,
              ),
            ),

            // Product details banner at the bottom
            Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: h * 0.17,
                  width: w,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      Color.fromARGB(50, 0, 0, 0),
                      Color.fromARGB(139, 0, 0, 0),
                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) => ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.9),
                          child: Text(
                            product.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppConst.isDeviceAPhone()
                                ? AppStyles.productNameOverReels
                                : AppStyles.productNameOverReels
                                    .copyWith(fontSize: 25),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      (filterViewModel.filteredProducts.isEmpty)
                          ? Text(
                              'By : ${product.store!.shopName}',
                              style: AppConst.isDeviceAPhone()
                                  ? AppStyles.vendorNameOverReels
                                  : AppStyles.vendorNameOverReels
                                      .copyWith(fontSize: 16),
                            )
                          : Text(
                              '${product.name}',
                              style: AppConst.isDeviceAPhone()
                                  ? AppStyles.vendorNameOverReels
                                  : AppStyles.vendorNameOverReels
                                      .copyWith(fontSize: 16),
                            ),
                      const SizedBox(height: 5),
                      (product.type == "variable")
                          ? Row(
                              children: [
                                Text(
                                  '₹${product.price}.00',
                                  style: AppConst.isDeviceAPhone()
                                      ? AppStyles.priceTagOverReels
                                      : AppStyles.priceTagOverReels
                                          .copyWith(fontSize: 18),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                (product.onSale!)
                                    ? Row(
                                        children: [
                                          Text(
                                            '₹${product.regularPrice}.00',
                                            style: AppConst.isDeviceAPhone()
                                                ? AppStyles.priceTagOverReels.copyWith(
                                                    fontSize: 18,
                                                    color: const Color.fromRGBO(
                                                        213, 213, 213, 0.863),
                                                    decorationColor:
                                                        const Color.fromRGBO(213,
                                                            213, 213, 0.863),
                                                    decorationThickness: 1.5,
                                                    decoration: TextDecoration
                                                        .lineThrough)
                                                : AppStyles
                                                    .priceTagOverReels
                                                    .copyWith(
                                                        fontSize: 18,
                                                        decorationColor:
                                                            Colors.white,
                                                        decorationStyle:
                                                            TextDecorationStyle
                                                                .solid,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough),
                                          ),
                                          Text(
                                            ' ₹${product.salePrice}.00',
                                            style: AppConst.isDeviceAPhone()
                                                ? AppStyles.priceTagOverReels
                                                : AppStyles.priceTagOverReels
                                                    .copyWith(fontSize: 18),
                                          )
                                        ],
                                      )
                                    : Text(
                                        ' ₹${product.regularPrice}.00',
                                        style: AppConst.isDeviceAPhone()
                                            ? AppStyles.priceTagOverReels
                                            : AppStyles.priceTagOverReels
                                                .copyWith(fontSize: 18),
                                      ),
                              ],
                            )
                    ],
                  ),
                )),
            // Add to wishlist button
            Positioned(
                right: 10,
                bottom: AppConst.isDeviceAPhone()
                    ? (MediaQuery.of(context).size.height / 13 + 6) //Modified
                    : 90,
                child: Consumer<WishlistViewModel>(
                    builder: (context, wishlistViewModel, child) {
                  return IconButton(
                      key: wishListButtonKey,
                      onPressed: () {
                        if (isLiked) {
                          wishlistViewModel
                              .deleteWishlistItem(
                            WishListModel(
                              vendor: Vendor(
                                vendorId: product.store!.id!,
                                vendorName: product.store!.name!,
                                vendorStore:
                                    filterViewModel.filteredProducts.isNotEmpty
                                        ? product.store!.name
                                        : product.store!.shopName,
                              ),
                              product: Product(
                                productId: product.id,
                                productName: product.name,
                              ),
                              price: (product.onSale!)
                                  ? product.salePrice
                                  : product.regularPrice,
                              category: product.categories.first.name,
                              imageUrl: product.images.first.src,
                              createdAt: DateTime.now(),
                            ),
                          )
                              .then((context) {
                            setState(() {
                              _addedtowishlist = false;
                            });
                          });
                        } else {
                          LocalNotificationSevice.showNotifications(
                              notificationLayout: NotificationLayout.BigPicture,
                              bigPicture: product.images.first.src,
                              title: "Mambo • Wishlist",
                              body:
                                  '${product.name} by ${filterViewModel.filteredProducts.isNotEmpty ? product.store!.name : product.store!.shopName} added to Wishlist');
                          wishlistViewModel
                              .createWishlistItem(
                            WishListModel(
                              vendor: Vendor(
                                vendorId: product.store!.id!,
                                vendorName: product.store!.name!,
                                vendorStore:
                                    filterViewModel.filteredProducts.isNotEmpty
                                        ? product.store!.name
                                        : product.store!.shopName,
                              ),
                              product: Product(
                                productId: product.id,
                                productName: product.name,
                              ),
                              price: (product.onSale!)
                                  ? product.salePrice
                                  : product.regularPrice,
                              category: product.categories.first.name,
                              imageUrl: product.images.first.src,
                              createdAt: DateTime.now(),
                            ),
                          )
                              .then((_) {
                            setState(() {
                              isLiked = true;
                              _addedtowishlist = true;
                            });
                          });
                        }
                      },
                      icon: Icon(
                        size:
                            AppConst.isDeviceAPhone() ? 30 : 30 + 4, //Modified
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isLiked ? Colors.red : Colors.white,
                      ));
                })),

            // Filter button
            Positioned(
                right: 10,
                bottom: 20,
                child: IconButton(
                  key: filterButtonKey,
                  icon: Icon(
                    size: AppConst.isDeviceAPhone() ? 28 : 28 + 4, //Modified
                    Icons.tune,
                    color: filterViewModel.filteredProducts.isEmpty
                        ? Colors.white
                        : Colors.grey,
                  ),
                  onPressed: () {
                    filterViewModel.filteredProducts.isEmpty
                        ? showFilterDialog(context)
                        : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                "Press back button to see all the products.")));
                  },
                )),
            Positioned(
              top: 40,
              left: 10,
              child: Consumer<ProductFilterViewModel>(
                  builder: (context, value, child) {
                return value.filteredProducts.isNotEmpty
                    ? Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              // value.clearFilteredData();
                              value.filteredProducts.clear();
                              Navigator.pushReplacementNamed(
                                  context, RoutesName.mainUi);
                              _videoController.pause();
                            },
                            icon: Icon(Icons.arrow_back_rounded,
                                size: AppConst.isDeviceAPhone()
                                    ? 28
                                    : 28 + 4, //Modified
                                color: Colors.white),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            "Filtered Products",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : const SizedBox();
              }),
            )
          ]),
        );
      },
    );
  }
}
