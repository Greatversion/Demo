class ReviewModel {
    ReviewModel({
        required this.id,
        required this.dateCreated,
        required this.dateCreatedGmt,
        required this.review,
        required this.rating,
        required this.name,
        required this.email,
        required this.verified,
        required this.links,
    });

    final int? id;
    final DateTime? dateCreated;
    final DateTime? dateCreatedGmt;
    final String? review;
    final int? rating;
    final String? name;
    final String? email;
    final bool? verified;
    final Links? links;

    factory ReviewModel.fromJson(Map<String, dynamic> json){ 
        return ReviewModel(
            id: json["id"],
            dateCreated: DateTime.tryParse(json["date_created"] ?? ""),
            dateCreatedGmt: DateTime.tryParse(json["date_created_gmt"] ?? ""),
            review: json["review"],
            rating: json["rating"],
            name: json["name"],
            email: json["email"],
            verified: json["verified"],
            links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
        "date_created_gmt": dateCreatedGmt?.toIso8601String(),
        "review": review,
        "rating": rating,
        "name": name,
        "email": email,
        "verified": verified,
        "_links": links?.toJson(),
    };

}

class Links {
    Links({
        required this.self,
        required this.collection,
        required this.up,
    });

    final List<Collection> self;
    final List<Collection> collection;
    final List<Collection> up;

    factory Links.fromJson(Map<String, dynamic> json){ 
        return Links(
            self: json["self"] == null ? [] : List<Collection>.from(json["self"]!.map((x) => Collection.fromJson(x))),
            collection: json["collection"] == null ? [] : List<Collection>.from(json["collection"]!.map((x) => Collection.fromJson(x))),
            up: json["up"] == null ? [] : List<Collection>.from(json["up"]!.map((x) => Collection.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "self": self.map((x) => x.toJson()).toList(),
        "collection": collection.map((x) => x.toJson()).toList(),
        "up": up.map((x) => x.toJson()).toList(),
    };

}

class Collection {
    Collection({
        required this.href,
    });

    final String? href;

    factory Collection.fromJson(Map<String, dynamic> json){ 
        return Collection(
            href: json["href"],
        );
    }

    Map<String, dynamic> toJson() => {
        "href": href,
    };

}
