import 'package:flutter/material.dart';
import 'package:inventory/models/dashboard_stats.dart';
import 'package:inventory/providers/app_theme.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardContent extends StatefulWidget {
  final Function(String)? onNavigate;
  const DashboardContent({super.key, this.onNavigate});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  DashboardStats? stats;
  List<ChartData> stockChartData = [];
  List<ChartData> categoryChartData = [];
  bool isLoading = true;
  int warehouseCount = 0;

  @override
  void initState() {
    super.initState();
    loadDashboardStats();
  }

  Future<void> loadDashboardStats() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.160:8080/api/v1/WareHouse/count'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();

        if (body.startsWith('{')) {
          final jsonData = jsonDecode(body);
          warehouseCount = jsonData['count'];
        } else {
          final regex = RegExp(r'\d+');
          final match = regex.firstMatch(body);
          warehouseCount = match != null ? int.parse(match.group(0)!) : 0;
        }
      } else {
        warehouseCount = 0;
      }
      stats = DashboardStats(
        totalWarehouses: warehouseCount,
        totalUsers: 45,
        totalProducts: 1250,
        totalCategories: 25,
        activeOrganizations: 18,
        totalStockValue: 2500000.0,
        lowStockItems: 15,
        outOfStockItems: 8,
      );

      stockChartData = [
        ChartData(label: 'In Stock', value: 75, color: '#10B981'),
        ChartData(label: 'Low Stock', value: 15, color: '#F59E0B'),
        ChartData(label: 'Out of Stock', value: 10, color: '#EF4444'),
      ];
    } catch (e) {
      debugPrint('Error loading dashboard: $e');

      stats = DashboardStats(
        totalWarehouses: 0,
        totalUsers: 45,
        totalProducts: 1250,
        totalCategories: 25,
        activeOrganizations: 18,
        totalStockValue: 2500000.0,
        lowStockItems: 15,
        outOfStockItems: 8,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading dashboard: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGray,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        loadDashboardStats();
                      },
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh Dashboard',
                    ),
                  ],
                ),
                Text(
                  'Welcome to Inventory Management System',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildStatsCards(),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 1200) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _buildChartsSection()),
                      const SizedBox(width: 24),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildChartsSection(),
                      const SizedBox(height: 24),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    if (stats == null) {
      return const Center(
        child: Text(
          "Failed to load stats",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = 4;
          if (constraints.maxWidth < 900) crossAxisCount = 3;
          if (constraints.maxWidth < 500) crossAxisCount = 2;
          if (constraints.maxWidth < 300) crossAxisCount = 1;

          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                'Total Warehouses',
                stats!.totalWarehouses.toString(),
                Icons.warehouse,
                Colors.blue,
              ),
              _buildStatCard(
                'Total Users',
                stats!.totalUsers.toString(),
                Icons.people,
                Colors.green,
              ),
              _buildStatCard(
                'Total Products',
                stats!.totalProducts.toString(),
                Icons.inventory,
                Colors.orange,
              ),
              _buildStatCard(
                'Categories',
                stats!.totalCategories.toString(),
                Icons.category,
                Colors.purple,
              ),
              _buildStatCard(
                'Organizations',
                stats!.activeOrganizations.toString(),
                Icons.business,
                Colors.teal,
              ),
              _buildStatCard(
                'Stock Value',
                '₹${(stats!.totalStockValue / 100000).toStringAsFixed(1)}L',
                Icons.currency_rupee,
                Colors.indigo,
              ),
              _buildStatCard(
                'Low Stock Items',
                stats!.lowStockItems.toString(),
                Icons.warning,
                Colors.amber,
              ),
              _buildStatCard(
                'Out of Stock',
                stats!.outOfStockItems.toString(),
                Icons.error,
                Colors.red,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Icon(Icons.trending_up, color: Colors.green, size: 16),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        Row(children: [Expanded(child: _buildStockChart())]),
        const SizedBox(height: 16),
        _buildInventoryTrend(),
      ],
    );
  }

  Widget _buildStockChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stock Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.75,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '75%',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      Text(
                        'In Stock',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...stockChartData.map(
            (data) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(data.color.substring(1), radix: 16) +
                            0xFF000000,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(data.label),
                  const Spacer(),
                  Text('${data.value.toInt()}%'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryTrend() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Trend (Last 7 Days)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarChart('Mon', 80),
                _buildBarChart('Tue', 65),
                _buildBarChart('Wed', 90),
                _buildBarChart('Thu', 75),
                _buildBarChart('Fri', 85),
                _buildBarChart('Sat', 70),
                _buildBarChart('Sun', 95),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(String day, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: value * 1.5,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkGray,
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionButton(
                        'Add Product',
                        Icons.add_box,
                        Colors.blue,
                        '/product',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Add User',
                        Icons.person_add,
                        Colors.green,
                        '/user',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        'Add Warehouse',
                        Icons.warehouse,
                        Colors.orange,
                        '/warehouse/add',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionButton(
                        'View Reports',
                        Icons.analytics,
                        Colors.purple,
                        '/reports',
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'Add Product',
                            Icons.add_box,
                            Colors.blue,
                            '/product',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            'Add User',
                            Icons.person_add,
                            Colors.green,
                            '/user',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickActionButton(
                            'Add Warehouse',
                            Icons.warehouse,
                            Colors.orange,
                            '/warehouse/add',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickActionButton(
                            'View Reports',
                            Icons.analytics,
                            Colors.purple,
                            '/reports',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    String title,
    IconData icon,
    Color color,
    String route,
  ) {
    return ElevatedButton(
      onPressed: () {
        if (widget.onNavigate != null) {
          widget.onNavigate!(route);
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$title clicked!')));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String label;
  final double value;
  final String color;

  ChartData({required this.label, required this.value, required this.color});
}
