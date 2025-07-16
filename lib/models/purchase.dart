class Purchase {
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final String? purchaseId;
  final String? productId;
  final String? supplierId;
  final String? billImage;
  final String? paymentImage;
  final int? totalAmount;
  final int? paidAmount;
  final String? paymentType;
  final String? description;

  Purchase({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.purchaseId,
    this.productId,
    this.supplierId,
    this.billImage,
    this.paymentImage,
    this.totalAmount,
    this.paidAmount,
    this.paymentType,
    this.description,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
      status: json['status']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      purchaseId: json['purchaseId']?.toString(),
      productId: json['productId']?.toString(),
      supplierId: json['supplierId']?.toString(),
      billImage: json['billImage']?.toString(),
      paymentImage: json['paymentImage']?.toString(),
      totalAmount:
          json['totalAmount'] is int
              ? json['totalAmount']
              : int.tryParse(json['totalAmount']?.toString() ?? ''),
      paidAmount:
          json['paidAmount'] is int
              ? json['paidAmount']
              : int.tryParse(json['paidAmount']?.toString() ?? ''),
      paymentType: json['paymentType']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'purchaseId': purchaseId,
      'productId': productId,
      'supplierId': supplierId,
      'billImage': billImage,
      'paymentImage': paymentImage,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'paymentType': paymentType,
      'description': description,
    };
  }
}
