import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/models/category.dart';
import 'package:inventory/providers/app_theme.dart';

class AddCategoryScreen extends StatefulWidget {
  final bool isEditMode;
  final Category? category;
  final Function(String route)? onNavigate;

  const AddCategoryScreen({
    super.key,
    this.category,
    this.onNavigate,
    this.isEditMode = false,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _organizationIdController = TextEditingController();
  final _parentCategoryIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.category != null) {
      _loadForm(widget.category!);
    }
  }

  void _loadForm(Category category) {
    _nameController.text = category.categoryName ?? '';
    _descriptionController.text = category.description ?? '';
    _organizationIdController.text = category.organizationId ?? '';
    _parentCategoryIdController.text = category.parentCategoryId ?? '';
  }

  Future<void> _submitCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final categoryData = {
      "categoryName": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "organizationId": _organizationIdController.text.trim(),
      "parentCategoryId":
          _parentCategoryIdController.text.trim().isEmpty
              ? null
              : _parentCategoryIdController.text.trim(),
    };

    final isEdit = widget.isEditMode && widget.category != null;
    final url =
        isEdit
            ? 'http://192.168.0.160:8080/api/v1/category/${widget.category!.id}'
            : 'http://192.168.0.160:8080/api/v1/category';

    try {
      final response =
          isEdit
              ? await http.put(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(categoryData),
              )
              : await http.post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(categoryData),
              );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Category updated successfully!'
                  : 'Category added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.onNavigate != null) {
          widget.onNavigate!('/category/list');
        }
      } else {
        throw Exception('Failed to ${isEdit ? 'update' : 'add'} category.');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _nameController.clear();
    _descriptionController.clear();
    _organizationIdController.clear();
    _parentCategoryIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.isEditMode;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isEdit)
                IconButton(
                  onPressed: () {
                    if (widget.onNavigate != null) {
                      widget.onNavigate!('/category/list');
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              Text(
                isEdit ? 'Edit Category' : 'Add Category',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
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
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildTextField(_nameController, 'Category Name'),
                      const SizedBox(height: 16),
                      _buildTextField(_descriptionController, 'Description'),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _organizationIdController,
                        'Organization ID',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _parentCategoryIdController,
                        'Parent Category ID',
                        validator: (value) => null,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitCategory,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child:
                                  _isLoading
                                      ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                      : Text(
                                        isEdit
                                            ? 'Update Category'
                                            : 'Add Category',
                                      ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed:
                                _isLoading
                                    ? null
                                    : () {
                                      isEdit
                                          ? widget.onNavigate?.call(
                                            '/category/list',
                                          )
                                          : _clearForm();
                                    },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: Text(isEdit ? 'Cancel' : 'Clear Form'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) =>
              value == null || value.trim().isEmpty
                  ? 'Please enter $label'
                  : null,
    );
  }
}
