import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/search_view_model.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  ErrorMessages errorMessages = ErrorMessages();
  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    // Fetch products initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchProvider.searchProducts('');
      // Listen to the search controller and filter products in real-time
      _searchController.addListener(() {
        searchProvider.filterProducts(_searchController.text);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            Provider.of<SearchProvider>(context, listen: false)
                .searchProducts(query);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Provider.of<SearchProvider>(context, listen: false)
                  .searchProducts(_searchController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 5),
        child: Consumer2<SearchProvider, ConnectivityService>(
          builder: (context, searchProvider, connectivity, child) {
            if (searchProvider.errorMessage.isNotEmpty) {
              debugPrint(searchProvider.errorMessage);
            }
            if (searchProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (searchProvider.filteredProducts.isEmpty) {
              return ErrorDisplayWidget(
                  msg: errorMessages.searchResultsError().message,
                  desc: errorMessages.searchResultsError().description);
            } else if (!connectivity.isOnline) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.signal_wifi_off, size: 50, color: Colors.red),
                    SizedBox(height: 15),
                    Text(
                      "No Internet Connection",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return ListView.builder(
                  itemCount: searchProvider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = searchProvider.filteredProducts[index];

                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                18.0), // adjust the border radius as needed
                            // adjust the border color and width as needed
                          ),
                          title: Text(
                            product.name!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                product.store!.shopName!.replaceFirst(
                                    product.store!.shopName!.characters.first,
                                    product.store!.shopName!.characters.first
                                        .toUpperCase()),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                              (product.type == "variable")
                                  ? Text(
                                      '  ₹${product.price}.00',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(
                                      '  ₹${product.regularPrice}.00',
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    )
                            ],
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: product.images.first.src!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              height: 50,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 50,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesName.productScreen,
                              arguments: {
                                "isPushedFromReelScreen": false,
                                "productID": product.id,
                                "index": index,
                                "screenName": "ExplorePage",
                              },
                            );
                          },
                          tileColor: const Color.fromARGB(13, 158, 158, 158),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
