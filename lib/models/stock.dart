class Stock {
  final String id;
  final String productName;
  final String category;
  final String warehouse;
  final int quantity;
  final double price;
  final String status;
  final String lastUpdated;

  Stock({
    required this.id,
    required this.productName,
    required this.category,
    required this.warehouse,
    required this.quantity,
    required this.price,
    required this.status,
    required this.lastUpdated,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['id']?.toString() ?? '',
      productName: json['productName'] ?? '',
      category: json['category'] ?? '',
      warehouse: json['warehouse'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      status: json['status'] ?? '',
      lastUpdated: json['lastUpdated'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'category': category,
      'warehouse': warehouse,
      'quantity': quantity,
      'price': price,
      'status': status,
      'lastUpdated': lastUpdated,
    };
  }
}
