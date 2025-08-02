import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/custom_alert_box.dart';
import 'package:frontend/widgets/custom_button.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, signupProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FormProgressIndicator(currentStep: 2, totalSteps: 3),
                  SizedBox(height: 34),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Center(
                            child: Image.asset(
                              "assets/icons/map.png",
                              width: MediaQuery.of(context).size.width * 0.3,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Select Your Location",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Drop your pin to show where you're buying from or selling your products — making pickups and deliveries simple and accurate.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 40),
                          CustomTextInputField(
                            lableText: "Enter your Address",
                            hintText: "No. 67, Main Street, Kolonnawa.",
                            keyBoardType: TextInputType.text,
                            controller: _locationController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your location';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              signupProvider.setLocation(newValue!);
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text("Or"),
                              SizedBox(width: 10),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            title: "Pick Your Location From Map",
                            backgroundColor: Colors.transparent,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            borderColor: Colors.blueAccent,
                            borderWidth: 2,
                            borderRadius: 50,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertBox(
                                    title: "Warning",
                                    message:
                                        "Coming soon!\nThis feature is still in development.",
                                    icon: Icons.warning_amber_rounded,
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  // This will stick to the bottom
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          if (signupProvider.role == UserRole.seller) {
                            GoRouter.of(
                              context,
                            ).pushNamed(RouterNames.sellerCategory);
                          } else {
                            GoRouter.of(
                              context,
                            ).pushNamed(RouterNames.userInfo);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
