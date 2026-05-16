import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/category_list_page.dart';
import 'package:tudo_em_casa/features/management/presentation/widgets/management_option_card.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_list_page.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/unit_list_page.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Management',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Manage application structure',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ManagementOptionCard(
                      icon: Icons.category_outlined,
                      title: 'Categories',
                      subtitle: 'Manage product organization',
                      onTap: () => _navigateToCategories(context),
                    ),
                    const SizedBox(height: 12),
                    ManagementOptionCard(
                      icon: Icons.inventory_2_outlined,
                      title: 'Product Types',
                      subtitle: 'Manage available product types',
                      onTap: () => _navigateToProductTypes(context),
                    ),
                    const SizedBox(height: 12),
                    ManagementOptionCard(
                      icon: Icons.straighten_outlined,
                      title: 'Units',
                      subtitle: 'Manage measurement units',
                      onTap: () => _navigateToUnits(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategoryListPage()),
    );
  }

  void _navigateToProductTypes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductTypeListPage()),
    );
  }

  void _navigateToUnits(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UnitListPage()),
    );
  }
}
