class OrderModel {
    OrderModel( {
     required this.paymentID, 
    required this.orderID,
        required this.paymentMethod,
        required this.paymentMethodTitle,
        required this.setPaid,
        required this.billing,
        required this.shipping,
        required this.lineItems,
        required this.shippingLines,
        required this.orderTime,
        
    });

    final String? paymentMethod;
    final String? paymentMethodTitle;
    final bool? setPaid;
    final String? paymentID;
    final String? orderID;
    final Ing? billing;
    final Ing? shipping;
    final List<LineItem> lineItems;
    final List<ShippingLine> shippingLines;
    final DateTime orderTime;

    factory OrderModel.fromJson(Map<String, dynamic> json){ 
        return OrderModel(
            paymentID: json["payment_ID"],
            orderID: json["order_ID"],
            paymentMethod: json["payment_method"],
            paymentMethodTitle: json["payment_method_title"],
            setPaid: json["set_paid"],
            billing: json["billing"] == null ? null : Ing.fromJson(json["billing"]),
            shipping: json["shipping"] == null ? null : Ing.fromJson(json["shipping"]),
            lineItems: json["line_items"] == null ? [] : List<LineItem>.from(json["line_items"]!.map((x) => LineItem.fromJson(x))),
            shippingLines: json["shipping_lines"] == null ? [] : List<ShippingLine>.from(json["shipping_lines"]!.map((x) => ShippingLine.fromJson(x))),
             orderTime: json['orderTime'],
        );
    }

    Map<String, dynamic> toJson() => {
        "payment_method": paymentMethod,
        "payment_ID": paymentID,
        "order_ID": orderID,
        "payment_method_title": paymentMethodTitle,
        "set_paid": setPaid,
        "billing": billing?.toJson(),
        "shipping": shipping?.toJson(),
        "line_items": lineItems.map((x) => x.toJson()).toList(),
        "shipping_lines": shippingLines.map((x) => x.toJson()).toList(),
        "orderTime":orderTime.toUtc()
    };

}

class Ing {
    Ing({
        required this.firstName,
        required this.lastName,
        required this.address1,
        required this.address2,
        required this.city,
        required this.state,
        required this.postcode,
        required this.country,
        required this.email,
        required this.phone,
    });

    final String? firstName;
    final String? lastName;
    final String? address1;
    final String? address2;
    final String? city;
    final String? state;
    final String? postcode;
    final String? country;
    final String? email;
    final String? phone;

    factory Ing.fromJson(Map<String, dynamic> json){ 
        return Ing(
            firstName: json["first_name"],
            lastName: json["last_name"],
            address1: json["address_1"],
            address2: json["address_2"],
            city: json["city"],
            state: json["state"],
            postcode: json["postcode"],
            country: json["country"],
            email: json["email"],
            phone: json["phone"],
        );
    }

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "address_2": address2,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "email": email,
        "phone": phone,
    };

}

class LineItem {
    LineItem({
        required this.productId,
        required this.quantity,
        required this.variationId,
    });

    final int? productId;
    final int? quantity;
    final int? variationId;

    factory LineItem.fromJson(Map<String, dynamic> json){ 
        return LineItem(
            productId: json["product_id"],
            quantity: json["quantity"],
            variationId: json["variation_id"],
        );
    }

    Map<String, dynamic> toJson() => {
        "product_id": productId,
        "quantity": quantity,
        "variation_id": variationId,
    };

}

class ShippingLine {
    ShippingLine({
        required this.methodId,
        required this.methodTitle,
        required this.total,
    });

    final String? methodId;
    final String? methodTitle;
    final String? total;

    factory ShippingLine.fromJson(Map<String, dynamic> json){ 
        return ShippingLine(
            methodId: json["method_id"],
            methodTitle: json["method_title"],
            total: json["total"],
        );
    }

    Map<String, dynamic> toJson() => {
        "method_id": methodId,
        "method_title": methodTitle,
        "total": total,
    };

}
