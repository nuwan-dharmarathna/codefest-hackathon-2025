import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/widgets/custom_submit_button.dart';

class OrderPlacementDialog extends StatefulWidget {
  final AdvertisementModel ad;
  final Function(double quantity, bool wantDelivery) onPlaceOrder;

  const OrderPlacementDialog({
    Key? key,
    required this.ad,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  State<OrderPlacementDialog> createState() => _OrderPlacementDialogState();
}

class _OrderPlacementDialogState extends State<OrderPlacementDialog> {
  final _formKey = GlobalKey<FormState>();
  double _quantity = 1;
  bool _wantDelivery = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDelivery = widget.ad.deliveryAvailable;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Place Your Order',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Quantity Input
                Text(
                  'Quantity (${widget.ad.unit.name})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: '1',
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.scale_outlined),
                    suffixText: widget.ad.unit.name,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    final qty = double.tryParse(value);
                    if (qty == null || qty <= 0) {
                      return 'Enter valid quantity';
                    }
                    if (qty > widget.ad.quantity) {
                      return 'Only ${widget.ad.quantity} available';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = double.parse(value!);
                  },
                ),

                if (hasDelivery) ...[
                  const SizedBox(height: 24),
                  // Delivery Option
                  Text(
                    'Delivery Option',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SwitchListTile(
                      title: const Text('I want delivery'),
                      value: _wantDelivery,
                      onChanged: (value) {
                        setState(() {
                          _wantDelivery = value;
                        });
                      },
                      secondary: const Icon(Icons.delivery_dining),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_wantDelivery && widget.ad.deliveryRadius != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Delivery available within ${widget.ad.deliveryRadius!.toStringAsFixed(1)} km',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                ],

                const SizedBox(height: 24),

                // Submit Button
                CustomSubmitButton(
                  onPressed: _submitForm,
                  lableText: "Place Order",
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await widget.onPlaceOrder(_quantity, _wantDelivery);
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
