import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/models/purchase.dart';
import 'package:inventory/providers/app_theme.dart';

class AddPurchaseScreen extends StatefulWidget {
  final String? purchaseId;
  final Function(String route)? onNavigate;
  final bool isEditMode;

  const AddPurchaseScreen({
    super.key,
    this.onNavigate,
    this.purchaseId,
    this.isEditMode = false,
  });

  @override
  State<AddPurchaseScreen> createState() => _AddPurchaseScreenState();
}

class _AddPurchaseScreenState extends State<AddPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productIdController = TextEditingController();
  final TextEditingController _supplierIdController = TextEditingController();
  final TextEditingController _billImageController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _paidAmountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _paymentType;

  final List<String> _paymentTypes = ['CASH', 'UPI', 'CHEQUE', 'BANK'];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.purchaseId != null) {
      fetchPurchaseById(widget.purchaseId!);
    }
  }

  void _loadForm(Purchase p) {
    _productIdController.text = p.productId ?? '';
    _supplierIdController.text = p.supplierId ?? '';
    _billImageController.text = p.billImage ?? '';
    _totalAmountController.text = p.totalAmount?.toString() ?? '';
    _paidAmountController.text = p.paidAmount?.toString() ?? '';
    _paymentType = p.paymentType;
    _descriptionController.text = p.description ?? '';
  }

  Future<void> fetchPurchaseById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.160:8080/api/v1/purchase/$id'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final p = Purchase.fromJson(data);
        _loadForm(p);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load purchase: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> addpurchase() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final purchaseData = {
      "productId": _productIdController.text,
      "supplierId": _supplierIdController.text,
      "billImage": _billImageController.text,
      "totalAmount": double.parse(_totalAmountController.text),
      "paidAmount": double.parse(_paidAmountController.text),
      "paymentType": _paymentType,
      "description": _descriptionController.text,
    };

    final isEdit = widget.purchaseId != null;
    final url =
        isEdit
            ? 'http://192.168.0.160:8080/api/v1/purchase/${widget.purchaseId}'
            : 'http://192.168.0.160:8080/api/v1/purchase/add';

    try {
      final response =
          await (isEdit
              ? http.put(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(purchaseData),
              )
              : http.post(
                Uri.parse(url),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode(purchaseData),
              ));

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEdit
                  ? 'Purchase updated successfully!'
                  : 'Purchase added successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        widget.onNavigate?.call('/purchase/list');
      } else {
        throw Exception('Server responded with ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString().replaceAll("Exception: ", "")}'),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _clearForm() {
    _productIdController.clear();
    _supplierIdController.clear();
    _billImageController.clear();
    _totalAmountController.clear();
    _paidAmountController.clear();
    _descriptionController.clear();
    setState(() => _paymentType = null);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.purchaseId != null;

    return Scaffold(
      body: Expanded(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? 'Edit Purchase' : 'Add Purchase',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _productIdController,
                          decoration: const InputDecoration(
                            labelText: 'Product ID',
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter product ID' : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _supplierIdController,
                          decoration: const InputDecoration(
                            labelText: 'Supplier ID',
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter supplier ID' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _billImageController,
                          decoration: const InputDecoration(
                            labelText: 'Bill Image URL',
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _totalAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Amount',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter total amount';
                            if (double.tryParse(value) == null)
                              return 'Enter valid number';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _paidAmountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Paid Amount'),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Enter paid amount';
                      if (double.tryParse(value) == null)
                        return 'Enter valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _paymentType,
                    items:
                        _paymentTypes.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                    onChanged: (value) => setState(() => _paymentType = value),
                    decoration: const InputDecoration(
                      labelText: 'Payment Type',
                    ),
                    validator:
                        (value) => value == null ? 'Select payment type' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : addpurchase,
                          icon:
                              _isSubmitting
                                  ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Icon(isEdit ? Icons.edit : Icons.add),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              isEdit ? 'Update Purchase' : 'Add Purchase',
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: _isSubmitting ? null : _clearForm,
                        child: const Text('Clear Form'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
