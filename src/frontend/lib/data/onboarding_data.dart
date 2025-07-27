import 'package:frontend/models/onboarding_model.dart';

class OnboardingData {
  final List<OnboardingModel> onboardingList = [
    OnboardingModel(
      imageUrl: "assets/images/farmer.jpeg",
      description: "You harvest it.",
      description_2: "You price it.",
    ),
    OnboardingModel(
      imageUrl: "assets/images/creator.jpeg",
      description: "Turn your skills into a story the whole nation hears.",
      description_2: "",
    ),
    OnboardingModel(
      imageUrl: "assets/images/customer.jpeg",
      description: "Skip the middlemen.",
      description_2: "Buy fresh, buy fair.",
    ),
  ];
}
