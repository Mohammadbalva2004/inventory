import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/warehouse.dart';

class WarehouseApiService {
  static const String baseUrl = 'http://192.168.0.160:8080/api/v1/WareHouse';

  // Get all warehouses
  static Future<List<Warehouse>> getAllWarehouses() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Warehouse.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load warehouses. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error loading warehouses: $e');
    }
  }

  // Search warehouses
  static Future<List<Warehouse>> searchWarehouses(String searchTerm) async {
    try {
      final url = '$baseUrl/wareHouse?search=$searchTerm';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Warehouse.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to search warehouses. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error searching warehouses: $e');
    }
  }

  // Get warehouse by ID
  static Future<Warehouse> getWarehouseById(String warehouseId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$warehouseId'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return Warehouse.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to fetch warehouse. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching warehouse: $e');
    }
  }

  // Add new warehouse
  static Future<bool> addWarehouse(Map<String, dynamic> warehouseData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(warehouseData),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error adding warehouse: $e');
    }
  }

  // Update warehouse
  static Future<bool> updateWarehouse(
    String warehouseId,
    Map<String, dynamic> warehouseData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$warehouseId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(warehouseData),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating warehouse: $e');
    }
  }

  // Update warehouse status
  static Future<bool> updateWarehouseStatus(
    String warehouseId,
    String newStatus,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/$warehouseId/$newStatus'),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating warehouse status: $e');
    }
  }

  // Delete warehouse
  static Future<bool> deleteWarehouse(String warehouseId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$warehouseId'));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error deleting warehouse: $e');
    }
  }
}
