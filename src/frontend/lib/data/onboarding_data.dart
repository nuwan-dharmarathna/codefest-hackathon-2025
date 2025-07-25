import 'package:frontend/models/onboarding_model.dart';

class OnboardingData {
  final List<OnboardingModel> onboardingList = [
    OnboardingModel(
      imageUrl: "assets/images/farmer.jpeg",
      description: "You grew it",
      description_2: "You price it",
      description_3: " Take control of your harvest",
    ),
    OnboardingModel(
      imageUrl: "assets/images/creator.jpeg",
      description: "From your hands to the nation’s heart,",
      description_2: "Let your skills shine across Sri Lanka",
      description_3: "",
    ),
    OnboardingModel(
      imageUrl: "assets/images/customer.jpeg",
      description: "No middlemen",
      description_2: "No filters",
      description_3: "Just pure market power in your hands",
    ),
  ];
}
