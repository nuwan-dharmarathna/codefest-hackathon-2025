import 'package:flutter/foundation.dart';
import 'package:frontend/models/buyer_info.dart';
import 'package:frontend/models/registration_data.dart';
import 'package:frontend/models/seller_info.dart';
import 'package:frontend/models/user_type.dart';

class RegistrationProvider extends ChangeNotifier {
  RegistrationData _registrationData = RegistrationData(
    userType: UserType.buyer,
  );

  RegistrationData get registrationData => _registrationData;

  void setUserType(UserType type) {
    _registrationData = RegistrationData(userType: type);
    notifyListeners();
  }

  void setBuyerInfo(BuyerInfo info) {
    _registrationData = _registrationData.copyWith(buyerInfo: info);
    notifyListeners();
  }

  void setSellerCategory(SellerCategory category) {
    _registrationData = _registrationData.copyWith(
      sellerInfo: SellerInfo(
        sellerCategory: category,
        firstName: '',
        lastName: '',
        nic: '',
        phone: '',
        address: '',
        sludiNo: '',
        password: '',
        passwordConfirm: '',
      ),
    );
    notifyListeners();
  }

  void setSellerInfo(SellerInfo info) {
    _registrationData = _registrationData.copyWith(sellerInfo: info);
    notifyListeners();
  }
}
