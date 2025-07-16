class DashboardStats {
  final int totalWarehouses;
  final int totalUsers;
  final int totalProducts;
  final int totalCategories;
  final int activeOrganizations;
  final double totalStockValue;
  final int lowStockItems;
  final int outOfStockItems;

  DashboardStats({
    required this.totalWarehouses,
    required this.totalUsers,
    required this.totalProducts,
    required this.totalCategories,
    required this.activeOrganizations,
    required this.totalStockValue,
    required this.lowStockItems,
    required this.outOfStockItems,
  });
}

class RecentActivity {
  final String id;
  final String title;
  final String description;
  final String type;
  final String timestamp;
  final String user;

  RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    required this.user,
  });
}

class ChartData {
  final String label;
  final double value;
  final String color;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
