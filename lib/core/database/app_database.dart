import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:tudo_em_casa/core/database/tables/categories.dart';
import 'package:tudo_em_casa/core/database/tables/product_types.dart';
import 'package:tudo_em_casa/core/database/tables/products.dart';
import 'package:tudo_em_casa/core/database/tables/units.dart';

part 'app_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final databaseFile = File(
      p.join(documentsDirectory.path, 'tudo_em_casa.sqlite'),
    );

    return NativeDatabase.createInBackground(databaseFile);
  });
}

@DriftDatabase(tables: [Categories, ProductTypes, Units, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(productTypes);
      }

      if (from < 3) {
        await m.createTable(units);
      }

      if (from < 4) {
        await m.createTable(products);
      }
    },
  );
}
