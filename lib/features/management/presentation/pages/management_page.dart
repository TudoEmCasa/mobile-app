import 'package:flutter/material.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/category_list_page.dart';
import 'package:tudo_em_casa/features/management/presentation/widgets/management_option_card.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_list_page.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/unit_list_page.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

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
                context.l10n.text('management'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.text('managementSubtitle'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    ManagementOptionCard(
                      icon: Icons.category_outlined,
                      title: context.l10n.text('categories'),
                      subtitle: context.l10n.text(
                        'categoriesManagementSubtitle',
                      ),
                      onTap: () => _navigateToCategories(context),
                    ),
                    const SizedBox(height: 12),
                    ManagementOptionCard(
                      icon: Icons.inventory_2_outlined,
                      title: context.l10n.text('productTypes'),
                      subtitle: context.l10n.text(
                        'productTypesManagementSubtitle',
                      ),
                      onTap: () => _navigateToProductTypes(context),
                    ),
                    const SizedBox(height: 12),
                    ManagementOptionCard(
                      icon: Icons.straighten_outlined,
                      title: context.l10n.text('units'),
                      subtitle: context.l10n.text('unitsManagementSubtitle'),
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
