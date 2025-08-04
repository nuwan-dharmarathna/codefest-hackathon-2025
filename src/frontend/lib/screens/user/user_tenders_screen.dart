// // screens/tender_screen.dart
// import 'package:flutter/material.dart';
// import 'package:frontend/models/tender_model.dart';
// import 'package:frontend/providers/seller_category_provider.dart';
// import 'package:frontend/providers/tender_provider.dart';
// import 'package:frontend/widgets/custom_category_card.dart';
// import 'package:frontend/widgets/custom_tender_card.dart';
// import 'package:provider/provider.dart';
// import '../providers/category_provider.dart';
// import '../providers/seller_category_provider.dart';
// import '../providers/sub_category_provider.dart';
// import '../providers/tender_provider.dart';
// import '../widgets/custom_category_card.dart';
// import '../widgets/custom_tender_card.dart';

// class UserTendersScreen extends StatefulWidget {
//   const UserTendersScreen({super.key});

//   @override
//   State<UserTendersScreen> createState() => _UserTendersScreenState();
// }

// class _UserTendersScreenState extends State<UserTendersScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadInitialData();
//     });
//   }

//   Future<void> _loadInitialData() async {
//     await context.read<SellerCategoryProvider>().fetchAllCategories();
//     await context.read<TenderProvider>().fetchTenders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Tenders'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_alt),
//             onPressed: () {
//               context.read<CategoryProvider>().clearFilters();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Main Categories Row
//           _buildCategoriesRow(context),

//           // Subcategories Row (only shows when category is selected)
//           _buildSubCategoriesRow(context),

//           // Tenders List
//           _buildTendersList(context),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoriesRow(BuildContext context) {
//     final categoryProvider = context.watch<SellerCategoryProvider>();
//     final filterProvider = context.watch<CategoryProvider>();

//     return SizedBox(
//       height: 130,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         itemCount: categoryProvider.categories.length,
//         itemBuilder: (context, index) {
//           final category = categoryProvider.categories[index];
//           final isSelected = filterProvider.selectedCategoryId == category.id;

//           return CustomCategoryCard(
//             title: category.name,
//             imageUrl: category.imageUrl,
//             isSelected: isSelected,
//             onTap: () {
//               context.read<CategoryProvider>().selectCategory(category.id);
//               context.read<SubCategoryProvider>().fetchSubCategoriesByCategory(category.id);
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSubCategoriesRow(BuildContext context) {
//     final filterProvider = context.watch<CategoryProvider>();
//     final subCategoryProvider = context.watch<SubCategoryProvider>();

//     if (filterProvider.selectedCategoryId == null) return const SizedBox.shrink();

//     final subCategories = subCategoryProvider.getSubCategoriesByCategory(
//       filterProvider.selectedCategoryId!,
//     );

//     if (subCategories.isEmpty) return const SizedBox.shrink();

//     return SizedBox(
//       height: 60,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         itemCount: subCategories.length,
//         itemBuilder: (context, index) {
//           final subCategory = subCategories[index];
//           final isSelected = filterProvider.selectedSubCategoryId == subCategory.id;

//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: CustomCategoryCard(
//               title: subCategory.name,
//               isSelected: isSelected,
//               onTap: () {
//                 context.read<SellerCategoryProvider>().selectSubCategory(subCategory.id);
//                 context.read<TenderProvider>().fetchTendersBySubCategory(subCategory.id);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildTendersList(BuildContext context) {
//     final tenderProvider = context.watch<TenderProvider>();
//     final filterProvider = context.watch<SellerCategoryProvider>();

//     if (tenderProvider.isLoading) {
//       return const Expanded(child: Center(child: CircularProgressIndicator()));
//     }

//     if (tenderProvider.error != null) {
//       return Expanded(
//         child: Center(child: Text(tenderProvider.error!)),
//       );
//     }

//     // Filter tenders based on selections
//     List<TenderModel> filteredTenders = tenderProvider.tenders;
//     if (filterProvider.selectedCategoryId != null) {
//       filteredTenders = filteredTenders.where((t) =>
//         t.category == filterProvider.selectedCategoryId
//       ).toList();

//       if (filterProvider.selectedSubCategoryId != null) {
//         filteredTenders = filteredTenders.where((t) =>
//           t.subCategoryId == filterProvider.selectedSubCategoryId
//         ).toList();
//       }
//     }

//     if (filteredTenders.isEmpty) {
//       return Expanded(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.assignment_outlined, size: 64),
//               const SizedBox(height: 16),
//               const Text('No tenders found'),
//               const SizedBox(height: 8),
//               TextButton(
//                 onPressed: _loadInitialData,
//                 child: const Text('Refresh'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Expanded(
//       child: ListView.builder(
//         itemCount: filteredTenders.length,
//         itemBuilder: (context, index) {
//           final tender = filteredTenders[index];
//           return TenderCard(tender: tender);
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class UserTendersScreen extends StatelessWidget {
  const UserTendersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
