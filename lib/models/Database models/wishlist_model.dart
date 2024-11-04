import 'package:cloud_firestore/cloud_firestore.dart';

class WishListModel {
  WishListModel({
    required this.vendor,
    required this.product,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.createdAt,
  });

  final Vendor? vendor;
  final Product? product;
  final String? price;
  final String? category;
  final String? imageUrl;
  final DateTime? createdAt;

  factory WishListModel.fromJson(Map<String, dynamic> json) {
    return WishListModel(
      vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      price: json["price"],
      category: json["category"],
      imageUrl: json["image_url"],
      createdAt: (json["created_at"] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        "vendor": vendor?.toJson(),
        "product": product?.toJson(),
        "price": price,
        "category": category,
        "image_url": imageUrl,
        "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      };
}

class Product {
  Product({
    required this.productId,
    required this.productName,
  });

  final int? productId;
  final String? productName;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["product_id"],
      productName: json["product_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_name": productName,
      };
}

class Vendor {
  Vendor({
    required this.vendorId,
    required this.vendorName,
    required this.vendorStore,
  });

  final int? vendorId;
  final String? vendorName;
  final String? vendorStore;

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json["vendor_id"],
      vendorName: json["vendor_name"],
      vendorStore: json["vendor_store"],
    );
  }

  Map<String, dynamic> toJson() => {
        "vendor_id": vendorId,
        "vendor_name": vendorName,
        "vendor_store": vendorStore,
      };
}
