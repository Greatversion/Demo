

// product_view_model.dart

import 'package:flutter/foundation.dart';
import 'package:mambo/services/Network%20Functions/review_services.dart';

/// [WriteReviewViewModel] manages the state and logic for adding reviews.
/// It interacts with the [ReviewService] to submit reviews and track the loading state.
class WriteReviewViewModel extends ChangeNotifier {
  final ReviewService reviewService = ReviewService(); // Service for handling review operations.
  List<WriteReviewModel> reviews = []; // List to store reviews (if needed for other operations).
  bool _isLoading = false; // Indicates whether a loading operation is in progress.
  bool _success = false; // Indicates whether the review submission was successful.

  /// Returns whether a loading operation is in progress.
  bool get isLoading => _isLoading;

  /// Method to add a review.
  ///
  /// [review] - The review to be added, encapsulated in a [WriteReviewModel].
  /// Returns true if the review was successfully submitted, otherwise false.
  Future<bool> addReview(WriteReviewModel review) async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that loading has started.

    try {
      // Call the service to add the review and parse the response.
      _success = await reviewService.addReview(
        int.parse(review.productId),
        review.review,
        review.reviewerName,
        review.reviewerEmail,
      );
    } catch (e) {
      debugPrint(e.toString()); // Log any errors encountered during review submission.
    } finally {
      _isLoading = false;
      // Update success status after attempting to add the review.
      _success = _success;
      notifyListeners(); // Notify listeners that loading has finished and data has changed.
    }
    return _success; // Return whether the review submission was successful.
  }
}

/// [WriteReviewModel] represents a review to be submitted.
/// It contains the necessary fields for a review and methods for JSON serialization.
class WriteReviewModel {
  final String productId; // Unique identifier for the product being reviewed.
  final String reviewerName; // Name of the person who wrote the review.
  final String reviewerEmail; // Email of the person who wrote the review.
  final String review; // The actual review text.

  /// Constructor for creating a [WriteReviewModel].
  WriteReviewModel({
    required this.productId,
    required this.reviewerName,
    required this.reviewerEmail,
    required this.review,
  });

  /// Factory method to create a [WriteReviewModel] from a Map.
  /// Useful for JSON deserialization.
  factory WriteReviewModel.fromMap(Map<String, dynamic> map) {
    return WriteReviewModel(
      productId: map['productId'] ?? '',
      reviewerName: map['reviewerName'] ?? '',
      review: map['review'] ?? '',
      reviewerEmail: map['reviewer_email'] ?? '',
    );
  }

  /// Convert the [WriteReviewModel] to a Map.
  /// Useful for JSON serialization.
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'reviewerName': reviewerName,
      'review': review,
      'reviewerEmail': reviewerEmail,
    };
  }
}
