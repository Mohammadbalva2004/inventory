import 'package:flutter/material.dart';
import 'package:inventory/models/stock.dart';
import 'package:inventory/providers/app_theme.dart';

class StockListScreen extends StatefulWidget {
  final void Function(String route, {Stock? stock})? onNavigate;

  const StockListScreen({super.key, this.onNavigate});

  @override
  State<StockListScreen> createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  List<Stock> stocks = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  Future<void> fetchStocks() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        stocks = [
          Stock(
            id: '1',
            productName: 'Laptop Dell XPS',
            category: 'Electronics',
            warehouse: 'Main Warehouse',
            quantity: 25,
            price: 75000.0,
            status: 'IN_STOCK',
            lastUpdated: '2024-01-15',
          ),
          Stock(
            id: '2',
            productName: 'Office Chair',
            category: 'Furniture',
            warehouse: 'North Zone',
            quantity: 5,
            price: 8500.0,
            status: 'LOW_STOCK',
            lastUpdated: '2024-01-14',
          ),
          Stock(
            id: '3',
            productName: 'Printer HP LaserJet',
            category: 'Electronics',
            warehouse: 'South Zone',
            quantity: 0,
            price: 15000.0,
            status: 'OUT_OF_STOCK',
            lastUpdated: '2024-01-13',
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading stocks: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray,
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: searchController,

                      decoration: InputDecoration(
                        hintText: 'Search Stocks...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            searchController.clear();
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
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.onNavigate != null) {
                      widget.onNavigate!('/stock/add');
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Stock'),
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
                        : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 40,
                              headingRowHeight: 56,
                              dataRowHeight: 72,
                              columns: const [
                                DataColumn(
                                  label: Text(
                                    'Product Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Category',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Warehouse',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Quantity',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Price',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Last Updated',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              rows:
                                  stocks.map((stock) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(stock.productName)),
                                        DataCell(Text(stock.category)),
                                        DataCell(Text(stock.warehouse)),
                                        DataCell(
                                          Text(stock.quantity.toString()),
                                        ),
                                        DataCell(
                                          Text(
                                            '₹${stock.price.toStringAsFixed(2)}',
                                          ),
                                        ),
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(
                                                stock.status,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              stock.status.replaceAll('_', ' '),
                                              style: TextStyle(
                                                color: _getStatusColor(
                                                  stock.status,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(stock.lastUpdated)),
                                      ],
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'IN_STOCK':
        return Colors.green.shade800;
      case 'LOW_STOCK':
        return Colors.orange.shade800;
      case 'OUT_OF_STOCK':
        return Colors.red.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}
