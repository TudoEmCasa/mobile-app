# Architecture

Use this document for the stable project architecture.
For task execution details, read `docs/agent_guide.md`.

## Pattern

The app uses MVVM with feature-based modules.

Primary flow:

```text
UI -> ViewModel -> Repository -> Database
```

## Layers

- UI pages/widgets render state, navigate, and show feedback.
- ViewModels coordinate actions and presentation state.
- Repositories encapsulate Drift/SQLite access.
- Providers expose databases, repositories, services, streams, and ViewModels.
- Services handle cross-feature workflows such as import/export.

## Boundaries

- UI must not access Drift directly.
- ViewModels must not render widgets.
- Repositories must not depend on Flutter UI APIs.
- Shared infrastructure belongs in `lib/core/`.
- Feature-specific code belongs in `lib/features/<feature>/`.

## Constraints

- Fully offline.
- No authentication.
- No backend.
- No cloud sync.
- No remote API dependency.
