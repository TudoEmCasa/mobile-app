import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tudo_em_casa/features/management/presentation/pages/management_page.dart';
import 'package:tudo_em_casa/features/products/presentation/pages/product_list_page.dart';
import 'package:tudo_em_casa/features/settings/presentation/pages/settings_page.dart';
import 'package:tudo_em_casa/l10n/localization_extension.dart';

final appShellTabIndexProvider =
    NotifierProvider<AppShellTabIndexNotifier, int>(
      AppShellTabIndexNotifier.new,
    );

class AppShellTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) {
    state = index;
  }
}

class AppShellPage extends ConsumerWidget {
  const AppShellPage({super.key});

  final List<Widget> _pages = const [
    ProductListPage(),
    ManagementPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(appShellTabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: selectedIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          ref.read(appShellTabIndexProvider.notifier).setIndex(index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: context.l10n.text('products'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.dashboard_customize_outlined),
            selectedIcon: const Icon(Icons.dashboard_customize),
            label: context.l10n.text('management'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.l10n.text('settings'),
          ),
        ],
      ),
    );
  }
}
