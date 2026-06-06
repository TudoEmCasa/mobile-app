# Environment

This repository uses Mise to pin Flutter.

## Source of Truth

Configured toolchain:

```toml
# mise.toml
[tools]
flutter = "3.44.0"
```

There is no `.tool-versions` file. Ignore IDE SDK paths and default `PATH` binaries when deciding the project toolchain.

Dart is the SDK bundled with the Mise-managed Flutter install.

## Environment Setup for AI Agents

AI agents should use explicit Mise execution because non-interactive shells often skip shell activation.

From the repository root:

```bash
rtk mise current
rtk mise exec -- flutter --version
rtk mise exec -- dart --version
```

Expected versions:

```text
Flutter 3.44.0
Dart 3.12.0
```

Use these command forms:

```bash
rtk mise exec -- flutter pub get
rtk mise exec -- flutter gen-l10n
rtk mise exec -- dart run build_runner build --delete-conflicting-outputs
rtk mise exec -- dart format --output=none --set-exit-if-changed .
rtk mise exec -- flutter analyze
rtk mise exec -- flutter test
rtk mise exec -- flutter build apk --debug
```

Avoid bare commands in agent sessions:

```bash
flutter test
flutter analyze
dart analyze
dart run build_runner build
```

They may use the system toolchain instead of `mise.toml`.

## Environment Setup for Developers

Install tools:

```bash
mise install
```

Activate Mise in your shell:

```bash
eval "$(mise activate zsh)"
```

Use the activation command for your shell if it is not `zsh`.

Verify:

```bash
mise current
flutter --version
dart --version
```

If your shell is not activated, use `mise exec --` exactly like agents.

## Troubleshooting

### Flutter Version Differs

If `flutter --version` does not match `mise.toml`:

```bash
mise current
mise install
mise exec -- flutter --version
```

Then rerun the original command through `mise exec --`.

### Dart Version Differs

If dependency resolution reports the wrong Dart SDK:

```bash
mise exec -- flutter --version
mise exec -- dart --version
mise exec -- flutter pub get
```

Do not use a globally installed Dart SDK for this project.

### Command Ran Outside Mise

Treat the result as invalid.
Capture both versions, then rerun with Mise:

```bash
flutter --version
dart --version
mise exec -- flutter --version
mise exec -- dart --version
```

### Sandbox Cache Error

Flutter may write under:

```text
~/.local/share/mise/installs/flutter/.../bin/cache/
```

If a sandbox blocks that path, request permission and rerun the same `mise exec --` command. Do not fall back to system Flutter.

## CI Note

The current Flutter CI workflow uses `subosito/flutter-action` with `channel: stable`, not `mise.toml`.

Safer alternatives:
- install and run Flutter through Mise in CI
- or pin the Flutter action to `3.44.0`
