import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_filter_provider.dart';
import '../providers/seller_category_provider.dart';
import '../providers/sub_category_provider.dart';
import 'custom_category_card.dart';

class CategorySelector extends StatefulWidget {
  const CategorySelector({super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final ScrollController _categoryController = ScrollController();
  final ScrollController _subCategoryController = ScrollController();

  @override
  void dispose() {
    _categoryController.dispose();
    _subCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Categories Row
        _buildCategoriesRow(context),

        // Subcategories Row (only shows when a category is selected)
        _buildSubCategoriesRow(context),
      ],
    );
  }

  Widget _buildCategoriesRow(BuildContext context) {
    final categoryProvider = context.watch<SellerCategoryProvider>();
    final filterProvider = context.watch<CategoryFilterProvider>();

    return SizedBox(
      height: 110, // Fixed height for the category row
      child: ListView.builder(
        controller: _categoryController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categoryProvider.sellerCategories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.sellerCategories[index];
          final isSelected = filterProvider.selectedCategoryId == category.id;

          return CustomCategoryCard(
            title: category.nameOnBuyerSide,
            imageUrl: category.imageOnBuyerSide,
            isSelected: isSelected,
            onTap: () {
              filterProvider.selectCategory(category.id);
              // Scroll to show the selected category if needed
              _scrollToSelected(_categoryController, index, 110);
            },
          );
        },
      ),
    );
  }

  Widget _buildSubCategoriesRow(BuildContext context) {
    final filterProvider = context.watch<CategoryFilterProvider>();
    final subCategoryProvider = context.watch<SubCategoryProvider>();

    if (filterProvider.selectedCategoryId == null)
      return const SizedBox.shrink();

    final subCategories = subCategoryProvider.getSubCategoriesByCategory(
      filterProvider.selectedCategoryId!,
    );

    if (subCategories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 4),
          child: Text(
            'Subcategories',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(
          height: 48, // More compact height for capsules
          child: ListView.builder(
            controller: _subCategoryController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            itemCount: subCategories.length,
            itemBuilder: (context, index) {
              final subCategory = subCategories[index];
              final isSelected =
                  filterProvider.selectedSubCategoryId == subCategory.id;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(
                    subCategory.name,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    filterProvider.selectSubCategory(subCategory.id);
                    _scrollToSelected(_subCategoryController, index, 100);
                  },
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).dividerColor,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  elevation: 0,
                  pressElevation: 0,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _scrollToSelected(
    ScrollController controller,
    int index,
    double itemExtent,
  ) {
    final double offset =
        index * itemExtent -
        (MediaQuery.of(context).size.width / 2 - itemExtent / 2);
    controller.animateTo(
      offset.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
