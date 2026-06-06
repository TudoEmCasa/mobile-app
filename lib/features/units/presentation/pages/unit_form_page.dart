import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/feedback/app_snackbar.dart';
import 'package:tudo_em_casa/features/units/data/models/index.dart';
import 'package:tudo_em_casa/features/units/presentation/viewmodels/index.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

class UnitFormPage extends ConsumerStatefulWidget {
  final UnitModel? unit;

  const UnitFormPage({super.key, this.unit});

  @override
  ConsumerState<UnitFormPage> createState() => _UnitFormPageState();
}

class _UnitFormPageState extends ConsumerState<UnitFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _symbolController;
  late FocusNode _nameFocus;
  bool _isSubmitting = false;

  bool get _isEditMode => widget.unit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: _isEditMode ? widget.unit!.name : '',
    );
    _symbolController = TextEditingController(
      text: _isEditMode ? widget.unit!.symbol : '',
    );
    _nameFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _symbolController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final symbol = _symbolController.text.trim();

    if (name.isEmpty) {
      AppSnackbar.error(context, context.l10n.text('unitNameRequired'));
      return;
    }

    if (symbol.isEmpty) {
      AppSnackbar.error(context, context.l10n.text('unitSymbolRequired'));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final viewModel = ref.read(unitListViewModelProvider);
      if (_isEditMode) {
        final updated = widget.unit!.copyWith(name: name, symbol: symbol);
        await viewModel.updateUnit(updated);
      } else {
        await viewModel.createUnit(name, symbol);
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (mounted) {
        AppSnackbar.error(context, context.l10n.text('failedToSaveUnit'));
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          _isEditMode
              ? context.l10n.text('editUnit')
              : context.l10n.text('createUnit'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  labelText: context.l10n.text('unitName'),
                  hintText: context.l10n.text('unitNameHint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _symbolController,
                enabled: !_isSubmitting,
                decoration: InputDecoration(
                  labelText: context.l10n.text('unitSymbol'),
                  hintText: context.l10n.text('unitSymbolHint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _isSubmitting ? null : _handleSave(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: keyboardInset),
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSave,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isEditMode
                          ? context.l10n.text('update')
                          : context.l10n.text('create'),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
