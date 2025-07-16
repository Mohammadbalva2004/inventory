import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/common/common_data_table.dart';
import 'package:inventory/models/supplier.dart';
import 'package:inventory/providers/app_theme.dart';

class SupplierListScreen extends StatefulWidget {
  final Function(String, {Supplier? supplier})? onNavigate;

  const SupplierListScreen({super.key, this.onNavigate});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<Supplier> suppliers = [];
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSuppliers();
  }

  Future<void> fetchSuppliers({String search = ''}) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final url =
          search.trim().isNotEmpty
              ? 'http://192.168.0.160:8080/api/v1/supplier/suppliers?search=$search'
              : 'http://192.168.0.160:8080/api/v1/supplier';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          suppliers = jsonData.map((e) => Supplier.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load suppliers';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateSupplierStatus(String id, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.0.160:8080/api/v1/supplier/$id/$newStatus'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        fetchSuppliers();
      } else {
        throw Exception(
          'Failed to update status. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      bool? confirmDelete = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Delete'),
              content: const Text(
                'Are you sure you want to delete this supplier?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
      );

      if (confirmDelete == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        final response = await http.delete(
          Uri.parse('http://192.168.0.160:8080/api/v1/supplier/$supplierId'),
        );

        Navigator.of(context).pop();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Supplier deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
          fetchSuppliers();
        } else {
          throw Exception(
            'Failed to delete supplier. Status: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting supplier: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Supplier List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => fetchSuppliers(search: value),
                      decoration: InputDecoration(
                        hintText: 'Search Suppliers...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            searchController.clear();
                            fetchSuppliers();
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => widget.onNavigate?.call('/supplier/add'),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Supplier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : errorMessage != null
                        ? Center(child: Text("Server Error"))
                        : buildSupplierTable(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSupplierTable() {
    return Column(
      children: [
        Expanded(
          child: CommonDataTable(
            columnTitles: [
              'Shop Name',
              'GST Number',
              'Phone Number',
              'Address',
              'Status',
            ],
            hasActions: true,
            rowCells:
                suppliers.map((supplier) {
                  final isActive = supplier.status == 'ACTIVE';
                  return [
                    Text(supplier.supplierShopName ?? ''),
                    Text(supplier.supplierGstNo ?? ''),
                    Text(supplier.phoneNumber ?? ''),
                    Text(supplier.locationOrArea ?? ''),
                    Switch(
                      value: isActive,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      onChanged: (value) {
                        final newStatus = value ? 'ACTIVE' : 'INACTIVE';
                        updateSupplierStatus(
                          supplier.supplierId ?? '',
                          newStatus,
                        );
                      },
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            try {
                              final response = await http.get(
                                Uri.parse(
                                  'http://192.168.0.160:8080/api/v1/supplier/${supplier.supplierId}',
                                ),
                              );
                              if (response.statusCode == 200) {
                                final jsonData = jsonDecode(response.body);
                                final fullSupplier = Supplier.fromJson(
                                  jsonData,
                                );
                                widget.onNavigate?.call(
                                  '/supplier/edit',
                                  supplier: fullSupplier,
                                );
                              } else {
                                throw Exception('Failed to fetch supplier');
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed:
                              () => deleteSupplier(supplier.supplierId ?? ''),
                        ),
                      ],
                    ),
                  ];
                }).toList(),
          ),
        ),
      ],
    );
  }
}
