class Vendors {
  Vendors({
    required this.id,
    required this.storeName,
    required this.firstName,
    required this.lastName,
    required this.social,
    required this.showEmail,
    required this.address,
    required this.location,
    required this.banner,
    required this.bannerId,
    required this.gravatar,
    required this.gravatarId,
    required this.shopUrl,
    required this.tocEnabled,
    required this.storeToc,
    required this.featured,
    required this.rating,
    required this.enabled,
    required this.registered,
    required this.payment,
    required this.trusted,
    required this.saleOnlyHere,
    required this.companyName,
    required this.vatNumber,
    required this.companyIdNumber,
    required this.bankName,
    required this.bankIban,
    required this.links,
  });

  final int? id;
  final String? storeName;
  final String? firstName;
  final String? lastName;
  final dynamic social;
  final bool? showEmail;
  final dynamic address;
  final String? location;
  final String? banner;
  final int? bannerId;
  final String? gravatar;
  final int? gravatarId;
  final String? shopUrl;
  final bool? tocEnabled;
  final String? storeToc;
  final bool? featured;
  final Rating? rating;
  final bool? enabled;
  final DateTime? registered;
  final String? payment;
  final bool? trusted;
  final bool? saleOnlyHere;
  final String? companyName;
  final String? vatNumber;
  final String? companyIdNumber;
  final String? bankName;
  final String? bankIban;
  final Links? links;

  factory Vendors.fromJson(Map<String, dynamic> json) {
    return Vendors(
      id: json["id"],
      storeName: json["store_name"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      social: json["social"],
      showEmail: json["show_email"],
      address: json["address"],
      location: json["location"],
      banner: json["banner"],
      bannerId: json["banner_id"],
      gravatar: json["gravatar"],
      gravatarId: json["gravatar_id"],
      shopUrl: json["shop_url"],
      tocEnabled: json["toc_enabled"],
      storeToc: json["store_toc"],
      featured: json["featured"],
      rating: json["rating"] == null ? null : Rating.fromJson(json["rating"]),
      enabled: json["enabled"],
      registered: DateTime.tryParse(json["registered"] ?? ""),
      payment: json["payment"],
      trusted: json["trusted"],
      saleOnlyHere: json["sale_only_here"],
      companyName: json["company_name"],
      vatNumber: json["vat_number"],
      companyIdNumber: json["company_id_number"],
      bankName: json["bank_name"],
      bankIban: json["bank_iban"],
      links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "first_name": firstName,
        "last_name": lastName,
        "social": social,
        "show_email": showEmail,
        "address": address,
        "location": location,
        "banner": banner,
        "banner_id": bannerId,
        "gravatar": gravatar,
        "gravatar_id": gravatarId,
        "shop_url": shopUrl,
        "toc_enabled": tocEnabled,
        "store_toc": storeToc,
        "featured": featured,
        "rating": rating?.toJson(),
        "enabled": enabled,
        "registered": registered?.toIso8601String(),
        "payment": payment,
        "trusted": trusted,
        "sale_only_here": saleOnlyHere,
        "company_name": companyName,
        "vat_number": vatNumber,
        "company_id_number": companyIdNumber,
        "bank_name": bankName,
        "bank_iban": bankIban,
        "_links": links?.toJson(),
      };
}

class AddressClass {
  AddressClass({
    required this.street1,
    required this.street2,
    required this.city,
    required this.zip,
    required this.state,
    required this.country,
    required this.locationName,
  });

  final String? street1;
  final String? street2;
  final String? city;
  final String? zip;
  final String? state;
  final String? country;
  final String? locationName;

  factory AddressClass.fromJson(Map<String, dynamic> json) {
    return AddressClass(
      street1: json["street_1"],
      street2: json["street_2"],
      city: json["city"],
      zip: json["zip"],
      state: json["state"],
      country: json["country"],
      locationName: json["location_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "street_1": street1,
        "street_2": street2,
        "city": city,
        "zip": zip,
        "state": state,
        "country": country,
        "location_name": locationName,
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

class Rating {
  Rating({
    required this.rating,
    required this.count,
  });

  final String? rating;
  final num? count;

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rating: json["rating"],
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "count": count,
      };
}

class SocialClass {
  SocialClass({
    required this.fb,
    required this.youtube,
    required this.twitter,
    required this.linkedin,
    required this.pinterest,
    required this.instagram,
    required this.flickr,
    required this.threads,
  });

  final String? fb;
  final String? youtube;
  final String? twitter;
  final String? linkedin;
  final String? pinterest;
  final String? instagram;
  final String? flickr;
  final String? threads;

  factory SocialClass.fromJson(Map<String, dynamic> json) {
    return SocialClass(
      fb: json["fb"],
      youtube: json["youtube"],
      twitter: json["twitter"],
      linkedin: json["linkedin"],
      pinterest: json["pinterest"],
      instagram: json["instagram"],
      flickr: json["flickr"],
      threads: json["threads"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fb": fb,
        "youtube": youtube,
        "twitter": twitter,
        "linkedin": linkedin,
        "pinterest": pinterest,
        "instagram": instagram,
        "flickr": flickr,
        "threads": threads,
      };
}
