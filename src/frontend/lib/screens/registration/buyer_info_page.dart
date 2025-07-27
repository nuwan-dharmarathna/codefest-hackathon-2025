import 'package:flutter/material.dart';
import 'package:frontend/models/buyer_info.dart';
import 'package:frontend/providers/registration_provider.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:provider/provider.dart';

class BuyerInfoPage extends StatefulWidget {
  const BuyerInfoPage({super.key});

  @override
  State<BuyerInfoPage> createState() => _BuyerInfoPageState();
}

class _BuyerInfoPageState extends State<BuyerInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _sludiController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _sludiController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Information')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormProgressIndicator(currentStep: 2, totalSteps: 2),
              const SizedBox(height: 24),
              Text(
                'Enter your details',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 2,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 34),
              Expanded(
                child: SingleChildScrollView(
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                          // Add phone number validation if needed
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextInputField(
                        lableText: 'Address',
                        hintText: 'Address',
                        onSaved: (newValue) {},
                        keyBoardType: TextInputType.text,
                        obscureText: false,
                        controller: _addressController,
                        validator: (value) {
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 15, top: 15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
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
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<RegistrationProvider>(
        context,
        listen: false,
      );
      provider.setBuyerInfo(
        BuyerInfo(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          nic: _nicController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          sludiNo: _sludiController.text,
          password: _passwordController.text,
          passwordConfirm: _passwordConfirmController.text,
        ),
      );

      // Here you would typically send the data to your backend
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Successful'),
        content: const Text(
          'Your buyer account has been created successfully.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
