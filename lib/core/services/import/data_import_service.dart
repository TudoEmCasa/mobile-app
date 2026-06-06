import 'dart:convert';
import 'dart:developer' as developer;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';
import 'package:tudo_em_casa/features/units/data/repositories/unit_repository.dart';

typedef PickBackupFileCallback =
    Future<Uint8List?> Function({String? dialogTitle});

class DataImportException implements Exception {
  final String message;

  const DataImportException(this.message);

  @override
  String toString() => message;
}

class BackupImportPayload {
  final List<CategoryModel> categories;
  final List<ProductTypeModel> productTypes;
  final List<UnitModel> units;
  final List<ProductModel> products;

  const BackupImportPayload({
    required this.categories,
    required this.productTypes,
    required this.units,
    required this.products,
  });
}

class DataImportService {
  static const int _schemaVersion = 2;

  final AppDatabase _database;
  final CategoryRepository _categoryRepository;
  final ProductTypeRepository _productTypeRepository;
  final UnitRepository _unitRepository;
  final ProductRepository _productRepository;
  final PickBackupFileCallback _pickBackupFile;

  DataImportService({
    required this._database,
    required this._categoryRepository,
    required this._productTypeRepository,
    required this._unitRepository,
    required this._productRepository,
    PickBackupFileCallback? pickBackupFile,
  }) : _pickBackupFile = pickBackupFile ?? _defaultPickBackupFile;

  Future<BackupImportPayload?> pickBackupFile({String? dialogTitle}) async {
    _logStage('file picker opened');

    try {
      final bytes = await _pickBackupFile(
        dialogTitle: dialogTitle ?? 'Import data backup',
      );

      if (bytes == null) {
        _logStage('file selection canceled');
        return null;
      }

      _logStage('file loaded', details: 'bytes=${bytes.length}');

      return _parseBackup(bytes);
    } on DataImportException {
      rethrow;
    } on FormatException catch (error, stackTrace) {
      _logFailure('json parsing', error, stackTrace);
      throw const DataImportException('Backup data is corrupted.');
    } catch (error, stackTrace) {
      _logFailure('file loading', error, stackTrace);
      throw const DataImportException('Invalid backup file.');
    }
  }

  Future<void> importBackup(BackupImportPayload payload) async {
    try {
      await _runStage('database transaction', () async {
        await _database.transaction(() async {
          await _runStage('clear products', _productRepository.clearProducts);
          await _runStage(
            'clear product types',
            _productTypeRepository.clearProductTypes,
          );
          await _runStage('clear units', _unitRepository.clearUnits);
          await _runStage(
            'clear categories',
            _categoryRepository.clearCategories,
          );

          await _runStage(
            'import categories',
            () => _categoryRepository.insertCategories(payload.categories),
          );
          await _runStage(
            'import product types',
            () =>
                _productTypeRepository.insertProductTypes(payload.productTypes),
          );
          await _runStage(
            'import units',
            () => _unitRepository.insertUnits(payload.units),
          );
          await _runStage(
            'import products',
            () => _productRepository.insertProducts(payload.products),
          );
        });
      });
    } on DataImportException {
      rethrow;
    } catch (error, stackTrace) {
      _logFailure('database restore', error, stackTrace);
      throw const DataImportException('Failed to restore local database.');
    }
  }

  BackupImportPayload _parseBackup(Uint8List bytes) {
    return _runSyncStage('parse backup json', () {
      final decodedJson = utf8.decode(bytes);
      final decodedPayload = jsonDecode(decodedJson);

      if (decodedPayload is! Map) {
        throw const DataImportException('Invalid backup file.');
      }

      final payload = Map<String, Object?>.from(decodedPayload);

      _validateMetadata(payload);

      final categories = _readCategories(payload);
      final productTypes = _readProductTypes(payload);
      final units = _readUnits(payload);
      final products = _readProducts(payload);

      _validateRelationships(
        categories: categories,
        productTypes: productTypes,
        units: units,
        products: products,
      );

      return BackupImportPayload(
        categories: categories,
        productTypes: productTypes,
        units: units,
        products: products,
      );
    });
  }

  void _validateMetadata(Map<String, Object?> payload) {
    final schemaVersion = payload['schemaVersion'];
    final exportedAt = payload['exportedAt'];

    if (schemaVersion is! num) {
      throw const DataImportException('Invalid backup file.');
    }

    if (schemaVersion.toInt() != _schemaVersion) {
      throw const DataImportException('Unsupported backup version.');
    }

    if (exportedAt is! String || exportedAt.isEmpty) {
      throw const DataImportException('Invalid backup file.');
    }

    const requiredCollections = [
      'categories',
      'productTypes',
      'units',
      'products',
    ];

    for (final collection in requiredCollections) {
      if (!payload.containsKey(collection)) {
        throw const DataImportException('Invalid backup file.');
      }
    }
  }

  List<CategoryModel> _readCategories(Map<String, Object?> payload) {
    return _readList(
      payload,
      'categories',
    ).map(CategoryModel.fromJson).toList();
  }

  List<ProductTypeModel> _readProductTypes(Map<String, Object?> payload) {
    return _readList(
      payload,
      'productTypes',
    ).map(ProductTypeModel.fromJson).toList();
  }

  List<UnitModel> _readUnits(Map<String, Object?> payload) {
    return _readList(payload, 'units').map(UnitModel.fromJson).toList();
  }

  List<ProductModel> _readProducts(Map<String, Object?> payload) {
    return _readList(payload, 'products').map(ProductModel.fromJson).toList();
  }

  List<Map<String, Object?>> _readList(
    Map<String, Object?> payload,
    String key,
  ) {
    final value = payload[key];

    if (value is! List) {
      throw const DataImportException('Invalid backup file.');
    }

    return value.map((item) {
      if (item is! Map) {
        throw const DataImportException('Invalid backup file.');
      }

      return Map<String, Object?>.from(item);
    }).toList();
  }

  void _validateRelationships({
    required List<CategoryModel> categories,
    required List<ProductTypeModel> productTypes,
    required List<UnitModel> units,
    required List<ProductModel> products,
  }) {
    final categoryIds = <int>{};
    final productTypeIds = <int>{};
    final unitIds = <int>{};
    final productIds = <int>{};

    for (final category in categories) {
      if (!categoryIds.add(category.id)) {
        throw const DataImportException('Invalid backup file.');
      }
    }

    for (final productType in productTypes) {
      if (!productTypeIds.add(productType.id) ||
          !categoryIds.contains(productType.categoryId)) {
        throw const DataImportException('Invalid backup file.');
      }
    }

    for (final unit in units) {
      if (!unitIds.add(unit.id)) {
        throw const DataImportException('Invalid backup file.');
      }
    }

    for (final product in products) {
      if (!productIds.add(product.id) ||
          !productTypeIds.contains(product.productTypeId) ||
          !_validateProductLots(product, productIds, unitIds)) {
        throw const DataImportException('Invalid backup file.');
      }
    }
  }

  bool _validateProductLots(
    ProductModel product,
    Set<int> productIds,
    Set<int> unitIds,
  ) {
    final lots = product.lots;

    if (lots == null || lots.isEmpty) {
      return true;
    }

    final lotIds = <int>{};

    for (final lot in lots) {
      if (!lotIds.add(lot.id) ||
          lot.productId != product.id ||
          !productIds.contains(lot.productId) ||
          !unitIds.contains(lot.unitId)) {
        return false;
      }
    }

    return true;
  }

  static Future<Uint8List?> _defaultPickBackupFile({String? dialogTitle}) {
    return FilePicker.pickFiles(
      dialogTitle: dialogTitle,
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: const ['json'],
      withData: true,
    ).then((result) => result?.files.single.bytes);
  }

  Future<T> _runStage<T>(String stage, Future<T> Function() action) async {
    _logStage(stage, details: 'started');

    try {
      final result = await action();
      _logStage(stage, details: 'completed');
      return result;
    } catch (error, stackTrace) {
      _logFailure(stage, error, stackTrace);
      rethrow;
    }
  }

  T _runSyncStage<T>(String stage, T Function() action) {
    _logStage(stage, details: 'started');

    try {
      final result = action();
      _logStage(stage, details: 'completed');
      return result;
    } catch (error, stackTrace) {
      _logFailure(stage, error, stackTrace);
      rethrow;
    }
  }

  void _logStage(String stage, {String? details}) {
    if (!kDebugMode) {
      return;
    }

    final message = details == null ? stage : '$stage: $details';
    developer.log(message, name: 'DataImport');
  }

  void _logFailure(String stage, Object error, StackTrace stackTrace) {
    if (!kDebugMode) {
      return;
    }

    developer.log(
      'failed at $stage with ${error.runtimeType}',
      name: 'DataImport',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
