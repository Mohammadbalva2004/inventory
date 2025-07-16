class Category {
  String? status;
  String? createdAt;
  String? updatedAt;
  String? id;
  String? categoryName;
  String? description;
  Null? parentCategoryId;
  String? organizationId;

  Category({
    this.status,
    this.createdAt,
    this.updatedAt,
    this.id,
    this.categoryName,
    this.description,
    this.parentCategoryId,
    this.organizationId,
  });

  Category.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
    categoryName = json['categoryName'];
    description = json['description'];
    parentCategoryId = json['parentCategoryId'];
    organizationId = json['organizationId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    data['description'] = this.description;
    data['parentCategoryId'] = this.parentCategoryId;
    data['organizationId'] = this.organizationId;
    return data;
  }
}
