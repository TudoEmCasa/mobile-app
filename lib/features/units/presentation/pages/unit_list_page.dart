import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/core/feedback/load_error_feedback_mixin.dart';
import 'package:tudo_em_casa/core/widgets/app_confirmation_bottom_sheet.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/data/providers/index.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/unit_form_page.dart';
import 'package:tudo_em_casa/features/units/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/features/units/presentation/widgets/index.dart';

class UnitListPage extends ConsumerStatefulWidget {
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
  ConsumerState<UnitListPage> createState() => _UnitListPageState();
}

class _UnitListPageState extends ConsumerState<UnitListPage>
    with LoadErrorFeedbackMixin {
  @override
  Widget build(BuildContext context) {
    final unitsAsync = ref.watch(watchAllUnitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectionMode ? widget.selectionTitle : 'Units'),
      ),
      body: unitsAsync.when(
        data: (units) {
          clearLoadErrorFeedback();

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
                selectable: widget.selectionMode,
                selected: unit.id == widget.selectedUnitId,
                onSelected: widget.selectionMode
                    ? (selectedUnit) => Navigator.of(context).pop(selectedUnit)
                    : null,
                onEdit: () => _navigateToUnitForm(context, unit),
                onDelete: () => _handleDeleteUnit(context, ref, unit),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          showLoadErrorFeedback('Failed to load units');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  'Failed to load units',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToUnitForm(context),
        tooltip: 'Add Unit',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToUnitForm(
    BuildContext context, [
    UnitModel? unit,
  ]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => UnitFormPage(unit: unit)),
    );

    if (saved == true && context.mounted) {
      AppSnackbar.success(
        context,
        unit == null ? 'Unit created' : 'Unit updated',
      );
    }
  }

  Future<void> _handleDeleteUnit(
    BuildContext context,
    WidgetRef ref,
    UnitModel unit,
  ) async {
    final shouldDelete = await showAppConfirmationBottomSheet(
      context: context,
      title: 'Delete Unit?',
      message: 'Delete "${unit.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(unitListViewModelProvider);
      await viewModel.deleteUnit(unit.id);
      if (context.mounted) {
        AppSnackbar.success(context, 'Unit removed');
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, 'Failed to delete unit');
      }
    }
  }
}
