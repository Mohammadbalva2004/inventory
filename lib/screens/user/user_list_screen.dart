import 'package:flutter/material.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/providers/app_theme.dart';

class UserListScreen extends StatefulWidget {
  final void Function(String route, {User? user})? onNavigate;
  const UserListScreen({super.key, this.onNavigate});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStaticUsers();
  }

  void _loadStaticUsers() {
    users = [
      User(
        name: 'Alice Johnson',
        email: 'alice@example.com',
        role: 'Manager',
        department: 'Sales',
        phone: '9876543210',
        status: 'ACTIVE',
      ),
      User(
        name: 'Bob Smith',
        email: 'bob@example.com',
        role: 'Staff',
        department: 'HR',
        phone: '9123456780',
        status: 'INACTIVE',
      ),
      User(
        name: 'Charlie Davis',
        email: 'charlie@example.com',
        role: 'Admin',
        department: 'IT',
        phone: '9012345678',
        status: 'ACTIVE',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final List<User> filteredUsers =
        users
            .where(
              (user) =>
                  user.name.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ||
                  user.email.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ),
            )
            .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User List',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search Users...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
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
                      widget.onNavigate!('/user/add');
                    }
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add User'),
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
                child: _buildUserTable(filteredUsers),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTable(List<User> filteredUsers) {
    if (filteredUsers.isEmpty) {
      return const Center(child: Text('No Users Found'));
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Total Users: ${filteredUsers.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 40,
                headingRowHeight: 56,
                dataRowHeight: 72,
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Role')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows:
                    filteredUsers.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user.name)),
                          DataCell(Text(user.email)),
                          DataCell(Text(user.role)),
                          DataCell(Text(user.department)),
                          DataCell(Text(user.phone)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    user.status == 'ACTIVE'
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                user.status,
                                style: TextStyle(
                                  color:
                                      user.status == 'ACTIVE'
                                          ? Colors.green.shade800
                                          : Colors.red.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: AppTheme.primaryBlue,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Edit user')),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
