import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _sludiController = TextEditingController();
  final _emailController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessRegNoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordConfirmController.dispose();
    _passwordController.dispose();
    _sludiController.dispose();
    _nicController.dispose();
    _businessNameController.dispose();
    _businessRegNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SignupProvider>(
      builder: (context, signupProvider, child) {
        final role = signupProvider.role;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    role == UserRole.buyer
                        ? FormProgressIndicator(currentStep: 3, totalSteps: 3)
                        : FormProgressIndicator(currentStep: 4, totalSteps: 4),
                    SizedBox(height: 34),
                    Text(
                      'Enter your details',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 2,
                            fontSize: 25,
                          ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),

              // Scrollable form fields
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextInputField(
                          lableText: 'First Name',
                          hintText: 'First Name',
                          keyBoardType: TextInputType.text,
                          onSaved: (newValue) {},
                          obscureText: false,
                          controller: _firstNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'Last Name',
                          hintText: 'Last Name',
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.text,
                          obscureText: false,
                          controller: _lastNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'Phone',
                          hintText: 'Phone',
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.phone,
                          obscureText: false,
                          controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }

                            // Remove all non-digit characters
                            String cleanedPhone = value.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );

                            // Basic length validation (adjust for your country)
                            if (cleanedPhone.length < 8 ||
                                cleanedPhone.length > 15) {
                              return 'Enter a valid phone number (8-15 digits)';
                            }

                            // 3. Sri Lanka format (94XXXXXXXXX or 0XXXXXXXXX)
                            if (!RegExp(
                              r'^(?:94|0)(?:\d{9})$',
                            ).hasMatch(cleanedPhone)) {
                              return 'Enter a valid Sri Lankan number (94XXXXXXXXX or 0XXXXXXXXX)';
                            }

                            return null; // Return null if valid
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'Email',
                          hintText: 'example@gmail.com',
                          keyBoardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
                            ).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            // signupProvider.setEmail(newValue!.trim());
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'NIC',
                          hintText: "NIC",
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.text,
                          obscureText: false,
                          controller: _nicController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your NIC';
                            }
                            // Add more NIC validation if needed
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'SLUDI Number',
                          hintText: 'SLUDI Number',
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.text,
                          obscureText: false,
                          controller: _sludiController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your SLUDI Number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'Password',
                          hintText: 'Password',
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.text,
                          obscureText: true,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextInputField(
                          lableText: 'Password Confirm',
                          hintText: 'Password Confirm',
                          onSaved: (newValue) {},
                          keyBoardType: TextInputType.text,
                          obscureText: true,
                          controller: _passwordConfirmController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your Password';
                            }
                            return null;
                          },
                        ),
                        if (role == UserRole.seller) ...[
                          const SizedBox(height: 16),
                          CustomTextInputField(
                            lableText: 'Business Name',
                            hintText: 'Name of your business',
                            onSaved: (newValue) {
                              // signupProvider.setBusinessName(newValue!);
                            },
                            keyBoardType: TextInputType.text,
                            obscureText: false,
                            controller: _businessNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your business name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextInputField(
                            lableText: 'Business Registration (Optional)',
                            hintText: 'Business Registration No.',
                            onSaved: (newValue) {
                              if (newValue != null && newValue.isNotEmpty) {
                                // signupProvider.setBusinessRegistration(newValue);
                              }
                            },
                            keyBoardType: TextInputType.text,
                            obscureText: false,
                            controller:
                                _businessRegNoController, // Make sure to create this controller
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 40, top: 15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserModel newUser = UserModel();
                      if (role == UserRole.buyer) {
                        newUser = UserModel(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          sludiNo: _sludiController.text,
                          nic: _nicController.text,
                          password: _passwordController.text,
                          passwordConfirm: _passwordConfirmController.text,
                          role: signupProvider.role,
                          location: signupProvider.location,
                        );
                      } else {
                        newUser = UserModel(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          sludiNo: _sludiController.text,
                          nic: _nicController.text,
                          password: _passwordController.text,
                          passwordConfirm: _passwordConfirmController.text,
                          role: signupProvider.role,
                          location: signupProvider.location,
                          categoryId: signupProvider.category,
                          businessName: _businessNameController.text,
                          businessRegistrationNo: _businessRegNoController.text,
                        );
                      }
                      try {
                        final res = await signupProvider.signUpUser(newUser);
                        if (res == 200) {
                          signupProvider.clear();
                          GoRouter.of(context).pushNamed(RouterNames.signIn);
                        } else {
                          signupProvider.clear();
                          GoRouter.of(context).pushNamed(RouterNames.signUp);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error signup user: $e")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.1),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Sumbit", style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
