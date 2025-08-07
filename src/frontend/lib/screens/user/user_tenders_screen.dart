import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/user/tender_create_screen.dart';
import 'package:frontend/screens/user/tender_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/tender_provider.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/widgets/category_selector.dart';

class UserTendersScreen extends StatefulWidget {
  const UserTendersScreen({super.key});

  @override
  State<UserTendersScreen> createState() => _UserTendersScreenState();
}

class _UserTendersScreenState extends State<UserTendersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final userProvider = context.read<UserProvider>();
    final tenderProvider = context.read<TenderProvider>();

    if (userProvider.user!.role == UserRole.seller) {
      // For sellers, fetch tenders based on their category
      await tenderProvider.fetchTendersBasedOnSellerCategory();
    } else {
      // For buyers, fetch all categories and all tenders
      await context.read<SellerCategoryProvider>().fetchAllCategories();
      await tenderProvider.fetchTenders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final tenderProvider = context.watch<TenderProvider>();
    final categoryProvider = context.watch<SellerCategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Tenders",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: Column(
        children: [
          // Show category selector only for buyers
          if (userProvider.user!.role == UserRole.buyer) CategorySelector(),

          // Loading indicator
          if (tenderProvider.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (tenderProvider.error != null)
            // Error message
            Expanded(
              child: Center(child: Text('Error: ${tenderProvider.error}')),
            )
          else if (tenderProvider.tenders.isEmpty)
            // Empty state
            Expanded(
              child: Center(
                child: Text(
                  userProvider.user!.role == UserRole.seller
                      ? 'No tenders found in your category'
                      : 'No tenders found',
                ),
              ),
            )
          else
            // Tenders list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadInitialData,
                child: ListView.builder(
                  itemCount: tenderProvider.tenders.length,
                  itemBuilder: (context, index) {
                    final tender = tenderProvider.tenders[index];
                    return TenderDetailsScreen(tender: tender);
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: userProvider.user!.role == UserRole.seller
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TenderCreateScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
              tooltip: 'Create New Tender',
            )
          : null,
    );
  }
}
