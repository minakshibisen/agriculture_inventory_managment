import 'package:agriculture_inventory_managment/presentation/screen/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardTab(),
    const ProductsListScreen(),
    const Center(child: Text('Transactions')),
    const Center(child: Text('Reports')),
  ];

  @override
  void initState() {
    super.initState();
    // Load products when app starts
    context.read<ProductBloc>().add(const LoadProducts());
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Reload products when navigating to Products tab
    if (index == 1) {
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  void _navigateAndLoadProducts(BuildContext context, ProductEvent event) {
    // Load the filtered products
    context.read<ProductBloc>().add(event);

    // Navigate to Products tab (index 1)
    // We need to access the parent HomeScreen state
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeScreenState != null) {
      homeScreenState._onNavItemTapped(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agriculture Inventory Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(const LoadProducts());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoaded) {
                    final products = state.products;
                    final totalProducts = products.length;
                    final lowStockProducts =
                        products.where((p) => p.isLowStock).length;
                    final expiringProducts =
                        products.where((p) => p.isExpiringSoon).length;
                    final expiredProducts =
                        products.where((p) => p.isExpired).length;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _DashboardCard(
                                title: 'Total Products',
                                value: totalProducts.toString(),
                                icon: Icons.inventory_2,
                                color: AppTheme.primaryGreen,
                                onTap: () {
                                  _navigateAndLoadProducts(
                                    context,
                                    const LoadProducts(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _DashboardCard(
                                title: 'Low Stock',
                                value: lowStockProducts.toString(),
                                icon: Icons.warning_amber,
                                color: AppTheme.warningRed,
                                onTap: () {
                                  _navigateAndLoadProducts(
                                    context,
                                    const LoadLowStockProducts(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _DashboardCard(
                                title: 'Expiring Soon',
                                value: expiringProducts.toString(),
                                icon: Icons.access_time,
                                color: AppTheme.accentOrange,
                                onTap: () {
                                  _navigateAndLoadProducts(
                                    context,
                                    const LoadExpiringProducts(),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _DashboardCard(
                                title: 'Expired',
                                value: expiredProducts.toString(),
                                icon: Icons.dangerous,
                                color: AppTheme.warningRed,
                                onTap: () {
                                  _navigateAndLoadProducts(
                                    context,
                                    const LoadExpiredProducts(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (state is ProductLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is ProductError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error loading products',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ProductBloc>()
                                    .add(const LoadProducts());
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _QuickActionCard(
                    title: 'Add Product',
                    icon: Icons.add_box,
                    onTap: () {

                    },
                  ),
                  _QuickActionCard(
                    title: 'Stock In',
                    icon: Icons.arrow_downward,
                    onTap: () {
                      // Navigate to stock in
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stock In screen coming soon!'),
                        ),
                      );
                    },
                  ),
                  _QuickActionCard(
                    title: 'Stock Out',
                    icon: Icons.arrow_upward,
                    onTap: () {
                      // Navigate to stock out
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Stock Out screen coming soon!'),
                        ),
                      );
                    },
                  ),
                  _QuickActionCard(
                    title: 'View All',
                    icon: Icons.list_alt,
                    onTap: () {
                      final homeScreenState =
                      context.findAncestorStateOfType<_HomeScreenState>();
                      if (homeScreenState != null) {
                        homeScreenState._onNavItemTapped(1);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppTheme.primaryGreen),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}