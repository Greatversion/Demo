import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Error%20Messages/error_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';

class WishlistSearchScreen extends StatefulWidget {
  const WishlistSearchScreen({super.key});

  @override
  _WishlistSearchScreenState createState() => _WishlistSearchScreenState();
}

class _WishlistSearchScreenState extends State<WishlistSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  ErrorMessages errorMessages = ErrorMessages();
  @override
  void initState() {
    super.initState();
    final wishlistProvider =
        Provider.of<SearchProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch wishlist items initially
      wishlistProvider.fetchWishlist();
    });

    // Listen to the search controller and filter wishlist items in real-time
    _searchController.addListener(() {
      wishlistProvider.filterWishlist(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search in your wishlist...',
            border: InputBorder.none,
          ),
          onSubmitted: (query) {
            Provider.of<SearchProvider>(context, listen: false)
                .filterWishlist(query);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Provider.of<SearchProvider>(context, listen: false)
                  .filterWishlist(_searchController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Consumer<SearchProvider>(
          builder: (context, wishlistProvider, child) {
            if (wishlistProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (wishlistProvider.errorMessage.isNotEmpty) {
              return Center(child: Text(wishlistProvider.errorMessage));
            } else if (wishlistProvider.wishlist.isEmpty) {
              return ErrorDisplayWidget(
                  msg: errorMessages.searchResultsError().message,
                  desc: errorMessages.searchResultsError().description);
            }
            return Consumer<ProductProvider>(
              builder: (context, val, child) {
                return ListView.builder(
                  itemCount: wishlistProvider.wishlist.length,
                  itemBuilder: (context, index) {
                    final WishListModel item = wishlistProvider.wishlist[index];

                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                18.0), // adjust the border radius as needed
                            // adjust the border color and width as needed
                          ),
                          tileColor: const Color.fromARGB(13, 158, 158, 158),
                          title: Text(
                            item.product!.productName!,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.vendor!.vendorStore!.replaceFirst(
                                    item.vendor!.vendorStore!.characters.first,
                                    item.vendor!.vendorStore!.characters.first
                                        .toUpperCase()),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                '₹${item.price}.00',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                          leading: CachedNetworkImage(
                            imageUrl: item.imageUrl!,
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
                                "productID": item.product!.productId,
                                "index": index,
                                "screenName": "Wishlist"
                              },
                            );
                          },
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
