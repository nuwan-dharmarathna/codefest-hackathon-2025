enum UserType { buyer, seller }

extension UserTypeExtention on UserType {
  String get displayName {
    switch (this) {
      case UserType.buyer:
        return "Buyer";
      case UserType.seller:
        return "Seller";
    }
  }
}
