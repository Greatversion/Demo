// ignore_for_file: unnecessary_question_mark

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.type,
    required this.status,
    required this.featured,
    required this.catalogVisibility,
    required this.description,
    required this.shortDescription,
    required this.sku,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.dateOnSaleFrom,
    required this.dateOnSaleFromGmt,
    required this.dateOnSaleTo,
    required this.dateOnSaleToGmt,
    required this.onSale,
    required this.purchasable,
    required this.totalSales,
    required this.virtual,
    required this.downloadable,
    required this.downloads,
    required this.downloadLimit,
    required this.downloadExpiry,
    required this.externalUrl,
    required this.buttonText,
    required this.taxStatus,
    required this.taxClass,
    required this.manageStock,
    required this.stockQuantity,
    required this.backorders,
    required this.backordersAllowed,
    required this.backordered,
    required this.lowStockAmount,
    required this.soldIndividually,
    required this.weight,
    required this.dimensions,
    required this.shippingRequired,
    required this.shippingTaxable,
    required this.shippingClass,
    required this.shippingClassId,
    required this.reviewsAllowed,
    required this.averageRating,
    required this.ratingCount,
    required this.upsellIds,
    required this.crossSellIds,
    required this.parentId,
    required this.purchaseNote,
    required this.categories,
    required this.tags,
    required this.images,
    required this.attributes,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.priceHtml,
    required this.relatedIds,
    required this.metaData,
    required this.stockStatus,
    required this.hasOptions,
    required this.postPassword,
    required this.globalUniqueId,
    required this.jetpackPublicizeConnections,
    required this.jetpackSharingEnabled,
    required this.jetpackLikesEnabled,
    required this.store,
    required this.links,
  });

  final int? id;
  final String? name;
  final String? slug;
  final String? permalink;
  final DateTime? dateCreated;
  final DateTime? dateCreatedGmt;
  final DateTime? dateModified;
  final DateTime? dateModifiedGmt;
  final String? type;
  final String? status;
  final bool? featured;
  final String? catalogVisibility;
  final String? description;
  final String? shortDescription;
  final String? sku;
  final String? price;
  final String? regularPrice;
  final String? salePrice;
  final dynamic dateOnSaleFrom;
  final dynamic dateOnSaleFromGmt;
  final dynamic dateOnSaleTo;
  final dynamic dateOnSaleToGmt;
  final bool? onSale;
  final bool? purchasable;
  final int? totalSales;
  final bool? virtual;
  final bool? downloadable;
  final List<dynamic> downloads;
  final int? downloadLimit;
  final int? downloadExpiry;
  final String? externalUrl;
  final String? buttonText;
  final String? taxStatus;
  final String? taxClass;
  final bool? manageStock;
  final int? stockQuantity;
  final String? backorders;
  final bool? backordersAllowed;
  final bool? backordered;
  final int? lowStockAmount;
  final bool? soldIndividually;
  final String? weight;
  final Dimensions? dimensions;
  final bool? shippingRequired;
  final bool? shippingTaxable;
  final String? shippingClass;
  final int? shippingClassId;
  final bool? reviewsAllowed;
  final String? averageRating;
  final int? ratingCount;
  final List<dynamic> upsellIds;
  final List<dynamic> crossSellIds;
  final int? parentId;
  final String? purchaseNote;
  final List<Category> categories;
  final List<Category> tags;
  final List<Image> images;
  final List<Attribute> attributes;
  final List<dynamic> defaultAttributes;
  final List<dynamic> variations;
  final List<dynamic> groupedProducts;
  final int? menuOrder;
  final String? priceHtml;
  final List<int> relatedIds;
  final List<MetaDatum> metaData;
  final String? stockStatus;
  final bool? hasOptions;
  final String? postPassword;
  final String? globalUniqueId;
  final List<dynamic> jetpackPublicizeConnections;
  final bool? jetpackSharingEnabled;
  final bool? jetpackLikesEnabled;
  final Store? store;
  final Links? links;
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"],
      slug: json["slug"],
      permalink: json["permalink"],
      dateCreated: DateTime.tryParse(json["date_created"] ?? ""),
      dateCreatedGmt: DateTime.tryParse(json["date_created_gmt"] ?? ""),
      dateModified: DateTime.tryParse(json["date_modified"] ?? ""),
      dateModifiedGmt: DateTime.tryParse(json["date_modified_gmt"] ?? ""),
      type: json["type"],
      status: json["status"],
      featured: json["featured"] == true, // Ensuring it's a boolean
      catalogVisibility: json["catalog_visibility"],
      description: json["description"],
      shortDescription: json["short_description"],
      sku: json["sku"],
      price: json["price"]?.toString(), // Convert to String
      regularPrice: json["regular_price"]?.toString(),
      salePrice: json["sale_price"]?.toString(),
      dateOnSaleFrom: json["date_on_sale_from"],
      dateOnSaleFromGmt: json["date_on_sale_from_gmt"],
      dateOnSaleTo: json["date_on_sale_to"],
      dateOnSaleToGmt: json["date_on_sale_to_gmt"],
      onSale: json["on_sale"] == true, // Ensuring it's a boolean
      purchasable: json["purchasable"] == true,
      totalSales: int.tryParse(json["total_sales"].toString()) ?? 0,
      virtual: json["virtual"] == true,
      downloadable: json["downloadable"] == true,
      downloads: json["downloads"] == null
          ? []
          : List<dynamic>.from(json["downloads"]!.map((x) => x)),
      downloadLimit: json["download_limit"] != null
          ? int.tryParse(json["download_limit"].toString()) ?? 0
          : 0,
      downloadExpiry: json["download_expiry"] != null
          ? int.tryParse(json["download_expiry"].toString()) ?? 0
          : 0,
      externalUrl: json["external_url"],
      buttonText: json["button_text"],
      taxStatus: json["tax_status"],
      taxClass: json["tax_class"],
      manageStock: json["manage_stock"] == true,
      stockQuantity: json["stock_quantity"] != null
          ? int.tryParse(json["stock_quantity"].toString())
          : null,
      backorders: json["backorders"],
      backordersAllowed: json["backorders_allowed"] == true,
      backordered: json["backordered"] == true,
      lowStockAmount: json["low_stock_amount"] != null
          ? int.tryParse(json["low_stock_amount"].toString())
          : null,
      soldIndividually: json["sold_individually"] == true,
      weight: json["weight"]?.toString(),
      dimensions: json["dimensions"] == null
          ? null
          : Dimensions.fromJson(json["dimensions"]),
      shippingRequired: json["shipping_required"] == true,
      shippingTaxable: json["shipping_taxable"] == true,
      shippingClass: json["shipping_class"],
      shippingClassId: json["shipping_class_id"] != null
          ? int.tryParse(json["shipping_class_id"].toString())
          : null,
      reviewsAllowed: json["reviews_allowed"] == true,
      averageRating: json["average_rating"] != null
          ? double.tryParse(json["average_rating"].toString())?.toString()
          : "0.0",
      ratingCount: int.tryParse(json["rating_count"].toString()) ?? 0,
      upsellIds: json["upsell_ids"] == null
          ? []
          : List<int>.from(
              json["upsell_ids"]!.map((x) => int.tryParse(x.toString()) ?? 0)),
      crossSellIds: json["cross_sell_ids"] == null
          ? []
          : List<int>.from(json["cross_sell_ids"]!
              .map((x) => int.tryParse(x.toString()) ?? 0)),
      parentId: int.tryParse(json["parent_id"].toString()) ?? 0,
      purchaseNote: json["purchase_note"],
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"]!.map((x) => Category.fromJson(x))),
      tags: json["tags"] == null
          ? []
          : List<Category>.from(json["tags"]!.map((x) => Category.fromJson(x))),
      images: json["images"] == null
          ? []
          : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      attributes: json["attributes"] == null
          ? []
          : List<Attribute>.from(
              json["attributes"]!.map((x) => Attribute.fromJson(x))),
      defaultAttributes: json["default_attributes"] == null
          ? []
          : List<dynamic>.from(json["default_attributes"]!.map((x) => x)),
      variations: json["variations"] == null
          ? []
          : List<dynamic>.from(json["variations"]!.map((x) => x)),
      groupedProducts: json["grouped_products"] == null
          ? []
          : List<dynamic>.from(json["grouped_products"]!.map((x) => x)),
      menuOrder: int.tryParse(json["menu_order"].toString()) ?? 0,
      priceHtml: json["price_html"],
      relatedIds: json["related_ids"] == null
          ? []
          : List<int>.from(
              json["related_ids"]!.map((x) => int.tryParse(x.toString()) ?? 0)),
      metaData: json["meta_data"] == null
          ? []
          : List<MetaDatum>.from(
              json["meta_data"]!.map((x) => MetaDatum.fromJson(x))),
      stockStatus: json["stock_status"],
      hasOptions: json["has_options"] == true,
      postPassword: json["post_password"],
      globalUniqueId: json["global_unique_id"],
      jetpackPublicizeConnections: json["jetpack_publicize_connections"] == null
          ? []
          : List<dynamic>.from(
              json["jetpack_publicize_connections"]!.map((x) => x)),
      jetpackSharingEnabled: json["jetpack_sharing_enabled"] == true,
      jetpackLikesEnabled: json["jetpack_likes_enabled"] == true,
      store: json["store"] == null ? null : Store.fromJson(json["store"]),
      links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "permalink": permalink,
        "date_created": dateCreated?.toIso8601String(),
        "date_created_gmt": dateCreatedGmt?.toIso8601String(),
        "date_modified": dateModified?.toIso8601String(),
        "date_modified_gmt": dateModifiedGmt?.toIso8601String(),
        "type": type,
        "status": status,
        "featured": featured,
        "catalog_visibility": catalogVisibility,
        "description": description,
        "short_description": shortDescription,
        "sku": sku,
        "price": price,
        "regular_price": regularPrice,
        "sale_price": salePrice,
        "date_on_sale_from": dateOnSaleFrom,
        "date_on_sale_from_gmt": dateOnSaleFromGmt,
        "date_on_sale_to": dateOnSaleTo,
        "date_on_sale_to_gmt": dateOnSaleToGmt,
        "on_sale": onSale,
        "purchasable": purchasable,
        "total_sales": totalSales,
        "virtual": virtual,
        "downloadable": downloadable,
        "downloads": downloads.map((x) => x).toList(),
        "download_limit": downloadLimit,
        "download_expiry": downloadExpiry,
        "external_url": externalUrl,
        "button_text": buttonText,
        "tax_status": taxStatus,
        "tax_class": taxClass,
        "manage_stock": manageStock,
        "stock_quantity": stockQuantity,
        "backorders": backorders,
        "backorders_allowed": backordersAllowed,
        "backordered": backordered,
        "low_stock_amount": lowStockAmount,
        "sold_individually": soldIndividually,
        "weight": weight,
        "dimensions": dimensions?.toJson(),
        "shipping_required": shippingRequired,
        "shipping_taxable": shippingTaxable,
        "shipping_class": shippingClass,
        "shipping_class_id": shippingClassId,
        "reviews_allowed": reviewsAllowed,
        "average_rating": averageRating,
        "rating_count": ratingCount,
        "upsell_ids": upsellIds.map((x) => x).toList(),
        "cross_sell_ids": crossSellIds.map((x) => x).toList(),
        "parent_id": parentId,
        "purchase_note": purchaseNote,
        "categories": categories.map((x) => x.toJson()).toList(),
        "tags": tags.map((x) => x.toJson()).toList(),
        "images": images.map((x) => x.toJson()).toList(),
        "attributes": attributes.map((x) => x.toJson()).toList(),
        "default_attributes": defaultAttributes.map((x) => x).toList(),
        "variations": variations.map((x) => x).toList(),
        "grouped_products": groupedProducts.map((x) => x).toList(),
        "menu_order": menuOrder,
        "price_html": priceHtml,
        "related_ids": relatedIds.map((x) => x).toList(),
        "meta_data": metaData.map((x) => x.toJson()).toList(),
        "stock_status": stockStatus,
        "has_options": hasOptions,
        "post_password": postPassword,
        "global_unique_id": globalUniqueId,
        "jetpack_publicize_connections":
            jetpackPublicizeConnections.map((x) => x).toList(),
        "jetpack_sharing_enabled": jetpackSharingEnabled,
        "jetpack_likes_enabled": jetpackLikesEnabled,
        "store": store?.toJson(),
        "_links": links?.toJson(),
      };
}

class Attribute {
  Attribute({
    required this.id,
    required this.name,
    required this.slug,
    required this.position,
    required this.visible,
    required this.variation,
    required this.options,
  });

  final int? id;
  final String? name;
  final String? slug;
  final int? position;
  final bool? visible;
  final bool? variation;
  final List<String> options;

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
      position: json["position"],
      visible: json["visible"],
      variation: json["variation"],
      options: json["options"] == null
          ? []
          : List<String>.from(json["options"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "position": position,
        "visible": visible,
        "variation": variation,
        "options": options.map((x) => x).toList(),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
  });

  final int? id;
  final String? name;
  final String? slug;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json["id"],
      name: json["name"],
      slug: json["slug"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

class Dimensions {
  Dimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  final String? length;
  final String? width;
  final String? height;

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      length: json["length"],
      width: json["width"],
      height: json["height"],
    );
  }

  Map<String, dynamic> toJson() => {
        "length": length,
        "width": width,
        "height": height,
      };
}

class Image {
  Image({
    required this.id,
    required this.dateCreated,
    required this.dateCreatedGmt,
    required this.dateModified,
    required this.dateModifiedGmt,
    required this.src,
    required this.name,
    required this.alt,
  });

  final int? id;
  final DateTime? dateCreated;
  final DateTime? dateCreatedGmt;
  final DateTime? dateModified;
  final DateTime? dateModifiedGmt;
  final String? src;
  final String? name;
  final String? alt;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      dateCreated: DateTime.tryParse(json["date_created"] ?? ""),
      dateCreatedGmt: DateTime.tryParse(json["date_created_gmt"] ?? ""),
      dateModified: DateTime.tryParse(json["date_modified"] ?? ""),
      dateModifiedGmt: DateTime.tryParse(json["date_modified_gmt"] ?? ""),
      src: json["src"],
      name: json["name"],
      alt: json["alt"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "date_created_gmt": dateCreatedGmt?.toIso8601String(),
        "date_modified": dateModified?.toIso8601String(),
        "date_modified_gmt": dateModifiedGmt?.toIso8601String(),
        "src": src,
        "name": name,
        "alt": alt,
      };
}

class Links {
  Links({
    required this.self,
    required this.collection,
  });

  final List<Collection> self;
  final List<Collection> collection;

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json["self"] == null
          ? []
          : List<Collection>.from(
              json["self"]!.map((x) => Collection.fromJson(x))),
      collection: json["collection"] == null
          ? []
          : List<Collection>.from(
              json["collection"]!.map((x) => Collection.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "self": self.map((x) => x.toJson()).toList(),
        "collection": collection.map((x) => x.toJson()).toList(),
      };
}

class Collection {
  Collection({
    required this.href,
  });

  final String? href;

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      href: json["href"],
    );
  }

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

class MetaDatum {
  MetaDatum({
    required this.id,
    required this.key,
    required this.value,
  });

  final int? id;
  final String? key;

  final dynamic? value;

  factory MetaDatum.fromJson(Map<String, dynamic> json) {
    return MetaDatum(
      id: json["id"],
      key: json["key"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
      };
}

class ValueClass {
  ValueClass({
    required this.keywords,
    required this.wordCount,
    required this.linkCount,
    required this.headingCount,
    required this.mediaCount,
  });

  final String? keywords;
  final String? wordCount;
  final String? linkCount;
  final String? headingCount;
  final String? mediaCount;

  factory ValueClass.fromJson(Map<String, dynamic> json) {
    return ValueClass(
      keywords: json["keywords"],
      wordCount: json["wordCount"],
      linkCount: json["linkCount"],
      headingCount: json["headingCount"],
      mediaCount: json["mediaCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "keywords": keywords,
        "wordCount": wordCount,
        "linkCount": linkCount,
        "headingCount": headingCount,
        "mediaCount": mediaCount,
      };
}

class Store {
  Store({
    required this.id,
    required this.name,
    required this.shopName,
    required this.url,
    required this.address,
  });

  final int? id;
  final String? name;
  final String? shopName;
  final String? url;
  final dynamic? address;

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json["id"],
      name: json["name"],
      shopName: json["shop_name"],
      url: json["url"],
      address: json["address"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "shop_name": shopName,
        "url": url,
        "address": address,
      };
}

class AddressClass {
  AddressClass({
    required this.locationName,
    required this.street1,
    required this.street2,
    required this.city,
    required this.zip,
    required this.state,
    required this.country,
  });

  final String? locationName;
  final String? street1;
  final String? street2;
  final String? city;
  final String? zip;
  final String? state;
  final String? country;

  factory AddressClass.fromJson(Map<String, dynamic> json) {
    return AddressClass(
      locationName: json["location_name"],
      street1: json["street_1"],
      street2: json["street_2"],
      city: json["city"],
      zip: json["zip"],
      state: json["state"],
      country: json["country"],
    );
  }

  Map<String, dynamic> toJson() => {
        "location_name": locationName,
        "street_1": street1,
        "street_2": street2,
        "city": city,
        "zip": zip,
        "state": state,
        "country": country,
      };
}
