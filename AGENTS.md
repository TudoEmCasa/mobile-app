# Tudo em Casa — Agent Instructions

This file is the entry point for AI coding agents working in this repository.
Keep changes simple, offline-first, and consistent with the existing Flutter architecture.

## Read First

Before editing code, read:
- `docs/environment.md` for Mise, Flutter, and Dart setup.
- `docs/agent_guide.md` for architecture and implementation workflow.
- `docs/testing.md` and `test/AGENTS.md` before writing or changing tests.
- `docs/localization.md` and `docs/agent_i18n_context.md` before editing user-visible strings.

## Project Summary

Tudo em Casa is an offline-first Flutter mobile app for household inventory management.

The MVP covers:
- categories
- product types
- units
- products
- lots and expiration tracking
- local notifications
- local import/export

Do not add:
- authentication
- backend services
- cloud sync
- remote APIs
- multi-user behavior
- AI features

## Environment Setup for AI Agents

The Flutter toolchain is pinned by `mise.toml`.
Do not trust bare `flutter` or `dart` from the system `PATH`.

Verify the active toolchain from the repository root:

```bash
rtk mise current
rtk mise exec -- flutter --version
rtk mise exec -- dart --version
```

Use Mise for all Flutter and Dart commands:

```bash
rtk mise exec -- flutter pub get
rtk mise exec -- flutter gen-l10n
rtk mise exec -- dart run build_runner build --delete-conflicting-outputs
rtk mise exec -- dart format --output=none --set-exit-if-changed .
rtk mise exec -- flutter analyze
rtk mise exec -- flutter test
```

If a sandbox blocks Flutter from writing under the Mise SDK cache, request approval and rerun the same `mise exec --` command. Do not fall back to system Flutter.

## Architecture Rules

Stack:
- Flutter stable pinned by `mise.toml`
- Dart bundled with that Flutter SDK
- Riverpod
- Drift + SQLite
- Material 3
- MVVM with feature-based modules

Primary flow:

```text
UI -> ViewModel -> Repository -> Database
```

Rules:
- UI must not access Drift/database directly.
- Repositories centralize persistence and typed Drift queries.
- ViewModels coordinate UI state and business actions, not rendering.
- Providers expose dependencies; keep them small and logic-free.
- Use Riverpod only. Do not introduce Provider, GetX, or BloC.
- Keep feature code under `lib/features/<feature>/`.
- Keep shared infrastructure under `lib/core/`.

## Data Rules

- Use Drift typed APIs whenever possible.
- Avoid raw SQL unless Drift cannot express the query cleanly.
- Preserve database table names, field names, and backup JSON keys unless an explicit migration is required.
- Prefer relational models with optional related objects, for example `CategoryModel? category`.
- Do not duplicate relational fields into flattened model variants.

## UI Rules

- Use clean, minimal Material 3 UI.
- Prefer dedicated pages for create/edit forms.
- Use dedicated selection pages for relational entities instead of large dropdowns.
- Use modals only for confirmations, alerts, destructive warnings, or small bottom sheet tools.
- Keep widgets and build methods small.

## Language Rules

All code and technical documentation must be in English:
- classes
- variables
- methods
- files and folders
- database tables and fields
- comments
- commits
- technical docs

The academic TCC article remains Brazilian Portuguese.

Use explicit names:
- prefer `quantity`, `category`, `product`
- avoid `qty`, `cat`, `prod`

## App Language Behavior

The app supports only:
- Portuguese Brazil: `pt_BR`
- English: `en`

On first launch only, the app initializes and persists the language from the device locale:
- device language code starting with `pt` -> `pt_BR`
- any other device language -> `en`

After the preference is saved, the app always uses the in-app language preference.
Do not add a `System default` language option or reactively follow later device locale changes.

## Scope and Simplicity

This is an academic final graduation project.

Priorities:
1. readability
2. architectural organization
3. maintainability
4. offline reliability
5. simplicity

Avoid:
- unnecessary abstractions
- excessive complexity
- premature optimization
- unrelated refactors

## Comments

Prefer self-explanatory code over comments.

Comments are allowed for:
- complex business rules
- important architectural decisions
- technical limitations
- temporary workarounds with clear justification

Avoid redundant comments that restate the code.

## Testing

Tests must mirror `lib/` structure and respect the architecture.

Priority:
1. repository tests
2. ViewModel/provider tests
3. critical widget tests

Run verification through Mise. Report any command that cannot run and include the exact reason.

## Commits

Use Conventional Commits in English:

```text
<type>: <short description>
```

Allowed types:
- `feat`
- `fix`
- `refactor`
- `docs`
- `style`
- `chore`
- `test`

Keep commits focused and do not end messages with a period.
