import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/product.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product; // null for add, non-null for edit

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _manufacturerController;
  late TextEditingController _priceController;
  late TextEditingController _currentStockController;
  late TextEditingController _minimumStockController;
  late TextEditingController _batchNumberController;

  String _selectedCategory = AppConstants.productCategories[0];
  String _selectedUnit = AppConstants.units[0];
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  DateTime? _manufactureDate;

  bool get isEditMode => widget.product != null;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (isEditMode) {
      final product = widget.product!;
      _nameController = TextEditingController(text: product.name);
      _descriptionController = TextEditingController(text: product.description);
      _manufacturerController = TextEditingController(text: product.manufacturer);
      _priceController = TextEditingController(text: product.price.toString());
      _currentStockController = TextEditingController(text: product.currentStock.toString());
      _minimumStockController = TextEditingController(text: product.minimumStock.toString());
      _batchNumberController = TextEditingController(text: product.batchNumber ?? '');
      _selectedCategory = product.category;
      _selectedUnit = product.unit;
      _expiryDate = product.expiryDate;
      _manufactureDate = product.manufactureDate;
    } else {
      _nameController = TextEditingController();
      _descriptionController = TextEditingController();
      _manufacturerController = TextEditingController();
      _priceController = TextEditingController();
      _currentStockController = TextEditingController(text: '0');
      _minimumStockController = TextEditingController(text: '10');
      _batchNumberController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _manufacturerController.dispose();
    _priceController.dispose();
    _currentStockController.dispose();
    _minimumStockController.dispose();
    _batchNumberController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final product = Product(
        id: isEditMode ? widget.product!.id : _uuid.v4(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        description: _descriptionController.text.trim(),
        manufacturer: _manufacturerController.text.trim(),
        price: double.parse(_priceController.text),
        currentStock: int.parse(_currentStockController.text),
        minimumStock: int.parse(_minimumStockController.text),
        unit: _selectedUnit,
        expiryDate: _expiryDate,
        manufactureDate: _manufactureDate,
        batchNumber: _batchNumberController.text.trim().isEmpty
            ? null
            : _batchNumberController.text.trim(),
        createdAt: isEditMode ? widget.product!.createdAt : now,
        updatedAt: now,
        isActive: true,
      );

      if (isEditMode) {
        context.read<ProductBloc>().add(UpdateProduct(id: product.id, product: product));
      } else {
        context.read<ProductBloc>().add(AddProduct(product));
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isExpiryDate) async {
    final initialDate = isExpiryDate ? _expiryDate : (_manufactureDate ?? DateTime.now());
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isExpiryDate
          ? DateTime.now()
          : DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() {
        if (isExpiryDate) {
          _expiryDate = picked;
        } else {
          _manufactureDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Product' : 'Add Product'),
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
            Navigator.pop(context, true); // Return true to indicate success
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.warningOrange,
              ),
            );
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            final isLoading = state is ProductLoading;

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Product Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                      hintText: 'Enter product name',
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter product name';
                      }
                      if (value.trim().length < AppConstants.minProductNameLength) {
                        return 'Name must be at least ${AppConstants.minProductNameLength} characters';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: AppConstants.productCategories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Enter product description',
                      prefixIcon: Icon(Icons.description),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Manufacturer
                  TextFormField(
                    controller: _manufacturerController,
                    decoration: const InputDecoration(
                      labelText: 'Manufacturer *',
                      hintText: 'Enter manufacturer name',
                      prefixIcon: Icon(Icons.business),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter manufacturer';
                      }
                      return null;
                    },
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Price and Unit
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price *',
                            hintText: '0.00',
                            prefixText: '₹ ',
                            prefixIcon: Icon(Icons.currency_rupee),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final price = double.tryParse(value);
                            if (price == null || price < AppConstants.minPrice) {
                              return 'Invalid price';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          decoration: const InputDecoration(
                            labelText: 'Unit *',
                          ),
                          items: AppConstants.units.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: isLoading
                              ? null
                              : (value) {
                            setState(() {
                              _selectedUnit = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Current Stock and Minimum Stock
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _currentStockController,
                          decoration: const InputDecoration(
                            labelText: 'Current Stock *',
                            prefixIcon: Icon(Icons.inventory),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final stock = int.tryParse(value);
                            if (stock == null || stock < AppConstants.minStockQuantity) {
                              return 'Invalid';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _minimumStockController,
                          decoration: const InputDecoration(
                            labelText: 'Min Stock *',
                            prefixIcon: Icon(Icons.warning_amber),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            final stock = int.tryParse(value);
                            if (stock == null || stock < AppConstants.minStockQuantity) {
                              return 'Invalid';
                            }
                            return null;
                          },
                          enabled: !isLoading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Batch Number
                  TextFormField(
                    controller: _batchNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Batch Number (Optional)',
                      hintText: 'Enter batch number',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Manufacture Date
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
                      title: const Text('Manufacture Date (Optional)'),
                      subtitle: Text(
                        _manufactureDate != null
                            ? '${_manufactureDate!.day}/${_manufactureDate!.month}/${_manufactureDate!.year}'
                            : 'Not set',
                      ),
                      trailing: _manufactureDate != null
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: isLoading
                            ? null
                            : () {
                          setState(() {
                            _manufactureDate = null;
                          });
                        },
                      )
                          : const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: isLoading ? null : () => _selectDate(context, false),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expiry Date
                  Card(
                    color: AppTheme.accentCyan.withOpacity(0.1),
                    child: ListTile(
                      leading: const Icon(Icons.event_busy, color: AppTheme.accentLightBlue),
                      title: const Text('Expiry Date *'),
                      subtitle: Text(
                        '${_expiryDate.day}/${_expiryDate.month}/${_expiryDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: isLoading ? null : () => _selectDate(context, true),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _saveProduct,
                    icon: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : Icon(isEditMode ? Icons.update : Icons.add),
                    label: Text(isEditMode ? 'Update Product' : 'Add Product'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel Button
                  if (isLoading)
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}