import 'package:mambo/models/Network%20models/product_model.dart';

class ProductCartModel {
  final String productName;
  final String productPrice;
  final int productID;
  final String productImgUrl;
  final int vendorID;
   int quantity;
  final String vendorName;
  final List<Attribute> attributes;
   Map<String, String> selectedAttributes; // Add this field

  ProductCartModel({
    required this.productName,
    required this.productPrice,
    required this.productID,
    required this.quantity,
    required this.productImgUrl,
    required this.vendorID,
    required this.vendorName,
    required this.attributes,
    required this.selectedAttributes, // Add this parameter
  });

  factory ProductCartModel.fromJson(Map<String, dynamic> json) {
    var attributesFromJson = json['attributes'] as List;
    List<Attribute> attributesList =
        attributesFromJson.map((attr) => Attribute.fromJson(attr)).toList();
    var selectedAttributesFromJson = Map<String, String>.from(json['selectedAttributes']);

    return ProductCartModel(
      quantity: json['quantity'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      attributes: attributesList,
      productID: json['productID'],
      productImgUrl: json['productImgUrl'],
      vendorID: json['vendorID'],
      vendorName: json['vendorName'],
      selectedAttributes: selectedAttributesFromJson, // Add this parameter
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName': productName,
      'productPrice': productPrice,
      'attributes': attributes.map((attr) => attr.toJson()).toList(),
      'productID': productID,
      'quantity': quantity,
      'productImgUrl': productImgUrl,
      'vendorID': vendorID,
      'vendorName': vendorName,
      'selectedAttributes': selectedAttributes, // Add this parameter
    };
  }
}
