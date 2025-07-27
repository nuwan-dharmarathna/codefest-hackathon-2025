enum SellerCategory {
  farmer,
  liveStock,
  foodMaker,
  craftMaker,
  gardener,
  other,
}

class SellerInfo {
  final SellerCategory sellerCategory;
  final String firstName;
  final String lastName;
  final String nic;
  final String phone;
  final String address;
  final String sludiNo;
  final String password;
  final String passwordConfirm;

  SellerInfo({
    required this.sellerCategory,
    required this.firstName,
    required this.lastName,
    required this.nic,
    required this.phone,
    required this.address,
    required this.sludiNo,
    required this.password,
    required this.passwordConfirm,
  });
}
