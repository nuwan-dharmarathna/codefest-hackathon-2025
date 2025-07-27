import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verification Code",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "We have sent the code verification to 07*****113",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTextInput(context),
                  _buildTextInput(context),
                  _buildTextInput(context),
                  _buildTextInput(context),
                  _buildTextInput(context),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Resend code after:",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "00:54",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(BuildContext context) {
    return SizedBox(
      height: 68,
      width: 64,

      child: TextFormField(
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: TextStyle(
          fontSize: 25,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),

        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
      ),
    );
  }
}
