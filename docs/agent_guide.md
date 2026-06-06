# Agent Guide

Use this guide after reading `AGENTS.md`.
It is optimized for AI coding agents such as Codex, Claude Code, and Cursor.

## Start Every Task

1. Check repository state:

   ```bash
   rtk git status --short
   ```

2. Verify the Mise toolchain:

   ```bash
   rtk mise current
   rtk mise exec -- flutter --version
   rtk mise exec -- dart --version
   ```

3. Identify the smallest relevant area:
   - app bootstrap: `lib/main.dart`, `lib/app.dart`
   - shared infrastructure: `lib/core/`
   - features: `lib/features/<feature>/`
   - shell navigation: `lib/presentation/shell/`
   - localization: `lib/l10n/`
   - tests: `test/`

4. Read nearby files before editing.

## Feature Layout

Use the existing feature structure:

```text
lib/features/<feature>/
  data/
    models/
    providers/
    repositories/
  presentation/
    pages/
    viewmodels/
    widgets/
```

Do not create a new layer unless the existing pattern cannot support the change.

## Dependency Flow

Keep dependencies one-way:

```text
Page/Widget -> ViewModel/Provider -> Repository/Service -> Database/File System
```

Rules:
- Pages and widgets render UI, navigate, and show feedback.
- ViewModels coordinate actions and UI state.
- Repositories perform persistence.
- Services handle cross-feature operations such as import/export.
- Providers expose repositories, services, streams, and ViewModels.

## Common Implementation Patterns

For CRUD screens:
- list page displays reactive data
- form page handles create/edit
- item widget renders one row/card
- empty widget handles empty state
- delete uses confirmation bottom sheet

For relational selection:

```text
Form Page -> Selection Page -> Navigator.pop(selectedEntity)
```

Avoid dropdowns for categories, product types, units, and other relational entities.

## Error Handling

Use `AppSnackbar` for user feedback.

Keep low-level errors technical or domain-oriented. If an error reaches UI, map it in presentation code to a user-facing localized message.

Avoid displaying raw exception text when a known localized message exists.

## Localization

Read `docs/agent_i18n_context.md` before changing visible text.

Quick rules:
- add visible strings to ARB files
- run `rtk mise exec -- flutter gen-l10n`
- do not localize database names, backup JSON keys, logs, or user-created data
- use placeholders for dynamic text

## Verification Commands

Use the smallest relevant command first, then broader checks.

Common commands:

```bash
rtk mise exec -- dart format --output=none --set-exit-if-changed .
rtk mise exec -- flutter gen-l10n
rtk mise exec -- dart run build_runner build --delete-conflicting-outputs
rtk mise exec -- flutter analyze
rtk mise exec -- flutter test
```

If a command cannot run because of SDK cache permissions, request approval and rerun the same Mise command.

If a command cannot run because of SDK mismatch, report:
- default `PATH` Flutter/Dart version
- Mise Flutter/Dart version
- failing command output

## Do Not

- Do not add online features.
- Do not bypass repositories from UI.
- Do not introduce a second state management framework.
- Do not rewrite broad architecture for a local change.
- Do not modify generated files manually when a generator owns them.
- Do not revert unrelated user changes in a dirty worktree.
