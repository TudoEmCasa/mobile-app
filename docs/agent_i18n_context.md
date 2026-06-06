# Agent i18n Context

Use this file when editing user-visible text.
Read `docs/localization.md` for Brazilian Portuguese UX writing rules.

## Strategy

The project uses Flutter's official localization flow:
- `flutter_localizations`
- `gen-l10n`
- ARB files under `lib/l10n/`
- generated `AppLocalizations`

Configured files:
- `l10n.yaml`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_pt.arb`
- `lib/l10n/app_pt_BR.arb`

`app_en.arb` is the template. `app_pt.arb` exists because Flutter requires a base Portuguese fallback when `pt_BR` is supported.

## Runtime Language Preference

The app supports only Portuguese Brazil (`pt_BR`) and English (`en`).

The device locale is used only on first launch, before a saved app language exists:
- `pt*` device locale -> persist `pt_BR`
- any other device locale -> persist `en`

After that, the saved in-app language always takes precedence. Do not add a `System default` language option and do not make the app react to future device locale changes automatically.

## Usage

In widgets, use:

```dart
import 'package:tudo_em_casa/l10n/localization_extension.dart';

Text(context.l10n.text('products'));
```

For generated typed access in central code, use:

```dart
AppLocalizations.of(context).appTitle
```

When adding a new user-visible string:
1. Add the key to `app_en.arb`.
2. Add translations to `app_pt.arb` and `app_pt_BR.arb`.
3. Run `rtk mise exec -- flutter gen-l10n`.
4. If the string is accessed through `context.l10n.text(...)`, add the key to `AppLocalizationsLookup` in `localization_extension.dart`.
5. Run `rtk mise exec -- dart run tool/validate_pt_localization.dart`.

## What To Localize

Localize:
- page titles
- navigation labels
- buttons
- tooltips
- form labels and hints
- validation messages
- empty states
- snackbars
- confirmation sheets
- file picker dialog titles

Do not localize:
- database table names
- database field names
- backup JSON keys
- backup file names
- debug logs
- user-created category/product/unit names
- technical class or method names

## Dynamic Text

Use ARB placeholders for dynamic text.

Examples:
- entity names in delete confirmations
- dates displayed inside labels
- quantities
- counts

Avoid manual string concatenation for sentences when a localized placeholder is available.

## Date Formatting

Use `DateFormatter.formatDate(date, locale: Localizations.localeOf(context).toString())` in UI code.

Do not rely only on `Intl.defaultLocale` for UI dates, because the effective app locale is resolved by Flutter localization.

## Error Mapping

Repositories and services should not depend on `BuildContext` or localization.

When a repository or service throws a technical/domain exception that reaches UI:
- catch it in presentation code
- map known messages or error types to localized strings
- keep fallback messages conservative
