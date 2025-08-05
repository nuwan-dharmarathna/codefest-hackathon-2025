import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/providers/advertisement_provider.dart';
import 'package:frontend/providers/sub_category_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/services/image_upload_service.dart';
import 'package:frontend/widgets/custom_dropdown_field.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateAdvertisementScreen extends StatefulWidget {
  const CreateAdvertisementScreen({super.key});

  @override
  State<CreateAdvertisementScreen> createState() =>
      _CreateAdvertisementScreenState();
}

class _CreateAdvertisementScreenState extends State<CreateAdvertisementScreen> {
  // Constants
  static const int maxNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxImages = 3;
  static const double maxImageDimension = 1000;
  static const int imageQuality = 85;

  // Form state
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isUploadingImages = false;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Form fields
  String? _selectedSubCategory;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  Units? _selectedUnit;
  bool _deliveryAvailable = false;
  final _deliveryRadiusController = TextEditingController();
  final _newMinController = TextEditingController();
  final _newMaxController = TextEditingController();
  final _newPriceController = TextEditingController();

  // Price tiers
  final List<Map<String, dynamic>> _priceTiers = [
    {'min': '', 'max': '', 'price': ''},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _deliveryRadiusController.dispose();
    _newMinController.dispose();
    _newMaxController.dispose();
    _newPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? pickedXFiles = await _picker.pickMultiImage(
        maxWidth: maxImageDimension,
        maxHeight: maxImageDimension,
        imageQuality: imageQuality,
      );

      if (pickedXFiles != null && pickedXFiles.isNotEmpty) {
        final availableSlots = maxImages - _selectedImages.length;
        if (availableSlots <= 0) return;

        // Convert XFiles to Files and limit to available slots
        final List<File> newFiles = pickedXFiles
            .take(availableSlots)
            .map((xfile) => File(xfile.path))
            .toList();

        if (newFiles.isNotEmpty) {
          setState(() {
            _selectedImages.addAll(newFiles);
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Error selecting images: ${e.toString()}');
    }
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      setState(() {
        _selectedImages.removeAt(index);
      });
    }
  }

  void _removePriceTier(int index) {
    if (index >= 0 && index < _priceTiers.length) {
      setState(() {
        _priceTiers.removeAt(index);
      });
    }
  }

  void _addNewPriceTier() {
    if (_newMinController.text.isEmpty ||
        _newMaxController.text.isEmpty ||
        _newPriceController.text.isEmpty) {
      _showErrorSnackBar('Please fill all fields');
      return;
    }

    final newTier = {
      'min': _newMinController.text,
      'max': _newMaxController.text,
      'price': _newPriceController.text,
    };

    setState(() {
      _priceTiers.add(newTier);
      _clearPriceTierInputs();
    });
  }

  void _clearPriceTierInputs() {
    _newMinController.clear();
    _newMaxController.clear();
    _newPriceController.clear();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  bool _validatePriceTiers() {
    // Validate all fields are filled
    for (final tier in _priceTiers) {
      if (tier['min'].isEmpty || tier['max'].isEmpty || tier['price'].isEmpty) {
        _showErrorSnackBar('Please fill all price tier fields');
        return false;
      }
    }

    // Validate numeric values
    for (final tier in _priceTiers) {
      final min = double.tryParse(tier['min']);
      final max = double.tryParse(tier['max']);
      final price = double.tryParse(tier['price']);

      if (min == null || max == null || price == null) {
        _showErrorSnackBar('Invalid values in price tiers');
        return false;
      }

      if (min >= max) {
        _showErrorSnackBar('Min quantity must be less than max quantity');
        return false;
      }

      if (price <= 0) {
        _showErrorSnackBar('Price must be greater than zero');
        return false;
      }
    }

    // Check for overlapping tiers
    for (int i = 0; i < _priceTiers.length; i++) {
      for (int j = i + 1; j < _priceTiers.length; j++) {
        final aMin = double.parse(_priceTiers[i]['min']);
        final aMax = double.parse(_priceTiers[i]['max']);
        final bMin = double.parse(_priceTiers[j]['min']);
        final bMax = double.parse(_priceTiers[j]['max']);

        if (aMin <= bMax && bMin <= aMax) {
          _showErrorSnackBar('Price tiers have overlapping quantities');
          return false;
        }
      }
    }

    return true;
  }

  Future<void> _submitForm(UserProvider userProvider) async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImages.isEmpty) {
      _showErrorSnackBar('Please select at least one image');
      return;
    }
    if (_selectedSubCategory == null) {
      _showErrorSnackBar('Please select a subcategory');
      return;
    }
    if (_selectedUnit == null) {
      _showErrorSnackBar('Please select a unit');
      return;
    }
    if (!_validatePriceTiers()) return;

    setState(() => isUploadingImages = true);

    try {
      // 1. Upload images first
      final imageUrls = await ImageUploadService.uploadImages(_selectedImages);

      setState(() => _isLoading = true);

      // 2. Create advertisement object
      final advertisement = AdvertisementModel(
        id: '',
        sellerId: userProvider.user!.id!,
        categoryId: userProvider.user!.categoryId!,
        subCategoryId: _selectedSubCategory!,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        quantity: double.parse(_quantityController.text),
        unit: unitsFromString(_selectedUnit!.name),
        deliveryAvailable: _deliveryAvailable,
        deliveryRadius: _deliveryAvailable
            ? double.parse(_deliveryRadiusController.text)
            : null,
        location: userProvider.user!.location!,
        priceTiers: _priceTiers
            .map(
              (tier) => PriceTier(
                minQuantity: double.parse(tier['min']),
                maxQuantity: double.parse(tier['max']),
                price: double.parse(tier['price']),
                unit: unitsFromString(_selectedUnit!.name),
              ),
            )
            .toList(),
        images: imageUrls,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      // 3. Save advertisement
      await Provider.of<AdvertisementProvider>(
        context,
        listen: false,
      ).createAdvertisement(advertisement);

      if (mounted) {
        Navigator.of(context).pop(true); // Return success
      }
    } catch (e) {
      _showErrorSnackBar('Error creating advertisement: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          isUploadingImages = false;
        });
      }
    }
  }

  Widget _buildSubCategoryDropdown(SubCategoryProvider subCategoryProvider) {
    return CustomDropdownField<String>(
      labelText: "Select Sub Category",
      value: _selectedSubCategory,
      items: subCategoryProvider.subCategories
          .map(
            (subCategory) => DropdownMenuItem<String>(
              value: subCategory.id,
              child: Text(subCategory.name),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _selectedSubCategory = value),
      validator: (value) =>
          value == null ? 'Please select a subcategory' : null,
    );
  }

  Widget _buildNameField() {
    return CustomTextInputField(
      lableText: "Name",
      keyBoardType: TextInputType.text,
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        if (value.length > maxNameLength) {
          return 'Name cannot exceed $maxNameLength characters';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return CustomTextInputField(
      controller: _descriptionController,
      lableText: "Description",
      keyBoardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        if (value.length > maxDescriptionLength) {
          return 'Description cannot exceed $maxDescriptionLength characters';
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
    return Row(
      children: [
        Text(
          'Delivery Available',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const Spacer(),
        Transform.scale(
          scale: 0.75,
          child: Switch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: _deliveryAvailable,
            onChanged: (value) => setState(() => _deliveryAvailable = value),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryRadiusField() {
    if (!_deliveryAvailable) return const SizedBox.shrink();

    return CustomTextInputField(
      controller: _deliveryRadiusController,
      lableText: "Delivery Radius (km)",
      keyBoardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter delivery radius';
        }
        final radius = double.tryParse(value);
        if (radius == null) {
          return 'Please enter a valid number';
        }
        if (radius <= 0) {
          return 'Radius must be positive';
        }
        return null;
      },
    );
  }

  Widget _buildPriceTierItem(int index) {
    final tier = _priceTiers[index];
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${tier['min']} - ${tier['max']} ${_selectedUnit?.name ?? 'unit'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              'Rs. ${tier['price']}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => _removePriceTier(index),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTiersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Tiers',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        if (_priceTiers.isNotEmpty) ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _priceTiers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => _buildPriceTierItem(index),
          ),
          const SizedBox(height: 16),
        ],

        // Form to add new price tier
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextInputField(
                        lableText: 'Min Qty',
                        controller: _newMinController,
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextInputField(
                        lableText: 'Max Qty',
                        controller: _newMaxController,
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextInputField(
                        lableText: 'Price',
                        controller: _newPriceController,
                        keyBoardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Tier'),
                    onPressed: _addNewPriceTier,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Images (Max $maxImages)', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedImages.asMap().entries.map((entry) {
              final index = entry.key;
              return Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.file(entry.value, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => _removeImage(index),
                    ),
                  ),
                ],
              );
            }),
            if (_selectedImages.length < maxImages)
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(child: Icon(Icons.add_a_photo)),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, SubCategoryProvider>(
      builder: (context, userProvider, subCategoryProvider, child) {
        final categoryId = userProvider.user?.categoryId;

        // Fetch subcategories if needed
        if (!subCategoryProvider.isLoading &&
            subCategoryProvider.selectedCategoryId != categoryId &&
            categoryId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            subCategoryProvider.fetchSubCategoriesByCategory(categoryId);
          });
        }

        // Loading state
        if (subCategoryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error state
        if (subCategoryProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(subCategoryProvider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => subCategoryProvider
                      .fetchSubCategoriesByCategory(categoryId!),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "Create Advertisement",
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSubCategoryDropdown(subCategoryProvider),
                  const SizedBox(height: 16),
                  _buildNameField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 16),
                  _buildQuantityAndUnitFields(),
                  const SizedBox(height: 16),
                  _buildDeliveryAvailableSwitch(),
                  const SizedBox(height: 16),
                  _buildDeliveryRadiusField(),
                  if (_deliveryAvailable) const SizedBox(height: 16),
                  _buildPriceTiersSection(),
                  const SizedBox(height: 20),
                  _buildImageUploadSection(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () => _submitForm(userProvider),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
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
