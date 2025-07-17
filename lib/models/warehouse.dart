class Warehouse {
  final String wareHouseId;
  final String locationOrArea;
  final String title;
  final String description;
  final String type;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String organizationId;

  Warehouse({
    required this.wareHouseId,
    required this.locationOrArea,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.organizationId,
  });

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      wareHouseId: json['wareHouseId'],
      locationOrArea: json['locationOrArea'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      organizationId: json['organizationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wareHouseId': wareHouseId,
      'locationOrArea': locationOrArea,
      'title': title,
      'description': description,
      'type': type,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'organizationId': organizationId,
    };
  }
}
