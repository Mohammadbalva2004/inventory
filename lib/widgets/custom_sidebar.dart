import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../theme/app_theme.dart';

class CustomSidebar extends StatefulWidget {
  final String currentRoute;
  final bool isCollapsed;
  final Function(String) onMenuTap;
  final VoidCallback onToggleCollapse;

  const CustomSidebar({
    super.key,
    required this.currentRoute,
    required this.isCollapsed,
    required this.onMenuTap,
    required this.onToggleCollapse,
  });

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar>
    with SingleTickerProviderStateMixin {
  String? expandedItem;
  late AnimationController _animationController;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 250.0, end: 70.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CustomSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _animationController.forward();
        setState(() {
          expandedItem = null;
        });
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _widthAnimation,
      builder: (context, child) {
        final width = widget.isCollapsed ? 70.0 : 250.0;
        return Container(
          width: width,
          color: Colors.white,
          child: Column(
            children: [
              _buildHeader(),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: MenuData.getMenuItems().length,
                  itemBuilder: (context, index) {
                    final menuItem = MenuData.getMenuItems()[index];
                    return _buildMenuItem(menuItem);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child:
          widget.isCollapsed
              ? Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Colors.white,
                  size: 24,
                ),
              )
              : Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Inventory',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    final bool isSelected = widget.currentRoute.startsWith(item.route);
    final bool hasSubItems = item.subItems != null && item.subItems!.isNotEmpty;
    final bool isExpanded = expandedItem == item.title && !widget.isCollapsed;

    return Column(
      children: [
        Material(
          color: isSelected ? AppTheme.lightBlue : Colors.transparent,
          child: InkWell(
            onTap: () {
              if (widget.isCollapsed) {
                widget.onToggleCollapse();
              } else {
                if (hasSubItems) {
                  setState(() {
                    expandedItem = isExpanded ? null : item.title;
                  });
                } else {
                  widget.onMenuTap(item.route);
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child:
                  widget.isCollapsed
                      ? Tooltip(
                        message: item.title,
                        child: Icon(
                          item.icon,
                          color:
                              isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.darkGray,
                          size: 20,
                        ),
                      )
                      : Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Icon click should collapse sidebar
                              widget.onToggleCollapse();
                            },
                            child: Icon(
                              item.icon,
                              color:
                                  isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.darkGray,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                // Text click should navigate
                                if (hasSubItems) {
                                  setState(() {
                                    expandedItem =
                                        isExpanded ? null : item.title;
                                  });
                                } else {
                                  widget.onMenuTap(item.route);
                                }
                              },
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? AppTheme.primaryBlue
                                          : AppTheme.darkGray,
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          if (hasSubItems)
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color:
                                  isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.darkGray,
                              size: 20,
                            ),
                        ],
                      ),
            ),
          ),
        ),
        if (hasSubItems && isExpanded && !widget.isCollapsed)
          ...item.subItems!.map((subItem) => _buildSubMenuItem(subItem)),
      ],
    );
  }

  Widget _buildSubMenuItem(MenuItem subItem) {
    final bool isSelected = widget.currentRoute == subItem.route;

    return Material(
      color: isSelected ? AppTheme.lightBlue : Colors.transparent,
      child: InkWell(
        onTap: () => widget.onMenuTap(subItem.route),
        child: Container(
          padding: const EdgeInsets.only(
            left: 52,
            right: 20,
            top: 8,
            bottom: 8,
          ),
          child: Row(
            children: [
              Icon(
                subItem.icon,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGray,
                size: 16,
              ),
              const SizedBox(width: 12),
              Text(
                subItem.title,
                style: TextStyle(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.darkGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
