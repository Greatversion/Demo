// ignore_for_file: prefer_final_fields

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mambo/models/Network%20models/product_model.dart';
import 'package:mambo/models/Network%20models/vendors_model.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/view%20models/vendor_view_model.dart';
import 'package:provider/provider.dart';

import 'package:mambo/utils/app.constants.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/category_view_model.dart';

import '../../utils/Category/category_product_widget.dart';

/// Represents a screen that displays products filtered by a selected category.
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({
    super.key,
    required this.index,
    required this.categoryID,
    required this.categoryName,
  });

  final int categoryID; // Unique identifier for the selected category
  final String categoryName; // Name of the selected category
  final int index; // Index used to locate the category in a list

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  // Track selected filters
  List<int> _selectedPriceIndices = [];
  List<int> _selectedVendorIndices = [];
  ErrorMessages errorMessages = ErrorMessages();
  bool _selectedOnSale = false;
  List<int> _selectedRatingIndices = [];
  late List<Vendors> vendors = [];

  // Define price ranges for filtering
  final List<Map<String, dynamic>> priceRanges = [
    {'label': '₹0 - ₹100', 'min': 0, 'max': 100},
    {'label': '₹100 - ₹500', 'min': 100, 'max': 500},
    {'label': '₹500 - ₹1500', 'min': 500, 'max': 1500},
    {'label': '₹1500+', 'min': 2500, 'max': 100000},
  ];

  // Define rating ranges for filtering
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
    // Fetch products and vendors after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      final vendorProvider =
          Provider.of<VendorProvider>(context, listen: false);
      provider.categoryProducts.clear(); // Clear previous category products
      provider.fetchProductsByCategory(
          widget.categoryID); // Fetch products by category ID
      vendorProvider.fetchVendors(); // Fetch vendor data
    });
  }

  /// Applies selected filters to the product list.
  void applyFilters() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final vendorProvider = Provider.of<VendorProvider>(context, listen: false);
    provider.clearFilteredProducts(); // Clear any existing filters
    vendorProvider.clearFilteredProducts();

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
    if (_selectedVendorIndices.isNotEmpty) {
      List<ProductModel> tempFilteredProducts = [];
      for (var vendorId in _selectedVendorIndices) {
        List<ProductModel> vendorFilteredProducts =
            provider.getFilteredProductsByVendors(vendorId);
        tempFilteredProducts.addAll(vendorFilteredProducts);
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
        _selectedVendorIndices.isEmpty &&
        !_selectedOnSale &&
        _selectedRatingIndices.isEmpty) {
      provider.resetFilteredProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorProvider = Provider.of<VendorProvider>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                icon: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(237, 255, 255, 255),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 3.0, bottom: 3, left: 7),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: AppStyles.backIconSize + 2,
                    ),
                  ),
                )),
            automaticallyImplyLeading: false,
            // pinned: true, // Keep the app bar pinned at the top
            expandedHeight:
                AppConst.screenHeight / 4, // Expanded height remains the same
            backgroundColor: Colors.blueGrey,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: categoryProvider
                                            .categories[widget.index].image !=
                                        null
                                    ? CachedNetworkImageProvider(
                                        categoryProvider
                                            .categories[widget.index]
                                            .image!
                                            .src!)
                                    : const CachedNetworkImageProvider(
                                        'https://placehold.co/600x400/png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                      // Gradient Overlay
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Color.fromARGB(50, 0, 0, 0),
                              Color.fromARGB(139, 0, 0, 0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      // Fixed Title (Text stays in place)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: AppConst.screenHeight /
                              4, // Same as expanded height
                          alignment: Alignment
                              .bottomCenter, // Align the text to the bottom
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.categoryName, // Display category name
                                  style: AppStyles.boldText.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                    color: Colors.white,
                                    fontSize: 29,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) =>
                                            SizedBox(
                                          height: 300,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
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
                                                // Build Filter Chips
                                                buildFilterChips(priceRanges,
                                                    _selectedPriceIndices,
                                                    (index) {
                                                  setState(() {
                                                    if (_selectedPriceIndices
                                                        .contains(index)) {
                                                      _selectedPriceIndices
                                                          .remove(index);
                                                    } else {
                                                      _selectedPriceIndices
                                                          .add(index);
                                                    }
                                                  });
                                                  applyFilters(); // Apply filters when changed
                                                }),

                                                // Vendor Filter Chips
                                                buildVendorChips(
                                                    vendorProvider.allvendors,
                                                    _selectedVendorIndices,
                                                    (vendorId) {
                                                  setState(() {
                                                    if (_selectedVendorIndices
                                                        .contains(vendorId)) {
                                                      _selectedVendorIndices
                                                          .remove(vendorId);
                                                    } else {
                                                      _selectedVendorIndices
                                                          .add(vendorId);
                                                    }
                                                  });
                                                  applyFilters(); // Apply filters when changed
                                                }),

                                                // Rating Filter Chips
                                                buildFilterChips(ratingRanges,
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
                                                          BorderRadius.circular(
                                                              100)),
                                                  activeColor: Colors.white,
                                                  tileColor: Colors.black,
                                                  title: const Text(
                                                    "On Sale",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  value: _selectedOnSale,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      _selectedOnSale = value;
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
                                child: const Icon(
                                  Icons
                                      .tune, // Filter icon for showing filter modal
                                  color: Colors.white,
                                  size: 35,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Consumer2<ProductProvider, CategoryProvider>(
              builder: (context, productProvider, categoryProvider, child) {
                if (productProvider.isLoading) {
                  return const Center(
                    heightFactor: 10,
                    child:
                        CircularProgressIndicator(), // Show loading indicator while fetching products
                  );
                } else if (productProvider.categoryProducts.isEmpty) {
                  return const Center(
                    widthFactor: 5,
                    heightFactor: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.campaign_rounded, size: 70),
                        Text(
                          "Stay tuned!", // Inform user if no products are available
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Your favorite products are on their way", // Inform user if no products are available
                          style: TextStyle(
                              color: Color.fromARGB(255, 116, 116, 116),
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                } else if (productProvider.filteredProducts.isEmpty) {
                  return Center(
                    heightFactor: 4,
                    child: ErrorDisplayWidget(
                        msg: errorMessages.searchResultsError().message,
                        desc: errorMessages
                            .searchResultsError()
                            .description), // Show error if no products match filters
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: MasonryGridView.count(
                      crossAxisCount: AppConst.isDeviceAPhone()
                          ? 2
                          : 3, // Adjust grid based on device type
                      itemCount: productProvider.filteredProducts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CategoryProductWidget(
                          index: index,
                          productModel: productProvider.filteredProducts[
                              index], // Display filtered products
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Widget to build filter chips for various filter options.
  Widget buildFilterChips(List<Map<String, dynamic>> filterList,
      List<int> selectedIndices, Function(int) onSelected) {
    return SizedBox(
      height: 60,
      // padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: FilterChip(
              shape: const StadiumBorder(),
              label: Text(filterList[index]['label']),
              side: const BorderSide(width: 0.7),
              selected: selectedIndices.contains(index),
              onSelected: (bool selected) {
                onSelected(index); // Handle chip selection
              },
            ),
          );
        },
      ),
    );
  }

  /// Widget to build filter chips for vendor selection.
  Widget buildVendorChips(List<Vendors> vendors, List<int> selectedIndices,
      Function(int) onSelected) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vendors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 9.0),
            child: FilterChip(
              shape: const StadiumBorder(),
              side: const BorderSide(width: 0.7),
              label:
                  Text('${vendors[index].storeName}'), // Use vendor store name
              selected: selectedIndices.contains(vendors[index].id),
              onSelected: (bool selected) {
                onSelected(vendors[index].id!); // Handle chip selection
              },
            ),
          );
        },
      ),
    );
  }
}
