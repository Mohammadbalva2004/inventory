class Supplier {
  String? status;
  String? createdAt;
  String? updatedAt;
  String? supplierId;
  String? supplierShopName;
  String? phoneNumber;
  String? supplierGstNo;
  String? locationOrArea;

  Supplier({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.supplierId,
    this.supplierShopName,
    this.phoneNumber,
    this.supplierGstNo,
    this.locationOrArea,
  });

  Supplier.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    supplierId = json['supplierId'];
    supplierShopName = json['supplierShopName'];
    phoneNumber = json['phoneNumber'];
    supplierGstNo = json['supplierGstNo'];
    locationOrArea = json['locationOrArea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['supplierId'] = this.supplierId;
    data['supplierShopName'] = this.supplierShopName;
    data['phoneNumber'] = this.phoneNumber;
    data['supplierGstNo'] = this.supplierGstNo;
    data['locationOrArea'] = this.locationOrArea;
    return data;
  }
}
