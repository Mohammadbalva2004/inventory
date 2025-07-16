// import 'package:flutter/material.dart';

// class MenuItem {
//   final String title;
//   final IconData icon;
//   final String route;
//   final List<MenuItem>? subItems;

//   MenuItem({
//     required this.title,
//     required this.icon,
//     required this.route,
//     this.subItems,
//   });
// }

// class MenuData {
//   static List<MenuItem> getMenuItems() {
//     return [
//       MenuItem(title: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
//       MenuItem(
//         title: 'Warehouse',
//         icon: Icons.warehouse,
//         route: '/warehouse',
//         subItems: [
//           MenuItem(
//             title: 'Warehouse List',
//             icon: Icons.list,
//             route: '/warehouse/list',
//           ),
//           MenuItem(
//             title: 'Add Warehouse',
//             icon: Icons.add,
//             route: '/warehouse/add',
//           ),
//         ],
//       ),
//       MenuItem(title: 'User Management', icon: Icons.people, route: '/user'),
//       MenuItem(
//         title: 'Supplier Management',
//         icon: Icons.store,
//         route: '/supplier',
//         subItems: [
//           MenuItem(
//             title: 'Supplier List',
//             icon: Icons.list,
//             route: '/warehouse/list',
//           ),
//           MenuItem(
//             title: 'Add supplier',
//             icon: Icons.add,
//             route: '/warehouse/add',
//           ),
//         ],
//       ),

//       MenuItem(
//         title: 'Stock Management',
//         icon: Icons.inventory,
//         route: '/stock',
//       ),
//       MenuItem(title: 'Category', icon: Icons.category, route: '/category'),
//       MenuItem(title: 'Product', icon: Icons.shopping_cart, route: '/product'),
//       MenuItem(
//         title: 'Organization',
//         icon: Icons.business,
//         route: '/organization',
//       ),
//       MenuItem(title: 'Logout', icon: Icons.logout, route: '/logout'),
//     ];
//   }
// }
import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final IconData icon;
  final String route;
  final List<MenuItem>? subItems;

  MenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subItems,
  });
}

class MenuData {
  static List<MenuItem> getMenuItems() {
    return [
      MenuItem(title: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
      MenuItem(
        title: 'Warehouse',
        icon: Icons.warehouse,
        route: '/warehouse',
        subItems: [
          MenuItem(
            title: 'Warehouse List',
            icon: Icons.list,
            route: '/warehouse/list',
          ),
          MenuItem(
            title: 'Add Warehouse',
            icon: Icons.add,
            route: '/warehouse/add',
          ),
        ],
      ),

      MenuItem(
        title: 'Supplier', // New Supplier menu item
        icon: Icons.local_shipping,
        route: '/supplier',
        subItems: [
          MenuItem(
            title: 'Supplier List',
            icon: Icons.list,
            route: '/supplier/list',
          ),
          MenuItem(
            title: 'Add Supplier',
            icon: Icons.add,
            route: '/supplier/add',
          ),
        ],
      ),

      MenuItem(
        title: 'Purchase',
        icon: Icons.receipt,
        route: '/purchase',
        subItems: [
          MenuItem(
            title: 'Purchase List',
            icon: Icons.list,
            route: '/purchase/list',
          ),
          MenuItem(
            title: 'Add Purchase',
            icon: Icons.add,
            route: '/purchase/add',
          ),
        ],
      ),

      MenuItem(
        title: 'Category',
        icon: Icons.category,
        route: '/category',
        subItems: [
          MenuItem(
            title: 'Category List',
            icon: Icons.list,
            route: '/category/list',
          ),
          MenuItem(
            title: 'Add Category',
            icon: Icons.add,
            route: '/category/add',
          ),
        ],
      ),

      MenuItem(
        title: 'User Management',
        icon: Icons.people,
        route: '/user',
        subItems: [
          MenuItem(title: 'User List', icon: Icons.list, route: '/user/list'),
          MenuItem(
            title: 'Add User',
            icon: Icons.person_add,
            route: '/user/add',
          ),
        ],
      ),
      MenuItem(
        title: 'Stock Management',
        icon: Icons.inventory,
        route: '/stock',
        subItems: [
          MenuItem(title: 'Stock List', icon: Icons.list, route: '/stock/list'),
          MenuItem(title: 'Add Stock', icon: Icons.add, route: '/stock/add'),
        ],
      ),
      MenuItem(
        title: 'Category',
        icon: Icons.category,
        route: '/category',
        subItems: [
          MenuItem(
            title: 'Category List',
            icon: Icons.list,
            route: '/category/list',
          ),
          MenuItem(
            title: 'Add Category',
            icon: Icons.add,
            route: '/category/add',
          ),
        ],
      ),
      MenuItem(
        title: 'Product',
        icon: Icons.shopping_cart,
        route: '/product',
        subItems: [
          MenuItem(
            title: 'Product List',
            icon: Icons.list,
            route: '/product/list',
          ),
          MenuItem(
            title: 'Add Product',
            icon: Icons.add,
            route: '/product/add',
          ),
        ],
      ),
      MenuItem(
        title: 'Organization',
        icon: Icons.business,
        route: '/organization',
        subItems: [
          MenuItem(
            title: 'Organization List',
            icon: Icons.list,
            route: '/organization/list',
          ),
          MenuItem(
            title: 'Add Organization',
            icon: Icons.add,
            route: '/organization/add',
          ),
        ],
      ),

      MenuItem(title: 'Logout', icon: Icons.logout, route: '/logout'),
    ];
  }
}
