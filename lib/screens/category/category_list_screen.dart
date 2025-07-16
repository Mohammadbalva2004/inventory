import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/common/common_data_table.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/providers/app_theme.dart';

class CategoryListScreen extends StatefulWidget {
  final Function(String, {Category? category})? onNavigate;

  const CategoryListScreen({super.key, this.onNavigate});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  List<Category> categories = [];
  bool isLoading = true;
  String? errorMessage;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories({String? search}) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url =
          (search != null && search.isNotEmpty)
              ? 'http://192.168.0.160:8080/api/v1/category/categories?search=$search'
              : 'http://192.168.0.160:8080/api/v1/category';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        setState(() {
          categories = jsonData.map((e) => Category.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> updateCategoryStatus(String id, String newStatus) async {
    try {
      final response = await http.patch(
        Uri.parse('http://192.168.0.160:8080/api/v1/category/$id/$newStatus'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to $newStatus'),
            backgroundColor: Colors.green,
          ),
        );
        fetchCategories();
      } else {
        throw Exception('Status update failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> deleteCategory(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text(
              'Are you sure you want to delete this category?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.160:8080/api/v1/category/$id'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category deleted'),
            backgroundColor: Colors.green,
          ),
        );
        fetchCategories(search: searchController.text);
      } else {
        throw Exception('Failed to delete');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category List',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (value) => fetchCategories(search: value),
                  decoration: InputDecoration(
                    hintText: 'Search Categories...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        searchController.clear();
                        fetchCategories();
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => widget.onNavigate?.call('/category/add'),
                icon: const Icon(Icons.add),
                label: const Text('Add Category'),
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
                      ? Center(child: Text(errorMessage!))
                      : buildCategoryTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryTable() {
    return Column(
      children: [
        Expanded(
          child: CommonDataTable(
            columnTitles: [
              'Organization ID',
              'Parent Category ID',
              'Category Name',
              'Description',
              'Status',
            ],
            hasActions: true,
            rowCells:
                categories.map((category) {
                  final isActive = category.status == 'ACTIVE';
                  return [
                    Text(category.organizationId ?? ''),
                    Text(category.parentCategoryId ?? ''),
                    Text(category.categoryName ?? ''),
                    Text(category.description ?? ''),
                    Switch(
                      value: isActive,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      onChanged: (value) {
                        final newStatus = value ? 'ACTIVE' : 'INACTIVE';
                        updateCategoryStatus(category.id ?? '', newStatus);
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
                                  'http://192.168.0.160:8080/api/v1/category/${category.id}',
                                ),
                              );
                              if (response.statusCode == 200) {
                                final jsonData = jsonDecode(response.body);
                                final fullSupplier = Category.fromJson(
                                  jsonData,
                                );
                                widget.onNavigate?.call(
                                  '/category/edit',
                                  category: fullSupplier,
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
                          onPressed: () => deleteCategory(category.id ?? ''),
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
