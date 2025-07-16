import 'package:flutter/material.dart';
import 'package:inventory/models/category.dart';
import 'package:inventory/models/purchase.dart';
import 'package:inventory/models/stock.dart';
import 'package:inventory/models/supplier.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/models/warehouse.dart';
import 'package:inventory/screens/add_supplier_screen.dart';
import 'package:inventory/screens/category/add_category_screen.dart';
import 'package:inventory/screens/category/category_list_screen.dart';
import 'package:inventory/screens/dashboard/dashboard_content.dart';
import 'package:inventory/screens/organization/add_organization_screen.dart';
import 'package:inventory/screens/organization/organization_list_screen.dart';
import 'package:inventory/screens/product/add_product_screen.dart';
import 'package:inventory/screens/product/product_list_screen.dart';
import 'package:inventory/screens/purchase/add_purchase_screen.dart';
import 'package:inventory/screens/purchase/purchase_list_screen.dart';
import 'package:inventory/screens/stock/add_stock_screen.dart';
import 'package:inventory/screens/stock/stock_list_screen.dart';
import 'package:inventory/screens/supplier/supplier_list_screen.dart';
import 'package:inventory/screens/user/add_user_screen.dart';
import 'package:inventory/screens/user/user_list_screen.dart';
import 'package:inventory/screens/warehouse/add_warehouse_screen.dart';
import 'package:inventory/screens/warehouse/warehouse_list_screen.dart';
import 'package:inventory/widgets/custom_app_bar.dart';
import 'package:inventory/widgets/custom_sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String currentRoute = '/dashboard';
  bool isSidebarCollapsed = false;

  Warehouse? selectedWarehouse;
  Supplier? selectedSupplier;
  Purchase? selectedPurchase;
  String? selectedPurchaseId;
  Category? selectedCategory;

  void _navigateToRoute(
    String route, {
    Warehouse? warehouse,
    Supplier? supplier,
    Category? category,
    Stock? stock,
    User? user,
    Purchase? purchase,
    String? purchaseId,
  }) {
    setState(() {
      currentRoute = route;
      selectedWarehouse = warehouse;
      selectedSupplier = supplier;
      selectedPurchase = purchase;
      selectedCategory = category;
      selectedPurchaseId = purchaseId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: CustomAppBar(
        title: _getPageTitle(),
        onMenuTap: () {
          setState(() {
            isSidebarCollapsed = !isSidebarCollapsed;
          });
        },
      ),
      body: Row(
        children: [
          if (isDesktop)
            CustomSidebar(
              currentRoute: currentRoute,
              isCollapsed: isSidebarCollapsed,
              onMenuTap: (route) {
                _navigateToRoute(route);
              },
              onToggleCollapse: () {
                setState(() {
                  isSidebarCollapsed = !isSidebarCollapsed;
                });
              },
            ),
          if (isDesktop) const VerticalDivider(width: 1),
          Expanded(child: _buildCurrentScreen()),
        ],
      ),
      drawer:
          !isDesktop
              ? CustomSidebar(
                currentRoute: currentRoute,
                isCollapsed: false,
                onMenuTap: (route) {
                  _navigateToRoute(route);
                  Navigator.of(context).pop();
                },
                onToggleCollapse: () {},
              )
              : null,
    );
  }

  String _getPageTitle() {
    switch (currentRoute) {
      case '/dashboard':
        return 'Dashboard';
      case '/warehouse/list':
        return 'Warehouse List';
      case '/warehouse/add':
      case '/warehouse/edit':
        return 'Add/Edit Warehouse';
      case '/user/list':
        return 'User List';
      case '/user/add':
        return 'Add User';
      case '/stock/list':
        return 'Stock List';
      case '/stock/add':
        return 'Add Stock';
      case '/category/list':
        return 'Category List';
      case '/category/add':
        return 'Add Category';
      case '/category/edit':
        return 'Edit category';
      case '/product/list':
        return 'Product List';
      case '/product/add':
        return 'Add Product';
      case '/organization/list':
        return 'Organization List';
      case '/organization/add':
        return 'Add Organization';
      case '/supplier/list':
        return 'Supplier List';
      case '/supplier/add':
      case '/supplier/edit':
        return 'Add/Edit Supplier';
      case '/purchase/list':
        return 'Purchase List';
      case '/purchase/add':
        return 'Add Purchase';
      case '/purchase/edit':
        return 'Edit Purchase';
      case '/logout':
        return 'Logout';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildCurrentScreen() {
    switch (currentRoute) {
      case '/dashboard':
        return DashboardContent(onNavigate: _navigateToRoute);
      case '/warehouse/list':
        return WarehouseListScreen(onNavigate: _navigateToRoute);
      case '/warehouse/add':
        return AddWarehouseScreen(onNavigate: _navigateToRoute);
      case '/warehouse/edit':
        return AddWarehouseScreen(
          isEditMode: true,
          warehouse: selectedWarehouse,
          onNavigate: _navigateToRoute,
        );
      case '/user/list':
        return UserListScreen(onNavigate: _navigateToRoute);
      case '/user/add':
        return AddUserScreen(onNavigate: _navigateToRoute);
      case '/stock/list':
        return StockListScreen(onNavigate: _navigateToRoute);
      case '/stock/add':
        return AddStockScreen(onNavigate: _navigateToRoute);
      case '/category/list':
        return CategoryListScreen(onNavigate: _navigateToRoute);
      case '/category/add':
        return AddCategoryScreen(onNavigate: _navigateToRoute);
      case '/category/edit':
        return AddCategoryScreen(
          isEditMode: true,
          category: selectedCategory,
          onNavigate: _navigateToRoute,
        );

      case '/product/list':
        return const ProductListScreen();
      case '/product/add':
        return const AddProductScreen();
      case '/organization/list':
        return const OrganizationListScreen();
      case '/organization/add':
        return const AddOrganizationScreen();
      case '/supplier/list':
        return SupplierListScreen(onNavigate: _navigateToRoute);
      case '/supplier/add':
        return AddSupplierScreen(onNavigate: _navigateToRoute);
      case '/supplier/edit':
        return AddSupplierScreen(
          isEditMode: true,
          supplier: selectedSupplier,
          onNavigate: _navigateToRoute,
        );
      case '/purchase/list':
        return PurchaseListScreen(onNavigate: _navigateToRoute);
      case '/purchase/add':
        return AddPurchaseScreen(onNavigate: _navigateToRoute);
      case '/purchase/edit':
        return AddPurchaseScreen(
          isEditMode: true,
          //purchase: selectedPurchase,
          purchaseId: selectedPurchaseId,
          onNavigate: _navigateToRoute,
        );
      case '/logout':
        return const LogoutScreen();
      default:
        return DashboardContent(onNavigate: _navigateToRoute);
    }
  }
}

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Logout',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text('Are you sure you want to logout?'),
        ],
      ),
    );
  }
}
