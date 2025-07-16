class Organization {
  final String id;
  final String name;
  final String address;
  final String contactPerson;
  final String email;
  final String phone;
  final String type;
  final String status;

  Organization({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.type,
    required this.status,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
      'type': type,
      'status': status,
    };
  }
}
