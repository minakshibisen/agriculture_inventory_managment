import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import '../../../core/theme/app_theme.dart';
import '../../core/utilities/currency_formetter.dart';
import '../../core/utilities/date_formatter.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
import 'add_edit_product_screen.dart';
import 'product_detail_screen.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({super.key});

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    switch (filter) {
      case 'All':
        context.read<ProductBloc>().add(const LoadProducts());
        break;
      case 'Low Stock':
        context.read<ProductBloc>().add(const LoadLowStockProducts());
        break;
      case 'Expiring Soon':
        context.read<ProductBloc>().add(const LoadExpiringProducts());
        break;
      case 'Expired':
        context.read<ProductBloc>().add(const LoadExpiredProducts());
        break;
    }
  }

  void _navigateToAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddEditProductScreen(),
      ),
    );

    // Reload products if product was added
    if (result == true) {
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  void _navigateToProductDetails(Product product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );

    // Reload products if product was updated/deleted
    if (result == true) {
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<ProductBloc>()
                        .add(const SearchProducts(''));
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                context.read<ProductBloc>().add(SearchProducts(value));
              },
            ),
          ),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedFilter == 'All',
                  onSelected: () => _onFilterChanged('All'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Low Stock',
                  isSelected: _selectedFilter == 'Low Stock',
                  onSelected: () => _onFilterChanged('Low Stock'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Expiring Soon',
                  isSelected: _selectedFilter == 'Expiring Soon',
                  onSelected: () => _onFilterChanged('Expiring Soon'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Expired',
                  isSelected: _selectedFilter == 'Expired',
                  onSelected: () => _onFilterChanged('Expired'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Products List
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductsLoaded) {
                  if (state.products.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first product',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductBloc>().add(const LoadProducts());
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: state.products[index],
                          onTap: () => _navigateToProductDetails(state.products[index]),
                        );
                      },
                    ),
                  );
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
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
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Products'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Products'),
              leading: Radio<String>(
                value: 'All',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  Navigator.pop(context);
                  _onFilterChanged(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Low Stock'),
              leading: Radio<String>(
                value: 'Low Stock',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  Navigator.pop(context);
                  _onFilterChanged(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Expiring Soon'),
              leading: Radio<String>(
                value: 'Expiring Soon',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  Navigator.pop(context);
                  _onFilterChanged(value!);
                },
              ),
            ),
            ListTile(
              title: const Text('Expired'),
              leading: Radio<String>(
                value: 'Expired',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  Navigator.pop(context);
                  _onFilterChanged(value!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: AppTheme.primaryBlue,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textPrimary,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.category,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        CurrencyFormatter.formatCurrency(product.price),
                        style:
                        Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'per ${product.unit}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatusChip(
                    label: 'Stock: ${product.currentStock} ${product.unit}',
                    color: product.isLowStock
                        ? AppTheme.warningOrange
                        : AppTheme.secondaryBlue,
                  ),
                  const SizedBox(width: 8),
                  if (product.isExpired)
                    const _StatusChip(
                      label: 'Expired',
                      color: AppTheme.warningOrange,
                    )
                  else if (product.isExpiringSoon)
                    _StatusChip(
                      label: DateFormatter.getDaysUntilExpiry(
                          product.expiryDate),
                      color: AppTheme.accentLightBlue,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Expiry: ${DateFormatter.formatDate(product.expiryDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusChip({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}