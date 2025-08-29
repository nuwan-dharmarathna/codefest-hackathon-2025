import 'package:flutter/material.dart';
import 'package:frontend/providers/purchase_request_provider.dart';
import 'package:frontend/screens/user/seller/create_advertisement_screen.dart';
import 'package:frontend/screens/user/seller/purchase_request_details_screen.dart';
import 'package:frontend/widgets/custom_purchase_request_card.dart';
import 'package:provider/provider.dart';

class PurchaseRequestScreen extends StatefulWidget {
  const PurchaseRequestScreen({super.key});

  @override
  State<PurchaseRequestScreen> createState() => _PurchaseRequestScreenState();
}

class _PurchaseRequestScreenState extends State<PurchaseRequestScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _refreshData() async {
    final requestProvider = context.read<PurchaseRequestProvider>(); // ✅ FIX
    try {
      await requestProvider.fetchPurchaseRequests();
    } catch (e) {
      debugPrint('Error loading Purchase Requests: $e');
    }
  }

  Future<void> _loadInitialData() async {
    final requestProvider = context.read<PurchaseRequestProvider>(); // ✅ FIX
    try {
      await requestProvider.fetchPurchaseRequests();
    } catch (e) {
      debugPrint('Error loading Purchase Requests: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestProvider = context.watch<PurchaseRequestProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Purchase Requests",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          if (requestProvider.isLoading &&
              requestProvider.purchaseRequests.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (requestProvider.error != null)
            Expanded(
              child: Center(child: Text('Error: ${requestProvider.error}')),
            )
          else if (requestProvider.purchaseRequests.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.assignment, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No Purchase Requests Available',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a new advertisement to get started',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CreateAdvertisementScreen(),
                          ),
                        );
                      },
                      child: const Text('Create Advertisement'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: ListView.builder(
                  itemCount: requestProvider.purchaseRequests.length, // ✅ FIX
                  itemBuilder: (context, index) {
                    final request = requestProvider.purchaseRequests[index];
                    return CustomPurchaseRequestCard(
                      request: request,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PurchaseRequestDetailsScreen(request: request),
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
    );
  }
}
