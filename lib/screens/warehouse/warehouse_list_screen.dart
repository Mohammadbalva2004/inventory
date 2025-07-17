// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:inventory/common/common_data_table.dart';
// import 'package:inventory/models/warehouse.dart';
// import 'package:inventory/providers/app_theme.dart';

// class WarehouseListScreen extends StatefulWidget {
//   final Function(String, {Warehouse? warehouse})? onNavigate;

//   const WarehouseListScreen({super.key, this.onNavigate});

//   @override
//   State<WarehouseListScreen> createState() => _WarehouseListScreenState();
// }

// class _WarehouseListScreenState extends State<WarehouseListScreen> {
//   List<Warehouse> warehouses = [];
//   bool isLoading = true;
//   String? errorMessage;
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchWarehouses();
//   }

//   Future<void> fetchWarehouses({String? search}) async {
//     try {
//       setState(() {
//         isLoading = true;
//         errorMessage = null;
//       });

//       final url =
//           (search != null && search.isNotEmpty)
//               ? 'http://192.168.0.160:8080/api/v1/WareHouse/wareHouse?search=$search'
//               : 'http://192.168.0.160:8080/api/v1/WareHouse';

//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         final List<dynamic> jsonList = jsonDecode(response.body);
//         setState(() {
//           warehouses =
//               jsonList.map((json) => Warehouse.fromJson(json)).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage =
//               'Failed to load warehouse data. Status: ${response.statusCode}';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error loading warehouses: $e';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> updateWarehouseStatus(String id, String newStatus) async {
//     try {
//       final response = await http.patch(
//         Uri.parse('http://192.168.0.160:8080/api/v1/WareHouse/$id/$newStatus'),
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Status updated to $newStatus'),
//             backgroundColor: Colors.green,
//           ),
//         );
//         fetchWarehouses(search: searchController.text);
//       } else {
//         throw Exception(
//           'Failed to update status. Status: ${response.statusCode}',
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error updating status: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> deleteWarehouse(String warehouseId) async {
//     try {
//       bool? confirmDelete = await showDialog<bool>(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: const Text('Confirm Delete'),
//             content: const Text(
//               'Are you sure you want to delete this warehouse?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(false),
//                 child: const Text('Cancel'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(true),
//                 style: TextButton.styleFrom(foregroundColor: Colors.red),
//                 child: const Text('Delete'),
//               ),
//             ],
//           );
//         },
//       );

//       if (confirmDelete == true) {
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return const Center(child: CircularProgressIndicator());
//           },
//         );

//         final response = await http.delete(
//           Uri.parse('http://192.168.0.160:8080/api/v1/WareHouse/$warehouseId'),
//         );

//         Navigator.of(context).pop();

//         if (response.statusCode == 200) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Warehouse deleted successfully'),
//               backgroundColor: Colors.green,
//             ),
//           );
//           fetchWarehouses(search: searchController.text);
//         } else {
//           throw Exception(
//             'Failed to delete warehouse. Status: ${response.statusCode}',
//           );
//         }
//       }
//     } catch (e) {
//       if (Navigator.of(context).canPop()) Navigator.of(context).pop();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error deleting warehouse: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Warehouse List',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppTheme.darkGray,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Expanded(
//                   child: SizedBox(
//                     height: 40,
//                     child: TextField(
//                       controller: searchController,
//                       onChanged: (value) => fetchWarehouses(search: value),
//                       decoration: InputDecoration(
//                         hintText: 'Search Warehouses...',
//                         prefixIcon: const Icon(Icons.search, size: 20),
//                         suffixIcon: IconButton(
//                           icon: const Icon(Icons.clear, size: 20),
//                           onPressed: () {
//                             searchController.clear();
//                             fetchWarehouses();
//                           },
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 12,
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 ElevatedButton.icon(
//                   onPressed: () => widget.onNavigate?.call('/warehouse/add'),
//                   icon: const Icon(Icons.add),
//                   label: const Text('Add Warehouse'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppTheme.primaryBlue,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       spreadRadius: 1,
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: _buildContent(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     if (isLoading) return const Center(child: CircularProgressIndicator());
//     if (errorMessage != null) return Center(child: Text(errorMessage!));
//     if (warehouses.isEmpty)
//       return const Center(child: Text('No Warehouses Found'));

//     return CommonDataTable(
//       columnTitles: [
//         'Organization ID',
//         'Location',
//         'Title',
//         'Description',
//         'Type',
//         'Status',
//       ],
//       hasActions: true,
//       rowCells:
//           warehouses.map((warehouse) {
//             return [
//               Text(warehouse.organizationId),
//               Text(warehouse.locationOrArea),
//               Text(warehouse.title),
//               Text(warehouse.description),
//               Text(warehouse.type),
//               Switch(
//                 value: warehouse.status == 'ACTIVE',
//                 activeColor: Colors.green,
//                 inactiveThumbColor: Colors.red,
//                 onChanged: (val) {
//                   updateWarehouseStatus(
//                     warehouse.wareHouseId,
//                     val ? 'ACTIVE' : 'INACTIVE',
//                   );
//                 },
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue),
//                     onPressed: () async {
//                       try {
//                         final response = await http.get(
//                           Uri.parse(
//                             'http://192.168.0.160:8080/api/v1/WareHouse/${warehouse.wareHouseId}',
//                           ),
//                         );
//                         if (response.statusCode == 200) {
//                           final jsonData = jsonDecode(response.body);
//                           final fullWarehouse = Warehouse.fromJson(jsonData);
//                           widget.onNavigate?.call(
//                             '/warehouse/edit',
//                             warehouse: fullWarehouse,
//                           );
//                         } else {
//                           throw Exception('Failed to fetch warehouse');
//                         }
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text('Error: $e'),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () => deleteWarehouse(warehouse.wareHouseId),
//                   ),
//                 ],
//               ),
//             ];
//           }).toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:inventory/api/warehouse_api.dart';
import 'package:inventory/common/common_data_table.dart';
import 'package:inventory/models/warehouse.dart';
import 'package:inventory/providers/app_theme.dart';

class WarehouseListScreen extends StatefulWidget {
  final Function(String, {Warehouse? warehouse})? onNavigate;

  const WarehouseListScreen({super.key, this.onNavigate});

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  List<Warehouse> warehouses = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWarehouses();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadWarehouses({String? search}) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      List<Warehouse> result;
      if (search != null && search.isNotEmpty) {
        result = await WarehouseApiService.searchWarehouses(search);
      } else {
        result = await WarehouseApiService.getAllWarehouses();
      }

      setState(() {
        warehouses = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _updateWarehouseStatus(String id, String newStatus) async {
    try {
      final success = await WarehouseApiService.updateWarehouseStatus(
        id,
        newStatus,
      );

      if (success) {
        _showSuccessMessage('Status updated to $newStatus');
        _loadWarehouses(search: searchController.text);
      } else {
        _showErrorMessage('Failed to update status');
      }
    } catch (e) {
      _showErrorMessage(e.toString());
    }
  }

  Future<void> _deleteWarehouse(String warehouseId) async {
    final confirmDelete = await _showDeleteConfirmation();

    if (confirmDelete == true) {
      _showLoadingDialog();

      try {
        final success = await WarehouseApiService.deleteWarehouse(warehouseId);
        Navigator.of(context).pop(); // Close loading dialog

        if (success) {
          _showSuccessMessage('Warehouse deleted successfully');
          _loadWarehouses(search: searchController.text);
        } else {
          _showErrorMessage('Failed to delete warehouse');
        }
      } catch (e) {
        Navigator.of(context).pop();
        _showErrorMessage(e.toString());
      }
    }
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
            'Are you sure you want to delete this warehouse?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message'), backgroundColor: Colors.red),
    );
  }

  Future<void> _editWarehouse(Warehouse warehouse) async {
    try {
      final fullWarehouse = await WarehouseApiService.getWarehouseById(
        warehouse.wareHouseId,
      );
      widget.onNavigate?.call('/warehouse/edit', warehouse: fullWarehouse);
    } catch (e) {
      _showErrorMessage(e.toString());
    }
  }

  void _clearSearch() {
    searchController.clear();
    _loadWarehouses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildSearchAndAddRow(),
            const SizedBox(height: 24),
            Expanded(child: _buildDataContainer()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Warehouse List',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppTheme.darkGray,
      ),
    );
  }

  Widget _buildSearchAndAddRow() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 12),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: searchController,
        onChanged: (value) => _loadWarehouses(search: value),
        decoration: InputDecoration(
          hintText: 'Search Warehouses...',
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: _clearSearch,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: () => widget.onNavigate?.call('/warehouse/add'),
      icon: const Icon(Icons.add),
      label: const Text('Add Warehouse'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDataContainer() {
    return Container(
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
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) return Center(child: Text(errorMessage!));
    if (warehouses.isEmpty)
      return const Center(child: Text('No Warehouses Found'));

    return _buildDataTable();
  }

  Widget _buildDataTable() {
    return CommonDataTable(
      columnTitles: [
        'Organization ID',
        'Location',
        'Title',
        'Description',
        'Type',
        'Status',
      ],
      hasActions: true,
      rowCells:
          warehouses.map((warehouse) => _buildTableRow(warehouse)).toList(),
    );
  }

  List<Widget> _buildTableRow(Warehouse warehouse) {
    return [
      Text(warehouse.organizationId),
      Text(warehouse.locationOrArea),
      Text(warehouse.title),
      Text(warehouse.description),
      Text(warehouse.type),
      _buildStatusSwitch(warehouse),
      _buildActionButtons(warehouse),
    ];
  }

  Widget _buildStatusSwitch(Warehouse warehouse) {
    return Switch(
      value: warehouse.status == 'ACTIVE',
      activeColor: Colors.green,
      inactiveThumbColor: Colors.red,
      onChanged: (val) {
        _updateWarehouseStatus(
          warehouse.wareHouseId,
          val ? 'ACTIVE' : 'INACTIVE',
        );
      },
    );
  }

  Widget _buildActionButtons(Warehouse warehouse) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _editWarehouse(warehouse),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteWarehouse(warehouse.wareHouseId),
        ),
      ],
    );
  }
}
