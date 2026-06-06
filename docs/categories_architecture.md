# Categories Feature

The categories feature follows the standard feature architecture described in `docs/architecture.md` and `docs/agent_guide.md`.

## Structure

```text
lib/features/categories/
  data/
    models/
    providers/
    repositories/
  presentation/
    pages/
    viewmodels/
    widgets/
```

## Flow

```text
CategoryListPage
  -> CategoryFormPage
  -> CategoryListViewModel
  -> CategoryRepository
  -> AppDatabase
```

## Current Pattern

- `CategoryListPage` watches the reactive category provider and handles navigation.
- `CategoryFormPage` handles create/edit validation and submission.
- `CategoryItemWidget` renders one category row.
- `EmptyCategoriesWidget` renders empty state.
- `CategoryListViewModel` coordinates create, update, and delete operations.
- `CategoryRepository` owns Drift queries for categories.

## Agent Guidance

Use this feature as the reference for simple CRUD modules.

When adding similar features:
- keep pages focused on UI and navigation
- keep form validation local when it is simple
- use providers for repository and stream access
- use dedicated pages for create/edit
- use confirmation UI for destructive actions
