# Categories Feature - Refactored Architecture

## Directory Structure

```
lib/features/categories/
├── data/
│   ├── models/
│   │   ├── category_model.dart
│   │   └── index.dart
│   ├── providers/                    ← Provider layer
│   │   ├── category_repository_provider.dart
│   │   └── index.dart
│   ├── repositories/
│   │   ├── category_repository.dart
│   │   └── index.dart
│   └── ...
├── presentation/
│   ├── pages/
│   │   ├── category_list_page.dart   (list & navigation)
│   │   ├── category_form_page.dart   (form - create/edit)
│   │   └── index.dart
│   ├── viewmodels/
│   │   ├── category_list_viewmodel.dart
│   │   └── index.dart
│   ├── widgets/
│   │   ├── category_item_widget.dart
│   │   ├── empty_categories_widget.dart
│   │   └── index.dart
│   └── ...
└── AGENTS.md
```

## Architecture Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  CategoryListPage (ConsumerWidget)                       │  │
│  │  • Watches watchAllCategoriesProvider for data           │  │
│  │  • Navigates to CategoryFormPage on create              │  │
│  │  • Renders category list                                │  │
│  └──────────────────────────────────────────────────────────┘  │
│                           │                                     │
│                   navigates to / returns                        │
│                           │                                     │
│  ┌──────────────────────────▼──────────────────────────────┐  │
│  │  CategoryFormPage (ConsumerStatefulWidget)              │  │
│  │  • Text field for category name                         │  │
│  │  • Form validation (required field check)               │  │
│  │  • Save & Cancel buttons                                │  │
│  │  • Calls ViewModel to persist                           │  │
│  │  • Auto-focuses on text field                           │  │
│  │  • Handles keyboard properly                            │  │
│  │  • Disables actions while submitting                    │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ consumes providers
┌──────────────────────────▼──────────────────────────────────────┐
│                    VIEWMODEL LAYER                              │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  categoryListViewModelProvider (Provider)                │  │
│  │  • Provides CategoryListViewModel instance              │  │
│  │                                                          │  │
│  │  ┌────────────────────────────────────────────────────┐ │  │
│  │  │ CategoryListViewModel                              │ │  │
│  │  │ • createCategory(name)                             │ │  │
│  │  │ • deleteCategory(id)                               │ │  │
│  │  │ • Business logic encapsulation                     │ │  │
│  │  └────────────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ consumes providers
┌──────────────────────────▼──────────────────────────────────────┐
│                    PROVIDER LAYER                               │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  categoryRepositoryProvider (Provider)                   │  │
│  │  • Location: data/providers/                            │  │
│  │  • Creates CategoryRepository singleton                  │  │
│  │  • Injects AppDatabase via appDatabaseProvider          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  watchAllCategoriesProvider (StreamProvider)            │  │
│  │  • Location: data/providers/                            │  │
│  │  • Streams reactive list of categories                  │  │
│  │  • Sorted alphabetically by name                        │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ uses
┌──────────────────────────▼──────────────────────────────────────┐
│                   REPOSITORY LAYER                              │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  CategoryRepository                                       │  │
│  │  Location: data/repositories/                            │  │
│  │                                                          │  │
│  │  Methods:                                                │  │
│  │  • createCategory(name): Future<int>                     │  │
│  │  • getCategoryById(id): Future<CategoryModel?>           │  │
│  │  • watchCategoryById(id): Stream<CategoryModel?>         │  │
│  │  • watchCategories(): Stream<List<CategoryModel>>        │  │
│  │  • updateCategory(category): Future<bool>                │  │
│  │  • deleteCategory(id): Future<bool>                      │  │
│  │                                                          │  │
│  │  Encapsulates:                                           │  │
│  │  • Database queries                                      │  │
│  │  • Drift queries with type safety                        │  │
│  │  • Sorting and filtering                                 │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────┬──────────────────────────────────────┘
                           │ uses
┌──────────────────────────▼──────────────────────────────────────┐
│                   DATABASE LAYER                                │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  AppDatabase (Drift ORM)                                │  │
│  │  • Manages SQLite connection                            │  │
│  │  • Provides strongly-typed queries                      │  │
│  │  • Reactive streams via watch()                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                          │                                      │
│                          ▼                                      │
│                   SQLite Database                              │
└─────────────────────────────────────────────────────────────────┘
```

## Key Principles Applied

### 1. **Separation of Concerns**
- UI only handles presentation and navigation
- ViewModel handles business logic and form orchestration
- Repository handles data persistence
- Providers handle dependency injection

### 2. **Page-Based Navigation Pattern**
- `CategoryListPage` — displays list of categories, navigation entry point
- `CategoryFormPage` — dedicated form page for category creation
- No dialogs/modals for content creation
- Mobile-first approach with full-screen form

### 3. **Dependency Injection via Riverpod**
- AppDatabase injected into Repository via `appDatabaseProvider`
- Repository injected into ViewModel via `categoryRepositoryProvider`
- Single instance pattern ensures consistency

### 4. **Reactive Programming**
- `watchAllCategoriesProvider` provides reactive stream
- UI rebuilds when categories change
- Powered by Drift's reactive watch() API

### 5. **Type Safety**
- Full Dart type system usage
- Drift provides SQL type safety
- No raw SQL queries

### 6. **MVVM Pattern**
```
Pages (UI) ←→ ViewModel ←→ Repository ←→ Database
 (passive)    (logic)   (persistence)  (data)
```

## Data Flow Examples

### Creating a Category (New Flow)

1. User taps "Create Category" button on CategoryListPage
2. Navigation pushes CategoryFormPage
3. User types name and presses "Create" button
4. Form validates non-empty name
5. Page reads `categoryListViewModelProvider`
6. ViewModel calls `categoryRepositoryProvider.createCategory(name)`
7. Repository calls `_db.into(_db.categories).insert(...)`
8. Drift inserts category into SQLite
9. `watchAllCategoriesProvider` emits new list
10. CategoryListPage rebuilds with new category
11. User navigates back from CategoryFormPage

### Watching All Categories

1. Page watches `watchAllCategoriesProvider`
2. Provider watches `categoryRepositoryProvider.watchCategories()`
3. Repository returns stream from `_db.select(_db.categories)...`
4. Drift watches database table
5. Any category change emits new list
6. Page updates automatically

## CategoryFormPage Details

### Features
- **Text Input**: Material 3 outlined text field with label and hint
- **Validation**: Checks for empty/whitespace-only names
- **Keyboard Handling**: Auto-focus on mount, submit on Enter key
- **Loading State**: Shows progress indicator while submitting, disables controls
- **Error Handling**: Shows SnackBar on validation or creation error
- **Navigation**: Back button closes page, automatic pop on success
- **Mobile UX**: Full-page form with proper spacing (24px padding), button row at bottom

### State Management
- Uses `ConsumerStatefulWidget` for local UI state
- `TextEditingController` for form input
- `FocusNode` for keyboard focus management
- `_isSubmitting` flag to disable controls during async operation

## Compliance Checklist

✅ **MVVM Architecture**
- Clear separation between UI, ViewModel, Repository, Database
- Pages delegate to ViewModel
- ViewModel delegates to Repository
- Stateful UI state in pages only (form inputs)

✅ **Navigation Pattern**
- Dedicated page for form instead of dialogs
- Page-based routing using Flutter Navigator
- Mobile-first full-page design

✅ **Riverpod Integration**
- Provider pattern for dependency injection
- StreamProvider for reactive data
- Single instance management

✅ **Clean Architecture**
- No circular dependencies
- Single responsibility per layer
- Testable design

✅ **Drift ORM**
- No raw SQL
- Type-safe queries
- Reactive streams

✅ **Offline-First**
- All data persisted locally
- No external APIs
- Full functionality without internet

✅ **Code Quality**
- No analyzer warnings
- Consistent naming
- Well-documented
- Production-ready

## Future Extensibility

The current architecture supports:
- **Category Editing**: Pass optional category parameter to `CategoryFormPage`
- **Pre-fill Values**: Update `_nameController` with existing category data
- **Update Flow**: Add `updateCategory` method to ViewModel
- **Batch Operations**: Add repository methods for bulk create/update/delete
