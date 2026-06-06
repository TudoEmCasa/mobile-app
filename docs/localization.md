# Localization

Use this document when adding or reviewing user-facing text.

## Required Locales

Every user-facing string must be available in:
- English: `lib/l10n/app_en.arb`
- Portuguese fallback: `lib/l10n/app_pt.arb`
- Brazilian Portuguese: `lib/l10n/app_pt_BR.arb`

The app exposes only two language choices to users:
- `pt_BR`: Portuguese
- `en`: English

There is intentionally no `System default` language option.

On first launch, before any saved preference exists, the device locale is used only to choose and persist the initial app language:
- language code starting with `pt` -> `pt_BR`
- any other language code -> `en`

After this initial preference exists, the app must always use the persisted in-app language. Later device locale changes must not change the app language automatically.

Run localization generation after ARB changes:

```bash
rtk mise exec -- flutter gen-l10n
```

## Brazilian Portuguese Quality Rules

Portuguese text must read as natural Brazilian Portuguese, not as a literal English translation.

Rules:
- Use correct accents.
- Prefer short, clear mobile UI labels.
- Keep terminology consistent across screens.
- Match the household inventory and pantry management domain.
- Prefer familiar Brazilian Portuguese wording over literal translation.
- Use sentence case for regular labels unless a component pattern requires otherwise.

## Domain Terminology

Preferred terms:
- `Unit Symbol` -> `Abreviação` when referring to measurement unit abbreviations.
- `Expiration Date` -> `Data de validade`.
- `Available` -> `Disponível`.
- `Available Items` -> `Itens disponíveis`.
- `Settings` -> `Ajustes` in navigation and page title.
- `Language` -> `Idioma`.
- `Portuguese` -> `Português`.
- `English` -> `Inglês`.

Use proper accents:
- `disponível`
- `disponíveis`
- `símbolo`
- `abreviação`
- `configurações`
- `histórico`
- `válida`
- `obrigatório`
- `obrigatória`
- `ação`
- `não`
- `versão`
- `licenças`
- `código`
- `inválido`

Words that do not need accents:
- `categoria`
- `validade`
- `unidade`

## Dynamic Text

Use ARB placeholders for text with variable data:
- entity names
- dates
- quantities
- counts

Avoid assembling full user-facing sentences with string concatenation.

## Do Not Localize

Do not translate:
- database table names
- database field names
- backup JSON keys
- backup file names
- debug logs
- user-created product/category/unit names
- Dart class, method, or file names

## Lightweight Quality Check

Run this command after editing Portuguese ARB files:

```bash
rtk mise exec -- dart run tool/validate_pt_localization.dart
```

The script checks common unaccented Portuguese words in `app_pt.arb` and `app_pt_BR.arb`.
It is intentionally lightweight and may not catch every writing issue. Manual review is still required.

## Review Checklist

Before finishing localization work:
- all new strings exist in English and Portuguese ARBs
- Portuguese strings use accents correctly
- wording sounds natural to Brazilian users
- unit abbreviation text uses `Abreviação`, not literal `Símbolo`
- generated localization files are updated
- the validation script passes
