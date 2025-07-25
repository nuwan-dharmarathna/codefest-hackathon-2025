import 'package:flutter/material.dart';
import 'package:frontend/data/onboarding_data.dart';
import 'package:frontend/models/onboarding_model.dart';
import 'package:frontend/screens/user_data_form.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool showDetailsPage = false;
  @override
  Widget build(BuildContext context) {
    final onboardingList = OnboardingData().onboardingList;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (value) {
                    setState(() {
                      showDetailsPage = value == 2;
                    });
                  },
                  children: [
                    _builtTool(onboardingList[0]),
                    _builtTool(onboardingList[1]),
                    _builtTool(onboardingList[2]),
                  ],
                ),
                //dots
                Container(
                  alignment: Alignment(0, 0.65),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: WormEffect(
                      activeDotColor: Theme.of(context).colorScheme.onSurface,
                      dotWidth: 8,
                      dotHeight: 14,
                    ),
                  ),
                ),

                // navigator button
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: !showDetailsPage
                      ? GestureDetector(
                          onTap: () {
                            _controller.animateToPage(
                              _controller.page!.toInt() + 1,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CustomButton(
                            title: showDetailsPage ? "Get Started" : "Next",
                            backgroungColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDataForm(),
                              ),
                            );
                          },
                          child: CustomButton(
                            title: showDetailsPage ? "Get Started" : "Next",
                            backgroungColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builtTool(OnboardingModel onboarding) {
    return Stack(
      children: [
        ClipRRect(
          child: Image.asset(
            onboarding.imageUrl,
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 10),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.08,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // This aligns children to the start (left)
              children: [
                Text(
                  onboarding.description,
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ), // Add some vertical spacing between texts
                Text(
                  onboarding.description_2!,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ), // Add some vertical spacing between texts
                Text(
                  onboarding.description_3!,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
