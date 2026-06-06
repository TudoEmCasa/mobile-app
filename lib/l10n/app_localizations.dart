import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tudo em Casa'**
  String get appTitle;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @management.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get management;

  /// No description provided for @managementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage application structure'**
  String get managementSubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @categoriesManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage product organization'**
  String get categoriesManagementSubtitle;

  /// No description provided for @productTypes.
  ///
  /// In en, this message translates to:
  /// **'Product Types'**
  String get productTypes;

  /// No description provided for @productTypesManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage available product types'**
  String get productTypesManagementSubtitle;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @unitsManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage measurement units'**
  String get unitsManagementSubtitle;

  /// No description provided for @lots.
  ///
  /// In en, this message translates to:
  /// **'Lots'**
  String get lots;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @selectProductType.
  ///
  /// In en, this message translates to:
  /// **'Select Product Type'**
  String get selectProductType;

  /// No description provided for @selectUnit.
  ///
  /// In en, this message translates to:
  /// **'Select Unit'**
  String get selectUnit;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @failedToLoadProductTypes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product types'**
  String get failedToLoadProductTypes;

  /// No description provided for @failedToLoadUnits.
  ///
  /// In en, this message translates to:
  /// **'Failed to load units'**
  String get failedToLoadUnits;

  /// No description provided for @failedToLoadProducts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load products'**
  String get failedToLoadProducts;

  /// No description provided for @failedToLoadProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to load product'**
  String get failedToLoadProduct;

  /// No description provided for @failedToLoadLots.
  ///
  /// In en, this message translates to:
  /// **'Failed to load lots'**
  String get failedToLoadLots;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @addProductType.
  ///
  /// In en, this message translates to:
  /// **'Add Product Type'**
  String get addProductType;

  /// No description provided for @addUnit.
  ///
  /// In en, this message translates to:
  /// **'Add Unit'**
  String get addUnit;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @addLot.
  ///
  /// In en, this message translates to:
  /// **'Add Lot'**
  String get addLot;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created'**
  String get categoryCreated;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryUpdated;

  /// No description provided for @categoryRemoved.
  ///
  /// In en, this message translates to:
  /// **'Category removed'**
  String get categoryRemoved;

  /// No description provided for @productTypeCreated.
  ///
  /// In en, this message translates to:
  /// **'Product type created'**
  String get productTypeCreated;

  /// No description provided for @productTypeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product type updated'**
  String get productTypeUpdated;

  /// No description provided for @productTypeRemoved.
  ///
  /// In en, this message translates to:
  /// **'Product type removed'**
  String get productTypeRemoved;

  /// No description provided for @unitCreated.
  ///
  /// In en, this message translates to:
  /// **'Unit created'**
  String get unitCreated;

  /// No description provided for @unitUpdated.
  ///
  /// In en, this message translates to:
  /// **'Unit updated'**
  String get unitUpdated;

  /// No description provided for @unitRemoved.
  ///
  /// In en, this message translates to:
  /// **'Unit removed'**
  String get unitRemoved;

  /// No description provided for @productCreated.
  ///
  /// In en, this message translates to:
  /// **'Product created'**
  String get productCreated;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated'**
  String get productUpdated;

  /// No description provided for @productRemoved.
  ///
  /// In en, this message translates to:
  /// **'Product removed'**
  String get productRemoved;

  /// No description provided for @lotCreated.
  ///
  /// In en, this message translates to:
  /// **'Lot created'**
  String get lotCreated;

  /// No description provided for @lotUpdated.
  ///
  /// In en, this message translates to:
  /// **'Lot updated'**
  String get lotUpdated;

  /// No description provided for @lotRemoved.
  ///
  /// In en, this message translates to:
  /// **'Lot removed'**
  String get lotRemoved;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteProductTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product Type?'**
  String get deleteProductTypeTitle;

  /// No description provided for @deleteUnitTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Unit?'**
  String get deleteUnitTitle;

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product?'**
  String get deleteProductTitle;

  /// No description provided for @deleteLotTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Lot?'**
  String get deleteLotTitle;

  /// No description provided for @deleteNamedEntityMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This action cannot be undone.'**
  String deleteNamedEntityMessage(String name);

  /// No description provided for @deleteLotMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this lot? This action cannot be undone.'**
  String get deleteLotMessage;

  /// No description provided for @failedToDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete category'**
  String get failedToDeleteCategory;

  /// No description provided for @failedToDeleteProductType.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product type'**
  String get failedToDeleteProductType;

  /// No description provided for @failedToDeleteUnit.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete unit'**
  String get failedToDeleteUnit;

  /// No description provided for @failedToDeleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product'**
  String get failedToDeleteProduct;

  /// No description provided for @failedToDeleteLot.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete lot'**
  String get failedToDeleteLot;

  /// No description provided for @createCategory.
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get createCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @categoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Fruits, Vegetables'**
  String get categoryNameHint;

  /// No description provided for @categoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category name is required'**
  String get categoryNameRequired;

  /// No description provided for @failedToSaveCategory.
  ///
  /// In en, this message translates to:
  /// **'Failed to save category'**
  String get failedToSaveCategory;

  /// No description provided for @noCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get noCategoriesYet;

  /// No description provided for @createCategoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a category to get started'**
  String get createCategoryEmptyMessage;

  /// No description provided for @createProductType.
  ///
  /// In en, this message translates to:
  /// **'Create Product Type'**
  String get createProductType;

  /// No description provided for @editProductType.
  ///
  /// In en, this message translates to:
  /// **'Edit Product Type'**
  String get editProductType;

  /// No description provided for @productTypeName.
  ///
  /// In en, this message translates to:
  /// **'Product type name'**
  String get productTypeName;

  /// No description provided for @productTypeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Milk, Cheese'**
  String get productTypeNameHint;

  /// No description provided for @productTypeNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product type name is required'**
  String get productTypeNameRequired;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Category is required'**
  String get categoryRequired;

  /// No description provided for @failedToSaveProductType.
  ///
  /// In en, this message translates to:
  /// **'Failed to save product type'**
  String get failedToSaveProductType;

  /// No description provided for @noProductTypesYet.
  ///
  /// In en, this message translates to:
  /// **'No product types yet'**
  String get noProductTypesYet;

  /// No description provided for @createProductTypeEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a product type to get started'**
  String get createProductTypeEmptyMessage;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @categoryWithName.
  ///
  /// In en, this message translates to:
  /// **'Category: {name}'**
  String categoryWithName(String name);

  /// No description provided for @selectCategoryLower.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategoryLower;

  /// No description provided for @createUnit.
  ///
  /// In en, this message translates to:
  /// **'Create Unit'**
  String get createUnit;

  /// No description provided for @editUnit.
  ///
  /// In en, this message translates to:
  /// **'Edit Unit'**
  String get editUnit;

  /// No description provided for @unitName.
  ///
  /// In en, this message translates to:
  /// **'Unit name'**
  String get unitName;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @unitNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Kilogram, Liter'**
  String get unitNameHint;

  /// No description provided for @unitSymbol.
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get unitSymbol;

  /// No description provided for @unitSymbolHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., kg, L'**
  String get unitSymbolHint;

  /// No description provided for @unitNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Unit name is required'**
  String get unitNameRequired;

  /// No description provided for @unitSymbolRequired.
  ///
  /// In en, this message translates to:
  /// **'Unit symbol is required'**
  String get unitSymbolRequired;

  /// No description provided for @failedToSaveUnit.
  ///
  /// In en, this message translates to:
  /// **'Failed to save unit'**
  String get failedToSaveUnit;

  /// No description provided for @noUnitsYet.
  ///
  /// In en, this message translates to:
  /// **'No units yet'**
  String get noUnitsYet;

  /// No description provided for @createUnitEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a unit to get started'**
  String get createUnitEmptyMessage;

  /// No description provided for @createProduct.
  ///
  /// In en, this message translates to:
  /// **'Create Product'**
  String get createProduct;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @productTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Product type'**
  String get productTypeLabel;

  /// No description provided for @selectProductTypeLower.
  ///
  /// In en, this message translates to:
  /// **'Select product type'**
  String get selectProductTypeLower;

  /// No description provided for @productNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameRequired;

  /// No description provided for @productTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Product type is required'**
  String get productTypeRequired;

  /// No description provided for @failedToSaveProduct.
  ///
  /// In en, this message translates to:
  /// **'Failed to save product'**
  String get failedToSaveProduct;

  /// No description provided for @noProductsYet.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get noProductsYet;

  /// No description provided for @createProductEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create your first product catalog entry to get started.'**
  String get createProductEmptyMessage;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product details'**
  String get productDetails;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// No description provided for @productTypeWithName.
  ///
  /// In en, this message translates to:
  /// **'Product type: {name}'**
  String productTypeWithName(String name);

  /// No description provided for @lotsCount.
  ///
  /// In en, this message translates to:
  /// **'Lots: {count}'**
  String lotsCount(int count);

  /// No description provided for @inventoryTrackedPerLot.
  ///
  /// In en, this message translates to:
  /// **'Inventory is tracked per lot below.'**
  String get inventoryTrackedPerLot;

  /// No description provided for @addLotLower.
  ///
  /// In en, this message translates to:
  /// **'Add lot'**
  String get addLotLower;

  /// No description provided for @noLotsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No lots registered'**
  String get noLotsRegistered;

  /// No description provided for @noExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'No expiration date'**
  String get noExpirationDate;

  /// No description provided for @editProductTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit product'**
  String get editProductTooltip;

  /// No description provided for @deleteProductTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get deleteProductTooltip;

  /// No description provided for @createLot.
  ///
  /// In en, this message translates to:
  /// **'Create Lot'**
  String get createLot;

  /// No description provided for @editLot.
  ///
  /// In en, this message translates to:
  /// **'Edit Lot'**
  String get editLot;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @quantityMustBeGreaterThanZero.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be greater than zero'**
  String get quantityMustBeGreaterThanZero;

  /// No description provided for @unitRequired.
  ///
  /// In en, this message translates to:
  /// **'Unit is required'**
  String get unitRequired;

  /// No description provided for @failedToSaveLot.
  ///
  /// In en, this message translates to:
  /// **'Failed to save lot'**
  String get failedToSaveLot;

  /// No description provided for @selectUnitLower.
  ///
  /// In en, this message translates to:
  /// **'Select unit'**
  String get selectUnitLower;

  /// No description provided for @selectExpirationDate.
  ///
  /// In en, this message translates to:
  /// **'Select expiration date'**
  String get selectExpirationDate;

  /// No description provided for @noLotsYet.
  ///
  /// In en, this message translates to:
  /// **'No lots yet'**
  String get noLotsYet;

  /// No description provided for @createLotEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add a lot to track quantities, units, and expiration dates.'**
  String get createLotEmptyMessage;

  /// No description provided for @unitsFallback.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get unitsFallback;

  /// No description provided for @noExpiration.
  ///
  /// In en, this message translates to:
  /// **'No expiration'**
  String get noExpiration;

  /// No description provided for @expiresWithDate.
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String expiresWithDate(String date);

  /// No description provided for @addQuantity.
  ///
  /// In en, this message translates to:
  /// **'Add quantity'**
  String get addQuantity;

  /// No description provided for @useQuantity.
  ///
  /// In en, this message translates to:
  /// **'Use quantity'**
  String get useQuantity;

  /// No description provided for @editLotTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit lot'**
  String get editLotTooltip;

  /// No description provided for @deleteLotTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete lot'**
  String get deleteLotTooltip;

  /// No description provided for @enterQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a quantity'**
  String get enterQuantity;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @insufficientQuantity.
  ///
  /// In en, this message translates to:
  /// **'Insufficient quantity'**
  String get insufficientQuantity;

  /// No description provided for @consumeQuantity.
  ///
  /// In en, this message translates to:
  /// **'Consume quantity'**
  String get consumeQuantity;

  /// No description provided for @quantityToUse.
  ///
  /// In en, this message translates to:
  /// **'Quantity to use'**
  String get quantityToUse;

  /// No description provided for @quantityToAdd.
  ///
  /// In en, this message translates to:
  /// **'Quantity to add'**
  String get quantityToAdd;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @newTotal.
  ///
  /// In en, this message translates to:
  /// **'New total'**
  String get newTotal;

  /// No description provided for @lotFallback.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lotFallback;

  /// No description provided for @currentQuantity.
  ///
  /// In en, this message translates to:
  /// **'Current: {quantity} {unit}'**
  String currentQuantity(String quantity, String unit);

  /// No description provided for @useAll.
  ///
  /// In en, this message translates to:
  /// **'Use all'**
  String get useAll;

  /// No description provided for @previewQuantity.
  ///
  /// In en, this message translates to:
  /// **'{label}: {quantity} {unit}'**
  String previewQuantity(String label, String quantity, String unit);

  /// No description provided for @emptyPreviewQuantity.
  ///
  /// In en, this message translates to:
  /// **'{label}: --'**
  String emptyPreviewQuantity(String label);

  /// No description provided for @quantityUsed.
  ///
  /// In en, this message translates to:
  /// **'{quantity} used'**
  String quantityUsed(String quantity);

  /// No description provided for @quantityAdded.
  ///
  /// In en, this message translates to:
  /// **'{quantity} added'**
  String quantityAdded(String quantity);

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @portugueseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portugueseLanguage;

  /// No description provided for @englishLanguage.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLanguage;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @importDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore from a local JSON backup'**
  String get importDataSubtitle;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a local JSON backup'**
  String get exportDataSubtitle;

  /// No description provided for @importCanceled.
  ///
  /// In en, this message translates to:
  /// **'Import canceled'**
  String get importCanceled;

  /// No description provided for @exportCanceled.
  ///
  /// In en, this message translates to:
  /// **'Export canceled'**
  String get exportCanceled;

  /// No description provided for @importConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'Importing a backup will replace current local data.'**
  String get importConfirmationMessage;

  /// No description provided for @backupImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup imported successfully'**
  String get backupImportedSuccessfully;

  /// No description provided for @failedToRestoreLocalDatabase.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore local database'**
  String get failedToRestoreLocalDatabase;

  /// No description provided for @backupExportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Backup exported successfully'**
  String get backupExportedSuccessfully;

  /// No description provided for @failedToExportBackup.
  ///
  /// In en, this message translates to:
  /// **'Failed to export backup'**
  String get failedToExportBackup;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionLabel;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @licensesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View open source licenses'**
  String get licensesSubtitle;

  /// No description provided for @exportDataBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Export data backup'**
  String get exportDataBackupDialogTitle;

  /// No description provided for @importDataBackupDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import data backup'**
  String get importDataBackupDialogTitle;

  /// No description provided for @failedToExportData.
  ///
  /// In en, this message translates to:
  /// **'Failed to export data.'**
  String get failedToExportData;

  /// No description provided for @backupDataCorrupted.
  ///
  /// In en, this message translates to:
  /// **'Backup data is corrupted.'**
  String get backupDataCorrupted;

  /// No description provided for @invalidBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Invalid backup file.'**
  String get invalidBackupFile;

  /// No description provided for @unsupportedBackupVersion.
  ///
  /// In en, this message translates to:
  /// **'Unsupported backup version.'**
  String get unsupportedBackupVersion;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
