class Product {
  String id;
  String name;
  String description;
  double price;
  int stock;
  String category;
  List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.images,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      stock: data['stock'],
      category: data['category'],
      images: List<String>.from(data['images']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'images': images,
    };
  }
}
