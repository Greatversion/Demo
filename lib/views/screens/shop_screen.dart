// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/view%20models/category_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/vendor_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/Reusable_widgets/Shop/shop_product_tile.dart';

class ShopScreen extends StatefulWidget {
  final int vendorId;
  final int index;

  const ShopScreen({
    super.key,
    required this.vendorId,
    required this.index,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<int> _selectedPriceIndices = [];
  List<int> _selectedCategoryIndices = [];
  bool _selectedOnSale = false;
  List<int> _selectedRatingIndices = [];
  // late List<int> categories = [];
  ErrorMessages errorMessages = ErrorMessages();

  final List<Map<String, dynamic>> priceRanges = [
    {'label': '₹0 - ₹100', 'min': 0, 'max': 100},
    {'label': '₹100 - ₹500', 'min': 100, 'max': 500},
    {'label': '₹500 - ₹1500', 'min': 500, 'max': 1500},
    {'label': '₹1500+', 'min': 1500, 'max': 100000},
  ];

  final List<Map<String, dynamic>> ratingRanges = [
    {'label': 'No Ratings', 'min': 0, 'max': 1},
    {'label': '1 Star', 'min': 1.1, 'max': 2},
    {'label': '2 Stars', 'min': 2.1, 'max': 3},
    {'label': '3 Stars', 'min': 3.1, 'max': 4},
    {'label': '4+ Stars', 'min': 4.1, 'max': 5},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VendorProvider>(context, listen: false);
      final categoryProvider =
          Provider.of<CategoryProvider>(context, listen: false);
      provider.vendorProducts.clear();
      // categories = categoryProvider.categoriesID;
      categoryProvider.fetchCategoriesii(context);
      provider.fetchVendorById(widget.vendorId);
      provider.fetchProductsByVendor(widget.vendorId);
    });
  }

  void applyFilters() {
    final provider = Provider.of<VendorProvider>(context, listen: false);
    provider.clearFilteredProducts(); // Start with a fresh copy of all products

    // Step 1: Apply price filters
    if (_selectedPriceIndices.isNotEmpty) {
      List<ProductModel> tempFilteredProducts = [];
      for (var index in _selectedPriceIndices) {
        List<ProductModel> priceFilteredProducts =
            provider.getFilteredProductsByPriceRange(priceRanges[index]);
        tempFilteredProducts.addAll(priceFilteredProducts);
      }
      provider.setFilteredProducts(tempFilteredProducts);
    }

    // Step 2: Apply category filters
    if (_selectedCategoryIndices.isNotEmpty) {
      List<ProductModel> tempFilteredProducts = [];
      for (var categoryId in _selectedCategoryIndices) {
        List<ProductModel> categoryFilteredProducts =
            provider.getFilteredProductsByCategory(categoryId);
        tempFilteredProducts.addAll(categoryFilteredProducts);
      }
      provider.setFilteredProducts(tempFilteredProducts);
    }

    // Step 3: Apply on sale filter
    if (_selectedOnSale) {
      List<ProductModel> onSaleFilteredProducts =
          provider.getFilteredProductsByOnSale();
      provider.setFilteredProducts(onSaleFilteredProducts);
    }

    // Step 4: Apply rating filters
    if (_selectedRatingIndices.isNotEmpty) {
      List<ProductModel> tempFilteredProducts = [];
      for (var index in _selectedRatingIndices) {
        List<ProductModel> ratingFilteredProducts =
            provider.getFilteredProductsByRatingRange(ratingRanges[index]);
        tempFilteredProducts.addAll(ratingFilteredProducts);
      }
      provider.setFilteredProducts(tempFilteredProducts);
    }

    // If no filters are selected, reset to show all products
    if (_selectedPriceIndices.isEmpty &&
        _selectedCategoryIndices.isEmpty &&
        !_selectedOnSale &&
        _selectedRatingIndices.isEmpty) {
      provider.resetFilteredProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer2<VendorProvider, CategoryProvider>(
          builder: (context, vendorProvider, categoryProvider, child) {
            return Column(
              children: [
                // Vendor Banner
                Container(
                  height: 200,
                  width: double.maxFinite,
                  color: const Color.fromARGB(255, 70, 70, 70),
                  child: Stack(
                    children: [
                      Center(
                        child: vendorProvider.vendor != null
                            ? CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: vendorProvider.vendor!.banner!,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Text("No Preview Available",
                                        style: TextStyle(color: Colors.white)),
                              )
                            : const CircularProgressIndicator(),
                      ),
                      Positioned(
                        top: 40,
                        left: 15,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(237, 255, 255, 255),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 3.0, bottom: 3, left: 7),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: AppStyles.backIconSize + 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                vendorProvider.vendor != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10, bottom: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 35,
                                      backgroundImage: NetworkImage(
                                          vendorProvider.vendor!.gravatar ??
                                              ""),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vendorProvider.vendor!.storeName!,
                                          style: AppStyles.extratBoldText
                                              .copyWith(fontSize: 22),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  launchUrl(
                                                    Uri.parse(vendorProvider
                                                        .vendor!
                                                        .social['instagram']
                                                        .toString()),
                                                  );
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      "Instagram",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              100,
                                                              100,
                                                              100),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Icon(
                                                      Icons.link,
                                                      size: 14,
                                                    )
                                                  ],
                                                )),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: () {
                                                  launchUrl(
                                                      Uri.parse(vendorProvider
                                                          .vendor!.social['fb']
                                                          .toString()),
                                                      mode: LaunchMode
                                                          .inAppBrowserView);
                                                },
                                                child: const Row(
                                                  children: [
                                                    Text(
                                                      "Facebook",
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              100,
                                                              100,
                                                              100),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    SizedBox(width: 2),
                                                    Icon(
                                                      Icons.link,
                                                      size: 14,
                                                    )
                                                  ],
                                                )),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                            builder: (context, setState) =>
                                                SizedBox(
                                              height: 300,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      '" Filter as you like "',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),

                                                    // Price Filter Chips

                                                    buildFilterChips(
                                                      priceRanges,
                                                      _selectedPriceIndices,
                                                      (index) {
                                                        setState(() {
                                                          if (_selectedPriceIndices
                                                              .contains(
                                                                  index)) {
                                                            _selectedPriceIndices
                                                                .remove(index);
                                                          } else {
                                                            _selectedPriceIndices
                                                                .add(index);
                                                          }
                                                        });
                                                        applyFilters(); // Apply filters when changed
                                                      },
                                                    ),

                                                    // Category Filter Chips
                                                    // Note: This assumes you have a categoryProvider to fetch category data
                                                    buildCategoryChips(
                                                        categoryProvider
                                                            .newcategories,
                                                        _selectedCategoryIndices,
                                                        (categoryId) {
                                                      setState(() {
                                                        if (_selectedCategoryIndices
                                                            .contains(
                                                                categoryId)) {
                                                          _selectedCategoryIndices
                                                              .remove(
                                                                  categoryId);
                                                        } else {
                                                          _selectedCategoryIndices
                                                              .add(categoryId);
                                                        }
                                                      });
                                                      applyFilters(); // Apply filters when changed
                                                    }),

                                                    // Rating Filter Chips
                                                    buildFilterChips(
                                                        ratingRanges,
                                                        _selectedRatingIndices,
                                                        (index) {
                                                      setState(() {
                                                        if (_selectedRatingIndices
                                                            .contains(index)) {
                                                          _selectedRatingIndices
                                                              .remove(index);
                                                        } else {
                                                          _selectedRatingIndices
                                                              .add(index);
                                                        }
                                                      });
                                                      applyFilters(); // Apply filters when changed
                                                    }),

                                                    const SizedBox(height: 5),

                                                    // On Sale Filter
                                                    SwitchListTile(
                                                      dense: true,
                                                      shape: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100)),
                                                      activeColor: Colors.white,
                                                      tileColor: Colors.black,
                                                      title: const Text(
                                                        "On Sale",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      value: _selectedOnSale,
                                                      onChanged: (bool value) {
                                                        setState(() {
                                                          _selectedOnSale =
                                                              value;
                                                        });
                                                        applyFilters(); // Apply filters when changed
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.tune_rounded,
                                      color: Colors.black,
                                      size: 32,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                // Price Filter Chips

                // Products grid
                Consumer<VendorProvider>(
                  builder: (context, vendorProvider, child) => vendorProvider
                          .isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : (vendorProvider.filteredProducts.isEmpty)
                          ? Center(
                              heightFactor: 3,
                              child: ErrorDisplayWidget(
                                  msg: errorMessages
                                      .searchResultsError()
                                      .message,
                                  desc: errorMessages
                                      .searchResultsError()
                                      .description),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 7.0),
                              child: MasonryGridView.builder(
                                itemCount:
                                    vendorProvider.filteredProducts.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      AppConst.isDeviceAPhone() ? 2 : 3,
                                ),
                                itemBuilder: (context, index) {
                                  return ShopProductTile(
                                    index: index,
                                    productModel:
                                        vendorProvider.filteredProducts[index],
                                  );
                                },
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildFilterChips(List<Map<String, dynamic>> filterList,
      List<int> selectedIndices, Function(int) onSelected) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: ChoiceChip(
              shape: const StadiumBorder(),
              side: const BorderSide(width: 0.7),
              label: Text(
                filterList[index]['label'],
              ),
              selected: selectedIndices.contains(index),
              onSelected: (bool selected) {
                onSelected(index);
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildCategoryChips(List<Category> category, List<int> selectedIndices,
      Function(int) onSelected) {
    return SizedBox(
      height: 60,
      // padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: FilterChip(
              shape: const StadiumBorder(),
              side: const BorderSide(width: 0.7),
              label: Text(
                '${category[index].name}',
              ), // Use category name instead
              selected: selectedIndices.contains(category[index].id),
              onSelected: (bool selected) {
                onSelected(category[index].id!);
              },
            ),
          );
        },
      ),
    );
  }
}
