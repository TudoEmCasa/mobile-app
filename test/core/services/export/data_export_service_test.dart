import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/core/services/export/data_export_service.dart';
import 'package:tudo_em_casa/features/categories/data/repositories/category_repository.dart';
import 'package:tudo_em_casa/features/lots/data/models/lot_model.dart';
import 'package:tudo_em_casa/features/lots/data/repositories/lot_repository.dart';
import 'package:tudo_em_casa/features/product_types/data/repositories/product_type_repository.dart';
import 'package:tudo_em_casa/features/products/data/models/product_model.dart';
import 'package:tudo_em_casa/features/products/data/repositories/product_repository.dart';
import 'package:tudo_em_casa/features/units/data/repositories/unit_repository.dart';

void main() {
  test('exports all application data into a JSON backup file', () async {
    final exportDirectory = await Directory.systemTemp.createTemp(
      'tudo_em_casa_export_test',
    );
    addTearDown(() async {
      if (await exportDirectory.exists()) {
        await exportDirectory.delete(recursive: true);
      }
    });

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    final categoryRepository = CategoryRepository(database);
    final productTypeRepository = ProductTypeRepository(database);
    final unitRepository = UnitRepository(database);
    final productRepository = ProductRepository(
      database,
      LotRepository(database),
    );

    final categoryId = await categoryRepository.createCategory('Pantry');
    final unitId = await unitRepository.createUnit('Kilogram', 'kg');
    final productTypeId = await productTypeRepository.createProductType(
      'Rice',
      categoryId,
    );
    await productRepository.createProduct(
      ProductModel(
        id: 0,
        name: 'Rice',
        productTypeId: productTypeId,
        lots: [
          LotModel(
            id: 0,
            productId: 0,
            unitId: unitId,
            quantity: 2.5,
            expirationDate: DateTime(2026, 1, 1),
          ),
        ],
      ),
    );

    final exportService = DataExportService(
      categoryRepository: categoryRepository,
      productTypeRepository: productTypeRepository,
      unitRepository: unitRepository,
      productRepository: productRepository,
      saveFile: ({dialogTitle, fileName, bytes}) async {
        expect(dialogTitle, 'Export data backup');
        expect(fileName, startsWith('tudo_em_casa_backup_'));
        expect(fileName, endsWith('.json'));
        expect(bytes, isNotNull);

        final outputFile = File('${exportDirectory.path}/$fileName');
        await outputFile.writeAsBytes(bytes!);
        return outputFile.path;
      },
    );

    final exportFile = await exportService.exportData();
    expect(exportFile, isNotNull);

    final outputFile = File(exportFile!);
    expect(outputFile.existsSync(), isTrue);

    final payload =
        jsonDecode(await outputFile.readAsString(encoding: utf8))
            as Map<String, dynamic>;

    expect(payload['schemaVersion'], 2);
    expect(payload['exportedAt'], isA<String>());
    expect(payload['categories'], isA<List<dynamic>>());
    expect(payload['productTypes'], isA<List<dynamic>>());
    expect(payload['units'], isA<List<dynamic>>());
    expect(payload['products'], isA<List<dynamic>>());

    final categories = payload['categories'] as List<dynamic>;
    final productTypes = payload['productTypes'] as List<dynamic>;
    final units = payload['units'] as List<dynamic>;
    final products = payload['products'] as List<dynamic>;

    expect(categories.single['name'], 'Pantry');
    expect(productTypes.single['name'], 'Rice');
    expect(units.single['symbol'], 'kg');
    expect(products.single['lots'], isA<List<dynamic>>());
    final lots = products.single['lots'] as List<dynamic>;
    expect(lots.single['quantity'], 2.5);
    expect(lots.single['expirationDate'], '2026-01-01T00:00:00.000');
  });
}
