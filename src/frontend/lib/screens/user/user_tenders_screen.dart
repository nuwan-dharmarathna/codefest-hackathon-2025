import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/screens/user/tender_create_screen.dart';
import 'package:frontend/screens/user/tender_details_screen.dart';
import 'package:frontend/widgets/custom_tender_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/providers/tender_provider.dart';
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

    try {
      if (userProvider.user!.role == UserRole.seller) {
        await tenderProvider.fetchTenders();
      } else {
        await tenderProvider.fetchTenders();
      }

      // Debug print to verify data
      print('Tenders loaded: ${tenderProvider.tenders.length}');
      if (tenderProvider.tenders.isNotEmpty) {
        print('First tender title: ${tenderProvider.tenders.first.title}');
      }
    } catch (e) {
      print('Error loading tenders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final tenderProvider = context.watch<TenderProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Tenders",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Show category selector only for buyers
          if (userProvider.user!.role == UserRole.buyer)
            const CategorySelector(),

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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No tenders available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new tender to get started',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TenderCreateScreen(),
                          ),
                        );
                      },
                      child: const Text('Create Tender'),
                    ),
                  ],
                ),
              ),
            )
          else
            // Tenders list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadInitialData,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: tenderProvider.tenders.length,
                  itemBuilder: (context, index) {
                    final tender = tenderProvider.tenders[index];
                    log("Tender Name: ${tender.title}");
                    return CustomTenderCard(
                      tender: tender,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TenderDetailsScreen(
                              tender: tender,
                              currentUserRole: userProvider.user!.role!,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TenderCreateScreen()),
          );
        },
        tooltip: 'Create New Tender',
        child: const Icon(Icons.add),
      ),
    );
  }
}
