import 'package:flutter/material.dart';
import 'package:frontend/models/sub_category_model.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/sub_category_provider.dart';
import 'package:frontend/providers/tender_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/custom_alert_box.dart';
import 'package:frontend/widgets/custom_dropdown_field.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:provider/provider.dart';

class TenderCreateScreen extends StatefulWidget {
  const TenderCreateScreen({super.key});

  @override
  State<TenderCreateScreen> createState() => _TenderCreateScreenState();
}

class _TenderCreateScreenState extends State<TenderCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  String? _selectedSubCategory;
  String? _selectedCategory;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  Units? _selectedUnit;
  bool _deliveryRequired = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(UserProvider userProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Create advertisement object
      final tender = TenderModel(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        subCategory: _selectedSubCategory!,
        quantity: double.parse(_quantityController.text),
        unit: unitsFromString(_selectedUnit!.name),
        deliveryRequired: _deliveryRequired,
      );

      // 3. Save advertisement
      final response = await Provider.of<TenderProvider>(
        context,
        listen: false,
      ).createTender(tender);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Check the response status
      if (response['status'] == 'success') {
        // Show success dialog
        await showDialog(
          context: context,
          builder: (context) => CustomAlertBox(
            title: 'Success',
            message: 'Advertisement created successfully!',
            icon: Icons.check_circle,
            titleColor: Colors.green,
          ),
        );

        // Reset the form instead of navigating away
        if (mounted) {
          _resetForm();
        }
      } else {
        // Show error from the response
        final errorMessage = response['message'] ?? 'Failed to create tender';
        showDialog(
          context: context,
          builder: (context) => CustomAlertBox(
            title: 'Error',
            message: errorMessage,
            icon: Icons.error,
            titleColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.of(context).pop();

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => CustomAlertBox(
            title: 'Error',
            message: 'Failed to create advertisement: ${e.toString()}',
            icon: Icons.error,
            titleColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    setState(() {
      _selectedSubCategory = null;
      _selectedCategory = null;
      _deliveryRequired = false;
      _selectedUnit = null;
    });
  }

  Widget _buildSubCategoryDropdown(
    String? categoryId,
    SubCategoryProvider subCategoryProvider,
  ) {
    if (categoryId == null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text('Please select a category first'),
      );
    }

    // Filter items to ensure no duplicates and match selected value
    final subCategoryItems = subCategoryProvider.subCategories
        .fold<Map<String, SubCategoryModel>>({}, (map, item) {
          map[item.id] = item; // This ensures unique IDs
          return map;
        })
        .values
        .map(
          (subCategory) => DropdownMenuItem<String>(
            value: subCategory.id,
            child: Text(subCategory.name),
          ),
        )
        .toList();

    // Reset selection if current value doesn't exist in new items
    if (_selectedSubCategory != null &&
        !subCategoryProvider.subCategories.any(
          (x) => x.id == _selectedSubCategory,
        )) {
      _selectedSubCategory = null;
    }

    return Column(
      children: [
        CustomDropdownField<String>(
          labelText: "Sub Category",
          hintText: "Select sub category",
          value: _selectedSubCategory,
          items: subCategoryItems,
          onChanged: subCategoryProvider.isLoading || categoryId.isEmpty
              ? null
              : (value) => setState(() => _selectedSubCategory = value),
          validator: (value) =>
              value == null ? 'Please select a subcategory' : null,
        ),
        // ... rest of your existing code ...
      ],
    );
  }

  Widget _buildCategoryDropdown(SellerCategoryProvider categoryProvider) {
    return CustomDropdownField<String>(
      labelText: "Category",
      hintText: "Select category",
      value: _selectedCategory,
      items: categoryProvider.sellerCategories
          .map(
            (category) => DropdownMenuItem<String>(
              value: category.id,
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
          _selectedSubCategory = null;
        });
        if (value != null) {
          Provider.of<SubCategoryProvider>(
            context,
            listen: false,
          ).fetchSubCategoriesByCategory(value);
        }
      },
      validator: (value) => value == null ? 'Please select a category' : null,
    );
  }

  Widget _buildNameField() {
    return CustomTextInputField(
      lableText: "Tender Name",
      hintText: "Enter tender name",
      keyBoardType: TextInputType.text,
      controller: _titleController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        if (value.length > 30) {
          return 'Name cannot exceed 30 characters';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextInputField(
      controller: _descriptionController,
      lableText: "Description",
      hintText: "Enter tender description",
      keyBoardType: TextInputType.multiline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length > 100) {
          return 'Description cannot exceed 100 characters';
        }
        return null;
      },
    );
  }

  Widget _buildQuantityAndUnitFields() {
    return Row(
      children: [
        // Quantity field
        Expanded(
          flex: 2,
          child: CustomTextInputField(
            controller: _quantityController,
            lableText: "Quantity",
            keyBoardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter quantity';
              }
              final quantity = double.tryParse(value);
              if (quantity == null) {
                return 'Please enter a valid number';
              }
              if (quantity <= 0) {
                return 'Quantity must be positive';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 16),

        // Unit dropdown
        Expanded(
          flex: 1,
          child: CustomDropdownField<Units>(
            labelText: "Units",
            hintText: "Select",
            value: _selectedUnit,
            items: Units.values
                .map(
                  (unit) => DropdownMenuItem<Units>(
                    value: unit,
                    child: Text(unitsToString(unit)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedUnit = value),
            validator: (value) => value == null ? 'Please select a unit' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryAvailableSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_shipping,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Text(
            'Want to deliver it?',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: _deliveryRequired,
            onChanged: (value) => setState(() => _deliveryRequired = value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(UserProvider provider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.2),
      ),
      onPressed: _isLoading
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _submitForm(provider);
              }
            },
      child: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                strokeWidth: 2,
              ),
            )
          : Text(
              'Create Tender',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, SellerCategoryProvider, SubCategoryProvider>(
      builder:
          (
            context,
            userProvider,
            categoryProvider,
            subCategoryProvider,
            child,
          ) {
            if (categoryProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                centerTitle: true,
                title: Text(
                  "Create New Tender",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tender Details",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _buildCategoryDropdown(categoryProvider),
                      const SizedBox(height: 16),
                      _buildSubCategoryDropdown(
                        _selectedCategory,
                        subCategoryProvider,
                      ),
                      const SizedBox(height: 16),
                      _buildNameField(),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                      const SizedBox(height: 16),
                      _buildQuantityAndUnitFields(),
                      const SizedBox(height: 24),
                      _buildDeliveryAvailableSwitch(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildActionButtons(userProvider)],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
    );
  }
}
