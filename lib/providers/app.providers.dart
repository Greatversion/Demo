// ignore_for_file: no_wildcard_variable_uses

import 'package:mambo/providers/explore_action_provider.dart';
import 'package:mambo/providers/nav_bar_provider.dart';
import 'package:mambo/providers/online_connectivity_provider.dart';
import 'package:mambo/providers/quantity_provider.dart';
import 'package:mambo/providers/reel_gesture_action_provider.dart';
import 'package:mambo/providers/selected_address_provider.dart';
import 'package:mambo/providers/wishlist_action_provider.dart';
import 'package:mambo/view%20models/address_view_model.dart';
import 'package:mambo/view%20models/cart_view_model.dart';
import 'package:mambo/view%20models/category_view_model.dart';
import 'package:mambo/view%20models/order_view_model.dart';
import 'package:mambo/services/Payment%20Functions/payment_view_model.dart';
import 'package:mambo/view%20models/product_filter_view_model.dart';
import 'package:mambo/view%20models/product_view_model.dart';
import 'package:mambo/view%20models/return_request_view_model.dart';
import 'package:mambo/view%20models/review_view_model.dart';
import 'package:mambo/view%20models/search_view_model.dart';
import 'package:mambo/view%20models/user_profile_view_modal.dart';
import 'package:mambo/view%20models/vendor_view_model.dart';
import 'package:mambo/view%20models/wishlist_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../view models/auth_view_model.dart';

/// `AppProviders` is a class that provides a list of all the `ChangeNotifierProvider` instances used in the app.
/// These providers manage the state and business logic across various parts of the application.
class AppProviders {
  /// A static list of providers for dependency injection using the Provider package.
  static List<SingleChildWidget> providers = [
    // Authentication provider for managing user authentication state
    ChangeNotifierProvider<AuthenticationProvider>(
        create: (_) => AuthenticationProvider()),

    // Providers for managing product-related state
    ChangeNotifierProvider<ProductProvider>(create: (_) => ProductProvider()),
    ChangeNotifierProvider<VendorProvider>(create: (_) => VendorProvider()),
    ChangeNotifierProvider<CategoryProvider>(create: (_) => CategoryProvider()),
    ChangeNotifierProvider<CategoriesViewModel>(
        create: (context) => CategoriesViewModel(context)),
    ChangeNotifierProvider<BrandsViewModel>(
        create: (context) => BrandsViewModel(context)),

    // Providers for managing navigation and exploration actions
    ChangeNotifierProvider<NavBarProvider>(create: (_) => NavBarProvider()),
    ChangeNotifierProvider<ExploreactionProvider>(
        create: (_) => ExploreactionProvider()),

    // Providers for managing search, wishlist, cart, and quantity-related state
    ChangeNotifierProvider<SearchProvider>(create: (_) => SearchProvider()),
    ChangeNotifierProvider<WishlistViewModel>(
        create: (_) => WishlistViewModel()),
    ChangeNotifierProvider<CartViewModel>(create: (_) => CartViewModel()),
    ChangeNotifierProvider<WishlistactionProvider>(
        create: (_) => WishlistactionProvider()),
    ChangeNotifierProvider<QuantityProvider>(create: (_) => QuantityProvider()),

    // Providers for managing gesture actions and reviews
    ChangeNotifierProvider<ReelGestureActionProvider>(
        create: (_) => ReelGestureActionProvider()),
    ChangeNotifierProvider<WriteReviewViewModel>(
        create: (_) => WriteReviewViewModel()),

    // Providers for managing addresses, orders, payments, and return requests
    ChangeNotifierProvider<AddressViewModel>(create: (_) => AddressViewModel()),
    ChangeNotifierProvider<OrderViewModel>(create: (_) => OrderViewModel()),
    ChangeNotifierProvider<SelectedAddressProvider>(
        create: (_) => SelectedAddressProvider()),
    ChangeNotifierProvider<PaymentViewModel>(create: (_) => PaymentViewModel()),
    ChangeNotifierProvider<ReturnRequestViewModel>(
        create: (_) => ReturnRequestViewModel()),

    // Provider for managing online connectivity state
    ChangeNotifierProvider<ConnectivityService>(
        create: (_) => ConnectivityService()),

    // Providers for managing product filters
    ChangeNotifierProvider<ProductFilterViewModel>(
        create: (_) => ProductFilterViewModel()),

    // Note: Duplicate provider for `ProductFilterViewModel`. This should be removed or corrected.
    ChangeNotifierProvider<ProductFilterViewModel>(
        create: (_) => ProductFilterViewModel()),

    // Providers for User Profile Provider
    ChangeNotifierProvider<UserProfileProvider>(
        create: (_) => UserProfileProvider()),
  ];
}
