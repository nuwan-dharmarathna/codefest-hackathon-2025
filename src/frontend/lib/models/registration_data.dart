import 'package:frontend/models/buyer_info.dart';
import 'package:frontend/models/seller_info.dart';
import 'package:frontend/models/user_type.dart';

class RegistrationData {
  final UserType userType;
  final BuyerInfo? buyerInfo;
  final SellerInfo? sellerInfo;

  RegistrationData({required this.userType, this.buyerInfo, this.sellerInfo});

  RegistrationData copyWith({
    UserType? userType,
    BuyerInfo? buyerInfo,
    SellerInfo? sellerInfo,
  }) {
    return RegistrationData(
      userType: userType ?? this.userType,
      buyerInfo: buyerInfo ?? this.buyerInfo,
      sellerInfo: sellerInfo ?? this.sellerInfo,
    );
  }
}
