import 'package:flutter/widgets.dart';
import 'package:tudo_em_casa/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

extension AppLocalizationsLookup on AppLocalizations {
  String text(String key) {
    return switch (key) {
      'appTitle' => appTitle,
      'products' => products,
      'management' => management,
      'managementSubtitle' => managementSubtitle,
      'settings' => settings,
      'categories' => categories,
      'categoriesManagementSubtitle' => categoriesManagementSubtitle,
      'productTypes' => productTypes,
      'productTypesManagementSubtitle' => productTypesManagementSubtitle,
      'units' => units,
      'unitsManagementSubtitle' => unitsManagementSubtitle,
      'lots' => lots,
      'create' => create,
      'update' => update,
      'edit' => edit,
      'delete' => delete,
      'cancel' => cancel,
      'confirm' => confirm,
      'unknown' => unknown,
      'selectCategory' => selectCategory,
      'selectProductType' => selectProductType,
      'selectUnit' => selectUnit,
      'failedToLoadCategories' => failedToLoadCategories,
      'failedToLoadProductTypes' => failedToLoadProductTypes,
      'failedToLoadUnits' => failedToLoadUnits,
      'failedToLoadProducts' => failedToLoadProducts,
      'failedToLoadProduct' => failedToLoadProduct,
      'failedToLoadLots' => failedToLoadLots,
      'addCategory' => addCategory,
      'addProductType' => addProductType,
      'addUnit' => addUnit,
      'addProduct' => addProduct,
      'addLot' => addLot,
      'categoryCreated' => categoryCreated,
      'categoryUpdated' => categoryUpdated,
      'categoryRemoved' => categoryRemoved,
      'productTypeCreated' => productTypeCreated,
      'productTypeUpdated' => productTypeUpdated,
      'productTypeRemoved' => productTypeRemoved,
      'unitCreated' => unitCreated,
      'unitUpdated' => unitUpdated,
      'unitRemoved' => unitRemoved,
      'productCreated' => productCreated,
      'productUpdated' => productUpdated,
      'productRemoved' => productRemoved,
      'lotCreated' => lotCreated,
      'lotUpdated' => lotUpdated,
      'lotRemoved' => lotRemoved,
      'deleteCategoryTitle' => deleteCategoryTitle,
      'deleteProductTypeTitle' => deleteProductTypeTitle,
      'deleteUnitTitle' => deleteUnitTitle,
      'deleteProductTitle' => deleteProductTitle,
      'deleteLotTitle' => deleteLotTitle,
      'deleteLotMessage' => deleteLotMessage,
      'failedToDeleteCategory' => failedToDeleteCategory,
      'failedToDeleteProductType' => failedToDeleteProductType,
      'failedToDeleteUnit' => failedToDeleteUnit,
      'failedToDeleteProduct' => failedToDeleteProduct,
      'failedToDeleteLot' => failedToDeleteLot,
      'createCategory' => createCategory,
      'editCategory' => editCategory,
      'categoryName' => categoryName,
      'categoryNameHint' => categoryNameHint,
      'categoryNameRequired' => categoryNameRequired,
      'failedToSaveCategory' => failedToSaveCategory,
      'noCategoriesYet' => noCategoriesYet,
      'createCategoryEmptyMessage' => createCategoryEmptyMessage,
      'createProductType' => createProductType,
      'editProductType' => editProductType,
      'productTypeName' => productTypeName,
      'productTypeNameHint' => productTypeNameHint,
      'productTypeNameRequired' => productTypeNameRequired,
      'categoryRequired' => categoryRequired,
      'failedToSaveProductType' => failedToSaveProductType,
      'noProductTypesYet' => noProductTypesYet,
      'createProductTypeEmptyMessage' => createProductTypeEmptyMessage,
      'categoryLabel' => categoryLabel,
      'selectCategoryLower' => selectCategoryLower,
      'createUnit' => createUnit,
      'editUnit' => editUnit,
      'unitName' => unitName,
      'unitLabel' => unitLabel,
      'unitNameHint' => unitNameHint,
      'unitSymbol' => unitSymbol,
      'unitSymbolHint' => unitSymbolHint,
      'unitNameRequired' => unitNameRequired,
      'unitSymbolRequired' => unitSymbolRequired,
      'failedToSaveUnit' => failedToSaveUnit,
      'noUnitsYet' => noUnitsYet,
      'createUnitEmptyMessage' => createUnitEmptyMessage,
      'createProduct' => createProduct,
      'editProduct' => editProduct,
      'productName' => productName,
      'productTypeLabel' => productTypeLabel,
      'selectProductTypeLower' => selectProductTypeLower,
      'productNameRequired' => productNameRequired,
      'productTypeRequired' => productTypeRequired,
      'failedToSaveProduct' => failedToSaveProduct,
      'noProductsYet' => noProductsYet,
      'createProductEmptyMessage' => createProductEmptyMessage,
      'productDetails' => productDetails,
      'productNotFound' => productNotFound,
      'inventoryTrackedPerLot' => inventoryTrackedPerLot,
      'addLotLower' => addLotLower,
      'noLotsRegistered' => noLotsRegistered,
      'noExpirationDate' => noExpirationDate,
      'editProductTooltip' => editProductTooltip,
      'deleteProductTooltip' => deleteProductTooltip,
      'createLot' => createLot,
      'editLot' => editLot,
      'quantity' => quantity,
      'quantityMustBeGreaterThanZero' => quantityMustBeGreaterThanZero,
      'unitRequired' => unitRequired,
      'failedToSaveLot' => failedToSaveLot,
      'selectUnitLower' => selectUnitLower,
      'selectExpirationDate' => selectExpirationDate,
      'noLotsYet' => noLotsYet,
      'createLotEmptyMessage' => createLotEmptyMessage,
      'unitsFallback' => unitsFallback,
      'noExpiration' => noExpiration,
      'addQuantity' => addQuantity,
      'useQuantity' => useQuantity,
      'editLotTooltip' => editLotTooltip,
      'deleteLotTooltip' => deleteLotTooltip,
      'enterQuantity' => enterQuantity,
      'enterValidQuantity' => enterValidQuantity,
      'insufficientQuantity' => insufficientQuantity,
      'consumeQuantity' => consumeQuantity,
      'quantityToUse' => quantityToUse,
      'quantityToAdd' => quantityToAdd,
      'remaining' => remaining,
      'newTotal' => newTotal,
      'lotFallback' => lotFallback,
      'useAll' => useAll,
      'appearance' => appearance,
      'systemTheme' => systemTheme,
      'lightTheme' => lightTheme,
      'darkTheme' => darkTheme,
      'language' => language,
      'portugueseLanguage' => portugueseLanguage,
      'englishLanguage' => englishLanguage,
      'dataManagement' => dataManagement,
      'importData' => importData,
      'importDataSubtitle' => importDataSubtitle,
      'exportData' => exportData,
      'exportDataSubtitle' => exportDataSubtitle,
      'importCanceled' => importCanceled,
      'exportCanceled' => exportCanceled,
      'importConfirmationMessage' => importConfirmationMessage,
      'backupImportedSuccessfully' => backupImportedSuccessfully,
      'failedToRestoreLocalDatabase' => failedToRestoreLocalDatabase,
      'backupExportedSuccessfully' => backupExportedSuccessfully,
      'failedToExportBackup' => failedToExportBackup,
      'about' => about,
      'versionLabel' => versionLabel,
      'licenses' => licenses,
      'licensesSubtitle' => licensesSubtitle,
      'exportDataBackupDialogTitle' => exportDataBackupDialogTitle,
      'importDataBackupDialogTitle' => importDataBackupDialogTitle,
      'failedToExportData' => failedToExportData,
      'backupDataCorrupted' => backupDataCorrupted,
      'invalidBackupFile' => invalidBackupFile,
      'unsupportedBackupVersion' => unsupportedBackupVersion,
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withName(String key, String name) {
    return switch (key) {
      'deleteNamedEntityMessage' => deleteNamedEntityMessage(name),
      'categoryWithName' => categoryWithName(name),
      'productTypeWithName' => productTypeWithName(name),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withDate(String key, String date) {
    return switch (key) {
      'expiresWithDate' => expiresWithDate(date),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withCount(String key, int count) {
    return switch (key) {
      'lotsCount' => lotsCount(count),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withQuantity(String key, String quantity) {
    return switch (key) {
      'quantityUsed' => quantityUsed(quantity),
      'quantityAdded' => quantityAdded(quantity),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withQuantityAndUnit(String key, String quantity, String unit) {
    return switch (key) {
      'currentQuantity' => currentQuantity(quantity, unit),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withPreview(String key, String label, String quantity, String unit) {
    return switch (key) {
      'previewQuantity' => previewQuantity(label, quantity, unit),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }

  String withLabel(String key, String label) {
    return switch (key) {
      'emptyPreviewQuantity' => emptyPreviewQuantity(label),
      _ => throw ArgumentError.value(key, 'key', 'Unknown localization key'),
    };
  }
}
