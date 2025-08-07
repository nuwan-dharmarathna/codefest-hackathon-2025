// import 'package:flutter/material.dart';
// import 'package:frontend/models/tender_model.dart';
// import 'package:frontend/widgets/custom_dropdown_field.dart';
// import 'package:frontend/widgets/custom_text_input.dart';

// class TenderCreateScreen extends StatefulWidget {
//   const TenderCreateScreen({Key? key}) : super(key: key);

//   @override
//   _TenderCreateScreenState createState() => _TenderCreateScreenState();
// }

// class _TenderCreateScreenState extends State<TenderCreateScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _titleController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _deliveryLocationController = TextEditingController();

//   bool _deliveryRequired = false;
//   bool _isLoading = false;

//   // Sample data - replace with your actual data from API
//   List<Map<String, dynamic>> _categories = [];
//   List<Map<String, dynamic>> _subCategories = [];
//   String? _selectedCategoryId;
//   String? _selectedSubCategoryId;
//   Units _selectedUnit = Units.kg;

//   @override
//   void initState() {
//     super.initState();
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     setState(() => _isLoading = true);
//     try {
//       // Replace with your actual API calls
//       final categories = await ApiService().getCategories();
//       setState(() {
//         _categories = categories;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load categories: $e')),
//       );
//     }
//   }

//   Future<void> _loadSubCategories(String categoryId) async {
//     setState(() => _isLoading = true);
//     try {
//       // Replace with your actual API call
//       final subCategories = await ApiService().getSubCategories(categoryId);
//       setState(() {
//         _subCategories = subCategories;
//         _selectedSubCategoryId = null;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load sub-categories: $e')),
//       );
//     }
//   }

//   Future<void> _submitTender() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final tenderData = {
//         "title": _titleController.text,
//         "description": _descriptionController.text,
//         "category": _selectedCategoryId,
//         "subCategory": _selectedSubCategoryId,
//         "quantity": double.parse(_quantityController.text),
//         "unit": unitsToString(_selectedUnit),
//         "deliveryRequired": _deliveryRequired,
//         if (_deliveryRequired && _deliveryLocationController.text.isNotEmpty)
//           "deliveryLocation": _deliveryLocationController.text,
//       };

//       // Replace with your actual API call
//       await ApiService().createTender(tenderData);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Tender created successfully!')),
//       );
//       Navigator.of(context).pop(true); // Return success
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to create tender: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create New Tender'),
//       ),
//       body: _isLoading && _categories.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Form(
//               key: _formKey,
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomTextInputField(
//                       lableText: 'Title',
//                       hintText: 'Enter tender title',
//                       keyBoardType: TextInputType.text,
//                       controller: _titleController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a title';
//                         }
//                         if (value.length > 100) {
//                           return 'Title cannot exceed 100 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     CustomTextInputField(
//                       lableText: 'Description',
//                       keyBoardType: TextInputType.text,
//                       hintText: 'Enter tender description',
//                       controller: _descriptionController,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a description';
//                         }
//                         if (value.length > 1000) {
//                           return 'Description cannot exceed 1000 characters';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     CustomDropdownField<String>(
//                       labelText: 'Category',
//                       value: _selectedCategoryId,
//                       items: _categories
//                           .map((category) => DropdownMenuItem<String>(
//                                 value: category['_id'],
//                                 child: Text(category['name']),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedCategoryId = value;
//                           _selectedSubCategoryId = null;
//                         });
//                         if (value != null) {
//                           _loadSubCategories(value);
//                         }
//                       },
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Please select a category';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     CustomDropdownField<String>(
//                       labelText: 'Subcategory (Optional)',
//                       value: _selectedSubCategoryId,
//                       items: _subCategories
//                           .map((subCategory) => DropdownMenuItem<String>(
//                                 value: subCategory['_id'],
//                                 child: Text(subCategory['name']),
//                               ))
//                           .toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedSubCategoryId = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: CustomTextInputField(
//                             lableText: 'Quantity',
//                             hintText: 'Enter quantity',
//                             controller: _quantityController,
//                             keyBoardType: TextInputType.number,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter quantity';
//                               }
//                               if (double.tryParse(value) == null) {
//                                 return 'Please enter a valid number';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           flex: 1,
//                           child: CustomDropdownField<Units>(
//                             labelText: 'Unit',
//                             value: _selectedUnit,
//                             items: Units.values
//                                 .map((unit) => DropdownMenuItem<Units>(
//                                       value: unit,
//                                       child: Text(unitsToString(unit)),
//                                     ))
//                                 .toList(),
//                             onChanged: (value) {
//                               if (value != null) {
//                                 setState(() {
//                                   _selectedUnit = value;
//                                 });
//                               }
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     SwitchListTile(
//                       title: const Text('Delivery Required'),
//                       value: _deliveryRequired,
//                       onChanged: (value) {
//                         setState(() {
//                           _deliveryRequired = value;
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 32),
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _submitTender,
//                         child: _isLoading
//                             ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                             : const Text(
//                                 'Create Tender',
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _quantityController.dispose();
//     _deliveryLocationController.dispose();
//     super.dispose();
//   }
// }
