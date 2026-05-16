import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/core/database/app_database.dart';
import 'package:tudo_em_casa/features/categories/presentation/pages/category_list_page.dart';
import 'package:tudo_em_casa/features/product_types/presentation/pages/product_type_list_page.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_list_page.dart';
import 'package:tudo_em_casa/features/units/presentation/pages/unit_list_page.dart';

void main() {
  runApp(const ProviderScope(child: TudoEmCasaApp()));
}

class TudoEmCasaApp extends StatelessWidget {
  const TudoEmCasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tudo em Casa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const ProductListPage(),
    );
  }
}
