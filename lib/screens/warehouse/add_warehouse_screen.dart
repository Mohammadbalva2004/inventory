// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:inventory/models/warehouse.dart';
// import 'package:inventory/providers/app_theme.dart';

// class AddWarehouseScreen extends StatefulWidget {
//   final bool isEditMode;
//   final Warehouse? warehouse;
//   final Function(String)? onNavigate;

//   const AddWarehouseScreen({
//     super.key,
//     this.isEditMode = false,
//     this.onNavigate,
//     this.warehouse,
//   });

//   @override
//   State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
// }

// class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _idController = TextEditingController();
//   final _titleController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _descriptionController = TextEditingController();
//   String? _selectedType;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.isEditMode && widget.warehouse != null) {
//       _loadForm(widget.warehouse!);
//     }
//   }

//   void _loadForm(Warehouse warehouse) {
//     _idController.text = warehouse.organizationId;
//     _titleController.text = warehouse.title;
//     _locationController.text = warehouse.locationOrArea;
//     _descriptionController.text = warehouse.description;
//     _selectedType = warehouse.type;
//   }

//   Future<void> postWarehouse() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     final url = Uri.parse(
//       widget.isEditMode
//           ? 'http://192.168.0.160:8080/api/v1/WareHouse/${widget.warehouse!.wareHouseId}'
//           : 'http://192.168.0.160:8080/api/v1/WareHouse/register',
//     );

//     final warehouseData = {
//       'organizationId': _idController.text.trim(),
//       'title': _titleController.text.trim(),
//       'locationOrArea': _locationController.text.trim(),
//       'type': _selectedType,
//       'description': _descriptionController.text.trim(),
//     };

//     try {
//       final response =
//           widget.isEditMode
//               ? await http.put(
//                 url,
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(warehouseData),
//               )
//               : await http.post(
//                 url,
//                 headers: {'Content-Type': 'application/json'},
//                 body: jsonEncode(warehouseData),
//               );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               widget.isEditMode
//                   ? 'Warehouse updated successfully!'
//                   : 'Warehouse added successfully!',
//             ),
//             backgroundColor: Colors.green,
//           ),
//         );
//         widget.onNavigate?.call('/warehouse/list');
//       } else {
//         throw Exception('Failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _clearForm() {
//     _idController.clear();
//     _titleController.clear();
//     _locationController.clear();
//     _descriptionController.clear();
//     setState(() => _selectedType = null);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(24.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               if (widget.isEditMode)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.arrow_back,
//                     color: AppTheme.primaryBlue,
//                   ),
//                   onPressed: () => widget.onNavigate?.call('/warehouse/list'),
//                 ),
//               Text(
//                 widget.isEditMode ? 'Edit Warehouse' : 'Add Warehouse',
//                 style: const TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: AppTheme.darkGray,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 24),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _idController,
//                               enabled: !widget.isEditMode,
//                               decoration: InputDecoration(
//                                 labelText: 'Organization ID',
//                                 border: const OutlineInputBorder(),
//                                 filled: widget.isEditMode,
//                                 fillColor:
//                                     widget.isEditMode ? Colors.grey[100] : null,
//                               ),
//                               validator:
//                                   (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Enter Organization ID'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: TextFormField(
//                               controller: _locationController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Location',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator:
//                                   (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Enter location'
//                                           : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: TextFormField(
//                               controller: _titleController,
//                               decoration: const InputDecoration(
//                                 labelText: 'Warehouse Title',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator:
//                                   (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Enter title'
//                                           : null,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: DropdownButtonFormField<String>(
//                               value: _selectedType,
//                               items: const [
//                                 DropdownMenuItem(
//                                   value: 'SHOP',
//                                   child: Text('SHOP'),
//                                 ),
//                                 DropdownMenuItem(
//                                   value: 'WAREHOUSE',
//                                   child: Text('WAREHOUSE'),
//                                 ),
//                               ],
//                               onChanged:
//                                   (val) => setState(() => _selectedType = val),
//                               decoration: const InputDecoration(
//                                 labelText: 'Type',
//                                 border: OutlineInputBorder(),
//                               ),
//                               validator:
//                                   (val) => val == null ? 'Select a type' : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _descriptionController,
//                         maxLines: 3,
//                         decoration: const InputDecoration(
//                           labelText: 'Description',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton(
//                               onPressed:
//                                   _isLoading
//                                       ? null
//                                       : () {
//                                         if (_formKey.currentState!.validate()) {
//                                           postWarehouse();
//                                         }
//                                       },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppTheme.primaryBlue,
//                                 foregroundColor: Colors.white,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                 ),
//                               ),
//                               child:
//                                   _isLoading
//                                       ? const SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                 Colors.white,
//                                               ),
//                                         ),
//                                       )
//                                       : Text(
//                                         widget.isEditMode
//                                             ? 'Update Warehouse'
//                                             : 'Add Warehouse',
//                                       ),
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           OutlinedButton(
//                             onPressed:
//                                 _isLoading
//                                     ? null
//                                     : () {
//                                       widget.isEditMode
//                                           ? widget.onNavigate?.call(
//                                             '/warehouse/list',
//                                           )
//                                           : _clearForm();
//                                     },
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: AppTheme.primaryBlue,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 32,
//                                 vertical: 12,
//                               ),
//                             ),
//                             child: Text(
//                               widget.isEditMode ? 'Cancel' : 'Clear Form',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:inventory/api/warehouse_api.dart';
import 'package:inventory/models/warehouse.dart';
import 'package:inventory/providers/app_theme.dart';

class AddWarehouseScreen extends StatefulWidget {
  final bool isEditMode;
  final Warehouse? warehouse;
  final Function(String)? onNavigate;

  const AddWarehouseScreen({
    super.key,
    this.isEditMode = false,
    this.onNavigate,
    this.warehouse,
  });

  @override
  State<AddWarehouseScreen> createState() => _AddWarehouseScreenState();
}

class _AddWarehouseScreenState extends State<AddWarehouseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.warehouse != null) {
      _loadForm(widget.warehouse!);
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadForm(Warehouse warehouse) {
    _idController.text = warehouse.organizationId;
    _titleController.text = warehouse.title;
    _locationController.text = warehouse.locationOrArea;
    _descriptionController.text = warehouse.description;
    _selectedType = warehouse.type;
  }

  Future<void> _saveWarehouse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final warehouseData = {
      'organizationId': _idController.text.trim(),
      'title': _titleController.text.trim(),
      'locationOrArea': _locationController.text.trim(),
      'type': _selectedType,
      'description': _descriptionController.text.trim(),
    };

    try {
      bool success;
      if (widget.isEditMode) {
        success = await WarehouseApiService.updateWarehouse(
          widget.warehouse!.wareHouseId,
          warehouseData,
        );
      } else {
        success = await WarehouseApiService.addWarehouse(warehouseData);
      }

      if (success) {
        _showSuccessMessage();
        widget.onNavigate?.call('/warehouse/list');
      } else {
        _showErrorMessage(
          'Failed to ${widget.isEditMode ? 'update' : 'add'} warehouse',
        );
      }
    } catch (e) {
      _showErrorMessage(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.isEditMode
              ? 'Warehouse updated successfully!'
              : 'Warehouse added successfully!',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
    );
  }

  void _clearForm() {
    _idController.clear();
    _titleController.clear();
    _locationController.clear();
    _descriptionController.clear();
    setState(() => _selectedType = null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          Expanded(child: _buildFormContainer()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (widget.isEditMode)
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.primaryBlue),
            onPressed: () => widget.onNavigate?.call('/warehouse/list'),
          ),
        Text(
          widget.isEditMode ? 'Edit Warehouse' : 'Add Warehouse',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
      ],
    );
  }

  Widget _buildFormContainer() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              const SizedBox(height: 16),
              _buildFirstRow(),
              const SizedBox(height: 16),
              _buildSecondRow(),
              const SizedBox(height: 16),
              _buildThirdRow(),
              const SizedBox(height: 16),
              _buildFourthRow(),
              const SizedBox(height: 16),
              _buildDescriptionField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _idController,
            enabled: !widget.isEditMode,
            decoration: InputDecoration(
              labelText: 'Organization ID',
              border: const OutlineInputBorder(),
              filled: widget.isEditMode,
              fillColor: widget.isEditMode ? Colors.grey[100] : null,
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Enter Organization ID'
                        : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter location' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildThirdRow() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Warehouse Title',
              border: OutlineInputBorder(),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty ? 'Enter title' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildFourthRow() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedType,
            items: const [
              DropdownMenuItem(value: 'SHOP', child: Text('SHOP')),
              DropdownMenuItem(value: 'WAREHOUSE', child: Text('WAREHOUSE')),
            ],
            onChanged: (val) => setState(() => _selectedType = val),
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val == null ? 'Select a type' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveWarehouse,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Text(
                      widget.isEditMode ? 'Update Warehouse' : 'Add Warehouse',
                    ),
          ),
        ),
        const SizedBox(width: 16),
        OutlinedButton(
          onPressed:
              _isLoading
                  ? null
                  : () {
                    widget.isEditMode
                        ? widget.onNavigate?.call('/warehouse/list')
                        : _clearForm();
                  },
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: Text(widget.isEditMode ? 'Cancel' : 'Clear Form'),
        ),
      ],
    );
  }
}
