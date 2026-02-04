import 'package:agriculture_inventory_managment/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
import 'product_list_screen.dart';
import 'add_edit_product_screen.dart';

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
    context.read<ProductBloc>().add(const LoadProducts());
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
        elevation: 0,
        height: 64,
        backgroundColor: Theme.of(context).colorScheme.surface,
        indicatorColor: Theme.of(context).colorScheme.primaryContainer,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
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
    context.read<ProductBloc>().add(event);
    final homeScreenState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeScreenState != null) {
      homeScreenState._onNavItemTapped(1);
    }
  }

  void _navigateToAddProduct(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditProductScreen(),
      ),
    );

    if (result == true) {
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text(
          'Agriculture Inventory',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.white
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor:AppTheme.primaryBlue,
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_outlined,color: Colors.white,),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<ProductBloc>().add(const LoadProducts());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(horizontalPadding),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                                  child: _StatCard(
                                    title: 'Total Products',
                                    value: totalProducts.toString(),
                                    icon: Icons.inventory_2_outlined,
                                    color: const Color(0xFF2563EB),
                                    onTap: () => _navigateAndLoadProducts(
                                      context,
                                      const LoadProducts(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Low Stock',
                                    value: lowStockProducts.toString(),
                                    icon: Icons.warning_amber_outlined,
                                    color: const Color(0xFFDC2626),
                                    onTap: () => _navigateAndLoadProducts(
                                      context,
                                      const LoadLowStockProducts(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    title: 'Expiring Soon',
                                    value: expiringProducts.toString(),
                                    icon: Icons.schedule_outlined,
                                    color: const Color(0xFFF59E0B),
                                    onTap: () => _navigateAndLoadProducts(
                                      context,
                                      const LoadExpiringProducts(),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _StatCard(
                                    title: 'Expired',
                                    value: expiredProducts.toString(),
                                    icon: Icons.cancel_outlined,
                                    color: const Color(0xFF7C3AED),
                                    onTap: () => _navigateAndLoadProducts(
                                      context,
                                      const LoadExpiredProducts(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (state is ProductLoading) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: CircularProgressIndicator(
                              color: colorScheme.primary,
                            ),
                          ),
                        );
                      } else if (state is ProductError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: colorScheme.error,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading products',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FilledButton.icon(
                                  onPressed: () {
                                    context
                                        .read<ProductBloc>()
                                        .add(const LoadProducts());
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48.0),
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.5,
                    children: [
                      _ActionCard(
                        title: 'Add Product',
                        icon: Icons.add_circle_outline,
                        color: Colors.white,
                        onTap: () => _navigateToAddProduct(context),
                      ),
                      _ActionCard(
                        title: 'Stock In',
                        icon: Icons.arrow_circle_down_outlined,
                        color: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        title: 'Stock Out',
                        icon: Icons.arrow_circle_up_outlined,
                        color: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Coming soon'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      _ActionCard(
                        title: 'View All',
                        icon: Icons.list_alt_outlined,
                        color: Colors.white,
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 15,
                    fontWeight: FontWeight.bold

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppTheme.primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 30,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}