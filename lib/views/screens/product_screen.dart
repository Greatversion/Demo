// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:html/dom.dart' as html;
import 'package:html/parser.dart';
import 'package:mambo/utils/Reusable_widgets/product/discount_tag_widget.dart';
import 'package:mambo/view%20models/review_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mambo/models/Database%20models/wishlist_model.dart';
import 'package:mambo/models/Network%20models/review_model.dart';
import 'package:mambo/providers/quantity_provider.dart';
import 'package:mambo/routes/app.nameRoutes.dart';
import 'package:mambo/utils/Reusable_widgets/product/add_to_cart_button.dart';
import 'package:mambo/utils/Reusable_widgets/product/select_quantity_button.dart';
import 'package:mambo/utils/Reusable_widgets/product/selection_widget.dart';
import 'package:mambo/utils/Reusable_widgets/product/star_rating_bar.dart';
import 'package:mambo/utils/Reusable_widgets/product/trailing_drop_down_widget.dart';
import 'package:mambo/utils/Social_Share/social_share.dart';
import 'package:mambo/utils/Time%20Stamp/time_ago_widget.dart';
import 'package:mambo/utils/app.colors.dart';
import 'package:mambo/utils/app.styles.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:mambo/utils/Loading/loading_screen.dart';

class ProductScreen extends StatefulWidget {
  final String screenName;

  final int index;
  final bool isPushedFromReelScreen;
  final int productID;

  const ProductScreen({
    super.key,
    required this.screenName,
    required this.index,
    required this.isPushedFromReelScreen,
    required this.productID,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  SocialShareClass socialShareClass = SocialShareClass();

  final ScrollController _scrollController = ScrollController();
  final Map<String, String> _selectedAttributes = {};
  bool _showBottomButton = false;
  final TextEditingController _reviewTextController = TextEditingController();

  // Dropdown related variables
  // ignore: prefer_final_fields
  String _selectedSortOption = 'Most Recent';
  var _showReviews = false;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      final quantityProvider =
          Provider.of<QuantityProvider>(context, listen: false);
      quantityProvider.resetQuantity(widget.productID.toString());
      productProvider.clearData();
      productProvider.loadAllReviews(widget.productID);
      if (productProvider.productByID == null) {
        productProvider.fetchProductById(widget.productID);
      }
    });

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final double offset = _scrollController.offset;
      if (offset > 100) {
        if (!_showBottomButton) {
          setState(() {
            _showBottomButton = true;
          });
        }
      } else {
        if (_showBottomButton) {
          setState(() {
            _showBottomButton = false;
          });
        }
      }
    }
  }

  String parseHtmlString(String htmlString) {
    // Parse the HTML string into a Document
    html.Document document = parse(htmlString);

    // Convert the Document to plain text by extracting the body text
    String parsedString = document.body?.text ?? '';

    return parsedString;
  }

  void _onOptionSelected(String attribute, String option) {
    setState(() {
      _selectedAttributes[attribute] = option;
    });
  }

  void _addReview() async {
    final review = WriteReviewModel(
      productId: widget.productID.toString(),
      reviewerName:
          FirebaseAuth.instance.currentUser!.displayName ?? "Anonymous",
      review: _reviewTextController.text,
      reviewerEmail: FirebaseAuth.instance.currentUser!.email!,
      // You can replace this with the user's name if available
    );

    // Call the ViewModel method to add the review
    final writeReviewViewModel =
        Provider.of<WriteReviewViewModel>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final success = await writeReviewViewModel.addReview(review);

    if (success) {
      setState(() {
        _showReviews = false; // Hide the form
        _reviewTextController.clear(); // Clear the form
        productProvider.loadAllReviews(widget.productID);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review added successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to add review. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final writeReviewViewModel = Provider.of<WriteReviewViewModel>(context);
    final quantityProvider =
        Provider.of<QuantityProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context);

    void navigateBackFunction() {
      if (!widget.isPushedFromReelScreen) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, RoutesName.mainUi);
      }
    }

    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    final List<String> sortOptions = [
      'Most Recent',
      'Highest Rating',
      'Lowest Rating'
    ];
    if (productProvider.productByID == null) {
      return LoadingScreen(
        screenName: widget.screenName,
      );
    }
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              _scrollListener();
              return false;
            },
            // ignore: deprecated_member_use
            child: WillPopScope(
              onWillPop: () async {
                navigateBackFunction();
                return false;
              },
              child: Consumer2<WishlistViewModel, ProductProvider>(builder:
                  (context, wishlistViewModel, productProvider, child) {
                final isLiked = wishlistViewModel
                    .isItemInWishlist(widget.productID.toString());

                // Sort reviews based on the selected option
                List<ReviewModel> sortedReviews = [...productProvider.reviews];
                if (_selectedSortOption == 'Highest Rating') {
                  sortedReviews.sort((a, b) => b.rating!.compareTo(a.rating!));
                } else if (_selectedSortOption == 'Lowest Rating') {
                  sortedReviews.sort((a, b) => a.rating!.compareTo(b.rating!));
                } else {
                  sortedReviews
                      .sort((a, b) => b.dateCreated!.compareTo(a.dateCreated!));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          width: w,
                          height: h * 0.4,
                          color: Colors.grey[300],
                          child: FlutterCarousel(
                            options: CarouselOptions(
                                slideIndicator: SequentialFillIndicator(
                                    slideIndicatorOptions:
                                        const SlideIndicatorOptions(
                                            indicatorBackgroundColor:
                                                Color.fromARGB(81, 0, 0, 0),
                                            currentIndicatorColor:
                                                Colors.white)),
                                height: h,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                indicatorMargin: 10),
                            items: productProvider.productByID!.images
                                .map((image) {
                              return (image.src!.isNotEmpty ||
                                      image.src != null)
                                  ? CachedNetworkImage(
                                      imageUrl: image.src!,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Center(
                                            child: CircularProgressIndicator()),
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
                                      width: MediaQuery.of(context).size.width,
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.blue),
                                    );
                            }).toList(),
                          ),
                        ),
                        Positioned(
                          top: 30,
                          left: 18, //Modified
                          child: InkWell(
                            onTap: () {
                              navigateBackFunction();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    237, 255, 255, 255), //modified
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3.0, bottom: 3, left: 7),
                                  child: Tooltip(
                                    message: "Return Back",
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.black,
                                      size: AppStyles.backIconSize + 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 30, //60
                          right: 18,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(-1.0, 1.0, 1.0),
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    237, 255, 255, 255), //modified
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  socialShareClass.shareProductDetails(
                                      productProvider.productByID!.name!,
                                      productProvider
                                          .productByID!.images.first.src!,
                                      productProvider
                                          .productByID!.store!.shopName!,
                                      (productProvider.productByID!.onSale!)
                                          ? ("${productProvider.productByID!.salePrice!} in a SUPER SALE !!")
                                          : productProvider
                                              .productByID!.regularPrice!,
                                      productProvider
                                          .productByID!.store!.name!);
                                },
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, bottom: 3),
                                    child: Tooltip(
                                      message: "Share",
                                      child: Icon(
                                        Icons.reply,
                                        size: AppStyles.backIconSize + 5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13.0, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      productProvider.productByID!.name!,
                                      style: AppStyles.semiBoldText.copyWith(
                                          fontSize: 27,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  IconButton(
                                      iconSize: 30,
                                      onPressed: () {
                                        if (isLiked) {
                                          wishlistViewModel.deleteWishlistItem(
                                            WishListModel(
                                              vendor: Vendor(
                                                vendorId: productProvider
                                                    .productByID!.id,
                                                vendorName: productProvider
                                                    .productByID!.store!.name!,
                                                vendorStore: productProvider
                                                    .productByID!
                                                    .store!
                                                    .shopName,
                                              ),
                                              product: Product(
                                                productId: productProvider
                                                    .productByID!.id,
                                                productName: productProvider
                                                    .productByID!.name,
                                              ),
                                              price:
                                                  (productProvider
                                                          .productByID!.onSale!)
                                                      ? productProvider
                                                          .productByID!
                                                          .salePrice!
                                                      : productProvider
                                                          .productByID!
                                                          .regularPrice!,
                                              category: productProvider
                                                  .productByID!
                                                  .categories
                                                  .first
                                                  .name,
                                              imageUrl: productProvider
                                                  .productByID!
                                                  .images
                                                  .first
                                                  .src,
                                              createdAt: DateTime.now(),
                                            ),
                                          );
                                        } else {
                                          wishlistViewModel.createWishlistItem(
                                            WishListModel(
                                              vendor: Vendor(
                                                vendorId: productProvider
                                                    .productByID!.store!.id!,
                                                vendorName: productProvider
                                                    .productByID!.store!.name!,
                                                vendorStore: productProvider
                                                    .productByID!
                                                    .store!
                                                    .shopName,
                                              ),
                                              product: Product(
                                                productId: productProvider
                                                    .productByID!.id,
                                                productName: productProvider
                                                    .productByID!.name,
                                              ),
                                              price:
                                                  (productProvider
                                                          .productByID!.onSale!)
                                                      ? productProvider
                                                          .productByID!
                                                          .salePrice!
                                                      : productProvider
                                                          .productByID!
                                                          .regularPrice!,
                                              category: productProvider
                                                  .productByID!
                                                  .categories
                                                  .first
                                                  .name,
                                              imageUrl: productProvider
                                                  .productByID!
                                                  .images
                                                  .first
                                                  .src,
                                              createdAt: DateTime.now(),
                                            ),
                                          );
                                        }
                                      },
                                      icon: isLiked
                                          ? const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_rounded,
                                              color: Colors.black,
                                            ))
                                ],
                              ),
                              Row(
                                children: [
                                  (productProvider.productByID!.onSale!)
                                      ? Row(
                                          children: [
                                            Text(
                                              "₹${productProvider.productByID!.regularPrice}.00",
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  decorationColor: Colors.grey,
                                                  decorationThickness: 2,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: Colors.grey),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "₹${productProvider.productByID!.salePrice}.00",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      : Text(
                                          "₹${productProvider.productByID!.regularPrice}.00",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                  const SizedBox(width: 8),
                                  productProvider.productByID!.onSale!
                                      ? DiscountTagWidget(
                                          discountText:
                                              "${(((double.parse(productProvider.productByID!.regularPrice!) - double.parse(productProvider.productByID!.salePrice!)) / double.parse(productProvider.productByID!.regularPrice!)) * 100).toInt().toString()}% OFF !!")
                                      : const SizedBox()
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(children: [
                                (double.parse(productProvider
                                            .productByID!.averageRating!) !=
                                        0.0)
                                    ? Row(
                                        children: [
                                          StarRatingBar(
                                            rating: double.parse(productProvider
                                                .productByID!.averageRating!),
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                              "(${productProvider.productByID!.averageRating!} stars)"),
                                        ],
                                      )
                                    : const SizedBox(),
                                Text(
                                    " (${productProvider.reviews.length.toString()} reviews)"),
                              ]),

                              const SizedBox(height: 10),
                              Text(
                                parseHtmlString(productProvider
                                    .productByID!.shortDescription!),
                                style: const TextStyle(fontSize: 15),
                                textAlign: TextAlign.justify,
                              ),
                              // const SizedBox(height: 5),
                              Column(
                                children: List.generate(
                                    productProvider.productByID!.attributes
                                        .length, (index) {
                                  final attribute = productProvider
                                      .productByID!.attributes[index];
                                  return attribute != null
                                      ? Column(
                                          children: [
                                            SelectionWidget(
                                              selectedAttribute1:
                                                  attribute.name!,
                                              selecteOptions: attribute.options,
                                              onOptionSelected:
                                                  _onOptionSelected,
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        )
                                      : const SizedBox.shrink();
                                }),
                              ),
                              SelectQuantityWidget(
                                productID:
                                    productProvider.productByID!.id.toString(),
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: !_showBottomButton,
                                child: AddToCartButton(
                                  productName:
                                      productProvider.productByID!.name!,
                                  productPrice: (productProvider
                                          .productByID!.onSale!)
                                      ? productProvider.productByID!.salePrice!
                                      : productProvider
                                          .productByID!.regularPrice!,
                                  productID: widget.productID,
                                  productImgUrl: productProvider
                                      .productByID!.images.first.src!,
                                  vendorID:
                                      productProvider.productByID!.store!.id!,
                                  vendorName: productProvider
                                      .productByID!.store!.shopName!,
                                  attributes:
                                      productProvider.productByID!.attributes,
                                  selectedAttributes: _selectedAttributes,
                                  quantity: quantityProvider.getQuantity(widget
                                      .productID
                                      .toString()), // Pass the quantity
                                  index: widget.index,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: w,
                                height: 43, //modified
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RoutesName.shopScreen,
                                        arguments: {
                                          "index": widget.index,
                                          "vendorId": int.tryParse(
                                              productProvider
                                                  .productByID!.store!.id
                                                  .toString()),
                                        });
                                    print(
                                        "checkinngggggggggggg ${productProvider.productByID!.store!.id}");
                                  },
                                  child: const Text("View Shop"),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Free shipping over Rs. 500",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Reviews',
                                    style: AppStyles.semiBoldText
                                        .copyWith(fontSize: 16),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        //Toggle
                                        setState(() {
                                          _showReviews = !_showReviews;
                                        });
                                      },
                                      child: _showReviews
                                          ? const Icon(
                                              Icons.keyboard_arrow_up_rounded)
                                          : const Icon(Icons
                                              .keyboard_arrow_down_rounded))
                                ],
                              ),
                              Visibility(
                                visible: _showReviews,
                                maintainState: true,
                                maintainSize: false,
                                child: Column(
                                  children: [
                                    Column(
                                      children: sortedReviews.isEmpty
                                          ? [
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: Text(
                                                  "No reviews available",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              ),
                                            ]
                                          : List.generate(sortedReviews.length,
                                              (index) {
                                              final ReviewModel review =
                                                  sortedReviews[index];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 4),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          review.name ??
                                                              'Anonymous', // Handling null values safe
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .primary,
                                                          ),
                                                        ),
                                                        TimeAgoWidget(
                                                            dateCreated: review
                                                                .dateCreated!)
                                                      ],
                                                    ),
                                                    Text(review.review ??
                                                        'No review provided.'),
                                                    const Divider(
                                                      color: Color.fromARGB(
                                                          100, 158, 158, 158),
                                                    ), // Handling null values safely
                                                  ],
                                                ),
                                                //  DropdownButtonHideUnderline(
                                                //                                   child: DropdownButton<String>(
                                                //                                     style: const TextStyle(
                                                //                                         fontSize: 14, color: Colors.black),
                                                //                                     value: _selectedSortOption,
                                                //                                     icon: const Icon(Icons.arrow_drop_down),
                                                //                                     onChanged: (String? newValue) {
                                                //                                       setState(() {
                                                //                                         _selectedSortOption = newValue!;
                                                //                                       });
                                                //                                     },
                                                //                                     items: sortOptions
                                                //                                         .map<DropdownMenuItem<String>>(
                                                //                                             (String value) {
                                                //                                       return DropdownMenuItem<String>(
                                                //                                         value: value,
                                                //                                         child: Text(value),
                                                //                                       );
                                                //                                     }).toList(),
                                                //                                   ),
                                                //                                 ),
                                              );
                                            }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4),
                                      child: TextField(
                                        controller:
                                            _reviewTextController, // Text Controller to handle review input
                                        decoration: const InputDecoration(
                                          hintText: "Your Review...",
                                          hintStyle: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 119, 119, 119)),
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.5)),
                                        ),
                                        maxLines: 3,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.black87,
                                      ),
                                      onPressed: () {
                                        _addReview();
                                      },
                                      child: Text(
                                          writeReviewViewModel.isLoading
                                              ? "Wait..."
                                              : "Save",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              const TrailingDropdownWidget(
                                label: "Shipping",
                                content:
                                    "Kindly contact the vendor or report an error from the profile page.",
                              ),
                              const TrailingDropdownWidget(
                                label: "Returns",
                                content:
                                    "Please follow our return policy before returning.",
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Visibility(
            visible: _showBottomButton,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                  child: AddToCartButton(
                    productName: productProvider.productByID!.name!,
                    productPrice: (productProvider.productByID!.onSale!)
                        ? productProvider.productByID!.salePrice!
                        : productProvider.productByID!.regularPrice!,
                    productID: widget.productID,
                    productImgUrl:
                        productProvider.productByID!.images.first.src!,
                    vendorID: 555,
                    vendorName: productProvider.productByID!.store!.shopName!,
                    attributes: productProvider.productByID!.attributes,
                    selectedAttributes: _selectedAttributes,
                    quantity: quantityProvider.getQuantity(
                        widget.productID.toString()), // Pass the quantity
                    index: widget.index,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
