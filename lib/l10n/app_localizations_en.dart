// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tudo em Casa';

  @override
  String get products => 'Products';

  @override
  String get management => 'Management';

  @override
  String get managementSubtitle => 'Manage application structure';

  @override
  String get settings => 'Settings';

  @override
  String get categories => 'Categories';

  @override
  String get categoriesManagementSubtitle => 'Manage product organization';

  @override
  String get productTypes => 'Product Types';

  @override
  String get productTypesManagementSubtitle => 'Manage available product types';

  @override
  String get units => 'Units';

  @override
  String get unitsManagementSubtitle => 'Manage measurement units';

  @override
  String get lots => 'Lots';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get unknown => 'Unknown';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get selectProductType => 'Select Product Type';

  @override
  String get selectUnit => 'Select Unit';

  @override
  String get failedToLoadCategories => 'Failed to load categories';

  @override
  String get failedToLoadProductTypes => 'Failed to load product types';

  @override
  String get failedToLoadUnits => 'Failed to load units';

  @override
  String get failedToLoadProducts => 'Failed to load products';

  @override
  String get failedToLoadProduct => 'Failed to load product';

  @override
  String get failedToLoadLots => 'Failed to load lots';

  @override
  String get addCategory => 'Add Category';

  @override
  String get addProductType => 'Add Product Type';

  @override
  String get addUnit => 'Add Unit';

  @override
  String get addProduct => 'Add Product';

  @override
  String get addLot => 'Add Lot';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get categoryUpdated => 'Category updated';

  @override
  String get categoryRemoved => 'Category removed';

  @override
  String get productTypeCreated => 'Product type created';

  @override
  String get productTypeUpdated => 'Product type updated';

  @override
  String get productTypeRemoved => 'Product type removed';

  @override
  String get unitCreated => 'Unit created';

  @override
  String get unitUpdated => 'Unit updated';

  @override
  String get unitRemoved => 'Unit removed';

  @override
  String get productCreated => 'Product created';

  @override
  String get productUpdated => 'Product updated';

  @override
  String get productRemoved => 'Product removed';

  @override
  String get lotCreated => 'Lot created';

  @override
  String get lotUpdated => 'Lot updated';

  @override
  String get lotRemoved => 'Lot removed';

  @override
  String get deleteCategoryTitle => 'Delete Category?';

  @override
  String get deleteProductTypeTitle => 'Delete Product Type?';

  @override
  String get deleteUnitTitle => 'Delete Unit?';

  @override
  String get deleteProductTitle => 'Delete Product?';

  @override
  String get deleteLotTitle => 'Delete Lot?';

  @override
  String deleteNamedEntityMessage(String name) {
    return 'Delete \"$name\"? This action cannot be undone.';
  }

  @override
  String get deleteLotMessage =>
      'Delete this lot? This action cannot be undone.';

  @override
  String get failedToDeleteCategory => 'Failed to delete category';

  @override
  String get failedToDeleteProductType => 'Failed to delete product type';

  @override
  String get failedToDeleteUnit => 'Failed to delete unit';

  @override
  String get failedToDeleteProduct => 'Failed to delete product';

  @override
  String get failedToDeleteLot => 'Failed to delete lot';

  @override
  String get createCategory => 'Create Category';

  @override
  String get editCategory => 'Edit Category';

  @override
  String get categoryName => 'Category name';

  @override
  String get categoryNameHint => 'e.g., Fruits, Vegetables';

  @override
  String get categoryNameRequired => 'Category name is required';

  @override
  String get failedToSaveCategory => 'Failed to save category';

  @override
  String get noCategoriesYet => 'No categories yet';

  @override
  String get createCategoryEmptyMessage => 'Create a category to get started';

  @override
  String get createProductType => 'Create Product Type';

  @override
  String get editProductType => 'Edit Product Type';

  @override
  String get productTypeName => 'Product type name';

  @override
  String get productTypeNameHint => 'e.g., Milk, Cheese';

  @override
  String get productTypeNameRequired => 'Product type name is required';

  @override
  String get categoryRequired => 'Category is required';

  @override
  String get failedToSaveProductType => 'Failed to save product type';

  @override
  String get noProductTypesYet => 'No product types yet';

  @override
  String get createProductTypeEmptyMessage =>
      'Create a product type to get started';

  @override
  String get categoryLabel => 'Category';

  @override
  String categoryWithName(String name) {
    return 'Category: $name';
  }

  @override
  String get selectCategoryLower => 'Select category';

  @override
  String get createUnit => 'Create Unit';

  @override
  String get editUnit => 'Edit Unit';

  @override
  String get unitName => 'Unit name';

  @override
  String get unitLabel => 'Unit';

  @override
  String get unitNameHint => 'e.g., Kilogram, Liter';

  @override
  String get unitSymbol => 'Symbol';

  @override
  String get unitSymbolHint => 'e.g., kg, L';

  @override
  String get unitNameRequired => 'Unit name is required';

  @override
  String get unitSymbolRequired => 'Unit symbol is required';

  @override
  String get failedToSaveUnit => 'Failed to save unit';

  @override
  String get noUnitsYet => 'No units yet';

  @override
  String get createUnitEmptyMessage => 'Create a unit to get started';

  @override
  String get createProduct => 'Create Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get productName => 'Product name';

  @override
  String get productTypeLabel => 'Product type';

  @override
  String get selectProductTypeLower => 'Select product type';

  @override
  String get productNameRequired => 'Product name is required';

  @override
  String get productTypeRequired => 'Product type is required';

  @override
  String get failedToSaveProduct => 'Failed to save product';

  @override
  String get noProductsYet => 'No products yet';

  @override
  String get createProductEmptyMessage =>
      'Create your first product catalog entry to get started.';

  @override
  String get productDetails => 'Product details';

  @override
  String get productNotFound => 'Product not found';

  @override
  String productTypeWithName(String name) {
    return 'Product type: $name';
  }

  @override
  String lotsCount(int count) {
    return 'Lots: $count';
  }

  @override
  String get inventoryTrackedPerLot => 'Inventory is tracked per lot below.';

  @override
  String get addLotLower => 'Add lot';

  @override
  String get noLotsRegistered => 'No lots registered';

  @override
  String get noExpirationDate => 'No expiration date';

  @override
  String get editProductTooltip => 'Edit product';

  @override
  String get deleteProductTooltip => 'Delete product';

  @override
  String get createLot => 'Create Lot';

  @override
  String get editLot => 'Edit Lot';

  @override
  String get quantity => 'Quantity';

  @override
  String get quantityMustBeGreaterThanZero =>
      'Quantity must be greater than zero';

  @override
  String get unitRequired => 'Unit is required';

  @override
  String get failedToSaveLot => 'Failed to save lot';

  @override
  String get selectUnitLower => 'Select unit';

  @override
  String get selectExpirationDate => 'Select expiration date';

  @override
  String get noLotsYet => 'No lots yet';

  @override
  String get createLotEmptyMessage =>
      'Add a lot to track quantities, units, and expiration dates.';

  @override
  String get unitsFallback => 'units';

  @override
  String get noExpiration => 'No expiration';

  @override
  String expiresWithDate(String date) {
    return 'Expires: $date';
  }

  @override
  String get addQuantity => 'Add quantity';

  @override
  String get useQuantity => 'Use quantity';

  @override
  String get editLotTooltip => 'Edit lot';

  @override
  String get deleteLotTooltip => 'Delete lot';

  @override
  String get enterQuantity => 'Enter a quantity';

  @override
  String get enterValidQuantity => 'Enter a valid quantity';

  @override
  String get insufficientQuantity => 'Insufficient quantity';

  @override
  String get consumeQuantity => 'Consume quantity';

  @override
  String get quantityToUse => 'Quantity to use';

  @override
  String get quantityToAdd => 'Quantity to add';

  @override
  String get remaining => 'Remaining';

  @override
  String get newTotal => 'New total';

  @override
  String get lotFallback => 'Lot';

  @override
  String currentQuantity(String quantity, String unit) {
    return 'Current: $quantity $unit';
  }

  @override
  String get useAll => 'Use all';

  @override
  String previewQuantity(String label, String quantity, String unit) {
    return '$label: $quantity $unit';
  }

  @override
  String emptyPreviewQuantity(String label) {
    return '$label: --';
  }

  @override
  String quantityUsed(String quantity) {
    return '$quantity used';
  }

  @override
  String quantityAdded(String quantity) {
    return '$quantity added';
  }

  @override
  String get appearance => 'Appearance';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get portugueseLanguage => 'Portuguese';

  @override
  String get englishLanguage => 'English';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get importData => 'Import Data';

  @override
  String get importDataSubtitle => 'Restore from a local JSON backup';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportDataSubtitle => 'Create a local JSON backup';

  @override
  String get importCanceled => 'Import canceled';

  @override
  String get exportCanceled => 'Export canceled';

  @override
  String get importConfirmationMessage =>
      'Importing a backup will replace current local data.';

  @override
  String get backupImportedSuccessfully => 'Backup imported successfully';

  @override
  String get failedToRestoreLocalDatabase => 'Failed to restore local database';

  @override
  String get backupExportedSuccessfully => 'Backup exported successfully';

  @override
  String get failedToExportBackup => 'Failed to export backup';

  @override
  String get about => 'About';

  @override
  String get versionLabel => 'Version 1.0.0';

  @override
  String get licenses => 'Licenses';

  @override
  String get licensesSubtitle => 'View open source licenses';

  @override
  String get exportDataBackupDialogTitle => 'Export data backup';

  @override
  String get importDataBackupDialogTitle => 'Import data backup';

  @override
  String get failedToExportData => 'Failed to export data.';

  @override
  String get backupDataCorrupted => 'Backup data is corrupted.';

  @override
  String get invalidBackupFile => 'Invalid backup file.';

  @override
  String get unsupportedBackupVersion => 'Unsupported backup version.';
}
