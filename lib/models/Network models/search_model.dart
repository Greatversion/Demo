class SearchModel {
  List<String>? brands;
   List<String>? categories;
  Price? price;

  SearchModel({
      this.brands,
      this.categories,
     this.price,
  });

  // From JSON constructor
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      brands: List<String>.from(json['brands']),
      categories: List<String>.from(json['category']),
      price: Price.fromJson(json['price']),
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'brands': brands,
      'category': categories,
      'price': price!.toJson(),
    };
  }
}

class Price {
  String min;
  String max;

  Price({
    required this.min,
    required this.max,
  });

  // From JSON constructor
  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      min: json['min'],
      max: json['max'],
    );
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    return {
      'min': min,
      'max': max,
    };
  }
}