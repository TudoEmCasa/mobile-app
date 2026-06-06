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
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class UnitListPage extends ConsumerStatefulWidget {
  final bool selectionMode;
  final String? selectionTitle;
  final int? selectedUnitId;

  const UnitListPage({
    super.key,
    this.selectionMode = false,
    this.selectionTitle,
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
        title: Text(
          widget.selectionMode
              ? widget.selectionTitle ?? context.l10n.text('selectUnit')
              : context.l10n.text('units'),
        ),
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
          showLoadErrorFeedback(context.l10n.text('failedToLoadUnits'));

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
                const SizedBox(height: 16),
                Text(
                  context.l10n.text('failedToLoadUnits'),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToUnitForm(context),
        tooltip: context.l10n.text('addUnit'),
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
        unit == null
            ? context.l10n.text('unitCreated')
            : context.l10n.text('unitUpdated'),
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
      title: context.l10n.text('deleteUnitTitle'),
      message: context.l10n.withName('deleteNamedEntityMessage', unit.name),
      confirmLabel: context.l10n.text('delete'),
      cancelLabel: context.l10n.text('cancel'),
      isDangerous: true,
    );

    if (!shouldDelete || !context.mounted) {
      return;
    }

    try {
      final viewModel = ref.read(unitListViewModelProvider);
      await viewModel.deleteUnit(unit.id);
      if (context.mounted) {
        AppSnackbar.success(context, context.l10n.text('unitRemoved'));
      }
    } catch (error) {
      if (context.mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToDeleteUnit'));
      }
    }
  }
}
