enum UserRole { buyer, seller }

String userRoletoString(UserRole role) {
  switch (role) {
    case UserRole.buyer:
      return 'buyer';
    case UserRole.seller:
      return 'seller';
  }
}

UserRole userRoleFromString(String role) {
  switch (role) {
    case 'buyer':
      return UserRole.buyer;
    case 'seller':
      return UserRole.seller;
    default:
      throw Exception('Invalid role');
  }
}

class UserModel {
  String? id;
  UserRole? role;
  String? location;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? password;
  String? passwordConfirm;
  String? sludiNo;
  String? nic;
  String? categoryId; // Only for sellers
  String? businessName; // Only for sellers
  String? businessRegistrationNo; // Optional

  UserModel({
    this.id,
    this.role,
    this.location,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.password,
    this.passwordConfirm,
    this.sludiNo,
    this.nic,
    this.categoryId,
    this.businessName,
    this.businessRegistrationNo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      role: userRoleFromString(json['role']),
      location: json['location'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      sludiNo: json['sludiNo'],
      nic: json['nic'],
      categoryId: json['category'],
      businessName: json['businessName'],
      businessRegistrationNo: json['businessRegistrationNo'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'role': userRoletoString(role!),
      'location': location,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
      'sludiNo': sludiNo,
      'nic': nic,
    };

    if (role == UserRole.seller) {
      data['category'] = categoryId;
      data['businessName'] = businessName;
      if (businessRegistrationNo != null &&
          businessRegistrationNo!.isNotEmpty) {
        data['businessRegistrationNo'] = businessRegistrationNo;
      }
    }

    return data;
  }
}
