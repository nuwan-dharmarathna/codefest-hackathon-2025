class BuyerInfo {
  final String firstName;
  final String lastName;
  final String nic;
  final String phone;
  final String? address;
  final String sludiNo;
  final String password;
  final String passwordConfirm;

  BuyerInfo({
    required this.firstName,
    required this.lastName,
    required this.nic,
    required this.phone,
    required this.sludiNo,
    required this.password,
    required this.passwordConfirm,
    this.address,
  });

  BuyerInfo copyWith({
    String? firstName,
    String? lastName,
    String? nic,
    String? phone,
    String? address,
    String? sludiNo,
    String? password,
    String? passwordConfirm,
  }) {
    return BuyerInfo(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nic: nic ?? this.nic,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      sludiNo: sludiNo ?? this.sludiNo,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
    );
  }
}
