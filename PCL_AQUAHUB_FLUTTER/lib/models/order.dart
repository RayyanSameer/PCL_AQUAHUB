class Order {
  final String id;
  final String orderType;
  final int? quantity;
  final double? price;
  final String status;
  final String? firstName;
  final String? lastName;
  final String? phone;

  Order({required this.id, required this.orderType, this.quantity, this.price, required this.status, this.firstName, this.lastName, this.phone});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      orderType: json['order_type']?.toString() ?? json['orderType']?.toString() ?? '',
      quantity: json['quantity'] != null ? int.tryParse(json['quantity'].toString()) : null,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      status: json['status']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? json['firstName']?.toString(),
      lastName: json['last_name']?.toString() ?? json['lastName']?.toString(),
      phone: json['phone']?.toString(),
    );
  }
}
