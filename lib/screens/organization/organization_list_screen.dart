import 'package:flutter/material.dart';
import 'package:inventory/models/organization.dart';
import 'package:inventory/providers/app_theme.dart';

class OrganizationListScreen extends StatefulWidget {
  const OrganizationListScreen({super.key});

  @override
  State<OrganizationListScreen> createState() => _OrganizationListScreenState();
}

class _OrganizationListScreenState extends State<OrganizationListScreen> {
  List<Organization> organizations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      setState(() {
        organizations = [
          Organization(
            id: '1',
            name: 'Tech Solutions Pvt Ltd',
            address: '123 Business Park, Mumbai',
            contactPerson: 'Rajesh Kumar',
            email: 'contact@techsolutions.com',
            phone: '+91 9876543210',
            type: 'SUPPLIER',
            status: 'ACTIVE',
          ),
          Organization(
            id: '2',
            name: 'Global Retail Chain',
            address: '456 Commercial Street, Delhi',
            contactPerson: 'Priya Sharma',
            email: 'info@globalretail.com',
            phone: '+91 9876543211',
            type: 'CLIENT',
            status: 'ACTIVE',
          ),
          Organization(
            id: '3',
            name: 'Logistics Express',
            address: '789 Industrial Area, Bangalore',
            contactPerson: 'Amit Patel',
            email: 'support@logisticsexpress.com',
            phone: '+91 9876543212',
            type: 'PARTNER',
            status: 'INACTIVE',
          ),
        ];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading organizations: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Organization List',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              IconButton(
                onPressed: fetchOrganizations,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
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
              child: isLoading
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
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Address',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Contact Person',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Phone',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Type',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: organizations.map((org) {
                            return DataRow(
                              cells: [
                                DataCell(Text(org.name)),
                                DataCell(Text(org.address)),
                                DataCell(Text(org.contactPerson)),
                                DataCell(Text(org.email)),
                                DataCell(Text(org.phone)),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getTypeColor(org.type).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      org.type,
                                      style: TextStyle(
                                        color: _getTypeColor(org.type),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: org.status == 'ACTIVE'
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      org.status,
                                      style: TextStyle(
                                        color: org.status == 'ACTIVE'
                                            ? Colors.green.shade800
                                            : Colors.red.shade800,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
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
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'SUPPLIER':
        return Colors.blue.shade800;
      case 'CLIENT':
        return Colors.green.shade800;
      case 'PARTNER':
        return Colors.orange.shade800;
      default:
        return Colors.grey.shade800;
    }
  }
}
