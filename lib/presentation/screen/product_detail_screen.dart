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

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditProductScreen(product: product),
                ),
              );

              // Reload products if product was updated
              if (result == true) {
                context.read<ProductBloc>().add(const LoadProducts());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.secondaryBlue,
              ),
            );
            Navigator.pop(context); // Go back after delete
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningOrange,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Status
              _buildHeaderCard(context),

              // Basic Information
              _buildSectionTitle(context, 'Basic Information'),
              _buildInfoCard(context, [
                _buildInfoRow(context, Icons.inventory_2, 'Product Name', product.name),
                _buildInfoRow(context, Icons.category, 'Category', product.category),
                _buildInfoRow(context, Icons.business, 'Manufacturer', product.manufacturer),
                _buildInfoRow(context, Icons.description, 'Description', product.description),
              ]),

              // Pricing & Stock
              _buildSectionTitle(context, 'Pricing & Stock'),
              _buildInfoCard(context, [
                _buildInfoRow(
                  context,
                  Icons.currency_rupee,
                  'Price per ${product.unit}',
                  CurrencyFormatter.formatCurrency(product.price),
                  valueColor: AppTheme.primaryBlue,
                ),
                _buildInfoRow(
                  context,
                  Icons.inventory,
                  'Current Stock',
                  '${product.currentStock} ${product.unit}',
                  valueColor: product.isLowStock ? AppTheme.warningOrange : AppTheme.secondaryBlue,
                ),
                _buildInfoRow(
                  context,
                  Icons.warning_amber,
                  'Minimum Stock',
                  '${product.minimumStock} ${product.unit}',
                ),
                _buildInfoRow(
                  context,
                  Icons.calculate,
                  'Total Value',
                  CurrencyFormatter.formatCurrency(product.price * product.currentStock),
                  valueColor: AppTheme.primaryBlue,
                ),
              ]),

              // Batch & Dates
              _buildSectionTitle(context, 'Batch & Dates'),
              _buildInfoCard(context, [
                if (product.batchNumber != null)
                  _buildInfoRow(context, Icons.numbers, 'Batch Number', product.batchNumber!),
                if (product.manufactureDate != null)
                  _buildInfoRow(
                    context,
                    Icons.calendar_today,
                    'Manufacture Date',
                    DateFormatter.formatDate(product.manufactureDate!),
                  ),
                _buildInfoRow(
                  context,
                  Icons.event_busy,
                  'Expiry Date',
                  DateFormatter.formatDate(product.expiryDate),
                  valueColor: product.isExpired
                      ? AppTheme.warningOrange
                      : product.isExpiringSoon
                      ? AppTheme.accentLightBlue
                      : null,
                ),
                _buildInfoRow(
                  context,
                  Icons.access_time,
                  'Days Until Expiry',
                  DateFormatter.getDaysUntilExpiry(product.expiryDate),
                  valueColor: product.isExpired
                      ? AppTheme.warningOrange
                      : product.isExpiringSoon
                      ? AppTheme.accentLightBlue
                      : AppTheme.secondaryBlue,
                ),
              ]),

              // System Information
              _buildSectionTitle(context, 'System Information'),
              _buildInfoCard(context, [
                _buildInfoRow(
                  context,
                  Icons.add_circle_outline,
                  'Created At',
                  DateFormatter.formatDateTime(product.createdAt),
                ),
                _buildInfoRow(
                  context,
                  Icons.update,
                  'Last Updated',
                  DateFormatter.formatDateTime(product.updatedAt),
                ),
                _buildInfoRow(
                  context,
                  Icons.check_circle,
                  'Status',
                  product.isActive ? 'Active' : 'Inactive',
                  valueColor: product.isActive ? AppTheme.secondaryBlue : AppTheme.warningOrange,
                ),
              ]),

              const SizedBox(height: 16),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Stock In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock In feature coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_downward),
                        label: const Text('Stock In'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.secondaryBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Stock Out Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Stock Out feature coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_upward),
                        label: const Text('Stock Out'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppTheme.accentLightBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // View Transactions Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaction history coming soon!'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text('View Transaction History'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            AppTheme.primaryBlue.withOpacity(0.8),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.category,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (product.isLowStock)
                _buildStatusChip('Low Stock', AppTheme.warningOrange),
              if (product.isExpired)
                _buildStatusChip('Expired', AppTheme.warningOrange)
              else if (product.isExpiringSoon)
                _buildStatusChip('Expiring Soon', AppTheme.accentLightBlue)
              else
                _buildStatusChip('In Stock', AppTheme.secondaryBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      BuildContext context,
      IconData icon,
      String label,
      String value, {
        Color? valueColor,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppTheme.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ProductBloc>().add(DeleteProduct(product.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningOrange,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}