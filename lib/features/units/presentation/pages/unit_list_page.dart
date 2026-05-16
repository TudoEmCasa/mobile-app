import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/providers/index.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/unit_form_page.dart';
import 'package:tudo_em_casa/features/units/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/units/presentation/widgets/index.dart';

class UnitListPage extends ConsumerWidget {
  final bool selectionMode;
  final String selectionTitle;
  final int? selectedUnitId;

  const UnitListPage({
    super.key,
    this.selectionMode = false,
    this.selectionTitle = 'Select Unit',
    this.selectedUnitId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsAsync = ref.watch(watchAllUnitsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(selectionMode ? selectionTitle : 'Units')),
      body: unitsAsync.when(
        data: (units) {
          if (units.isEmpty) {
            return EmptyUnitsWidget(
              onCreatePressed: () => _navigateToUnitForm(context),
            );
          }

          return ListView.builder(
            itemCount: units.length,
            itemBuilder: (context, index) {
              final unit = units[index];
              return UnitItemWidget(
                unit: unit,
                selectable: selectionMode,
                selected: unit.id == selectedUnitId,
                onSelected: selectionMode
                    ? (selectedUnit) => Navigator.of(context).pop(selectedUnit)
                    : null,
                onEdit: selectionMode
                    ? null
                    : () => _navigateToUnitForm(context, unit),
                onDelete: selectionMode
                    ? null
                    : () => _handleDeleteUnit(context, ref, unit),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
              const SizedBox(height: 16),
              Text(
                'Error loading units',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: selectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => _navigateToUnitForm(context),
              tooltip: 'Add Unit',
              child: const Icon(Icons.add),
            ),
    );
  }

  void _navigateToUnitForm(BuildContext context, [UnitModel? unit]) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => UnitFormPage(unit: unit)));
  }

  void _handleDeleteUnit(BuildContext context, WidgetRef ref, UnitModel unit) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Unit?'),
          content: Text('Delete "${unit.name}"? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  final viewModel = ref.read(unitListViewModelProvider);
                  await viewModel.deleteUnit(unit.id);
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting unit: $error')),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
