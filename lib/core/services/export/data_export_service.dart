import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:tudo_em_casa/features/categories/data/models/category_model.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/models/product_type_model.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';
import 'package:tudo_em_casa/features/units/data/models/unit_model.dart';
import 'package:tudo_em_casa/features/units/data/repositories/unit_repository.dart';

typedef SaveFileCallback =
    Future<String?> Function({
      String? dialogTitle,
      String? fileName,
      Uint8List? bytes,
    });

class DataExportException implements Exception {
  final String message;

  const DataExportException(this.message);

  @override
  String toString() => message;
}

class DataExportService {
  static const int _schemaVersion = 1;

  final CategoryRepository _categoryRepository;
  final ProductTypeRepository _productTypeRepository;
  final UnitRepository _unitRepository;
  final ProductRepository _productRepository;
  final SaveFileCallback _saveFile;

  DataExportService({
    required CategoryRepository categoryRepository,
    required ProductTypeRepository productTypeRepository,
    required UnitRepository unitRepository,
    required ProductRepository productRepository,
    SaveFileCallback? saveFile,
  }) : _categoryRepository = categoryRepository,
       _productTypeRepository = productTypeRepository,
       _unitRepository = unitRepository,
       _productRepository = productRepository,
       _saveFile = saveFile ?? _defaultSaveFile;

  Future<String?> exportData() async {
    try {
      final categories = await _categoryRepository.getCategories();
      final productTypes = await _productTypeRepository.getProductTypes();
      final units = await _unitRepository.getUnits();
      final products = await _productRepository.getProducts();

      final exportPayload = <String, Object?>{
        'schemaVersion': _schemaVersion,
        'exportedAt': DateTime.now().toUtc().toIso8601String(),
        'categories': categories.map(_serializeCategory).toList(),
        'productTypes': productTypes.map(_serializeProductType).toList(),
        'units': units.map(_serializeUnit).toList(),
        'products': products.map(_serializeProduct).toList(),
      };

      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(exportPayload);
      final exportBytes = utf8.encode(prettyJson);

      return _saveFile(
        dialogTitle: 'Export data backup',
        fileName: _buildExportFileName(),
        bytes: Uint8List.fromList(exportBytes),
      );
    } catch (_) {
      throw const DataExportException('Failed to export data.');
    }
  }

  Map<String, Object?> _serializeCategory(CategoryModel category) {
    return category.toJson();
  }

  Map<String, Object?> _serializeProductType(ProductTypeModel productType) {
    return productType.toJson();
  }

  Map<String, Object?> _serializeUnit(UnitModel unit) {
    return unit.toJson();
  }

  Map<String, Object?> _serializeProduct(ProductModel product) {
    return product.toJson();
  }

  static Future<String?> _defaultSaveFile({
    String? dialogTitle,
    String? fileName,
    Uint8List? bytes,
  }) {
    return FilePicker.saveFile(
      dialogTitle: dialogTitle,
      fileName: fileName,
      bytes: bytes,
    );
  }

  String _buildExportFileName() {
    final now = DateTime.now().toLocal();
    final formattedDate = [
      now.year.toString().padLeft(4, '0'),
      now.month.toString().padLeft(2, '0'),
      now.day.toString().padLeft(2, '0'),
    ].join('_');
    final formattedTime = [
      now.hour.toString().padLeft(2, '0'),
      now.minute.toString().padLeft(2, '0'),
    ].join('_');

    return 'tudo_em_casa_backup_${formattedDate}_${formattedTime}.json';
  }
}
