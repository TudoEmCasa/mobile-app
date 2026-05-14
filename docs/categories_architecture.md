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

### Creating a Category

1. User taps "Create Category" button on CategoryListPage
2. Navigation pushes CategoryFormPage (no category parameter)
3. User types name and presses "Create" button
4. Form validates non-empty name
5. ViewModel calls `createCategory(name)`
6. Repository inserts category into SQLite
7. `watchAllCategoriesProvider` emits new list
8. CategoryListPage rebuilds with new category
9. User navigates back from CategoryFormPage

### Editing a Category

1. User taps edit icon on category item
2. Navigation pushes CategoryFormPage with category parameter
3. Form pre-fills name field with existing value
4. User modifies name and presses "Update" button
5. Form validates non-empty name
6. ViewModel calls `updateCategory(category)`
7. Repository updates category in SQLite
8. `watchAllCategoriesProvider` emits updated list
9. CategoryListPage rebuilds with updated category
10. User navigates back from CategoryFormPage

### Deleting a Category

1. User taps delete icon on category item
2. Confirmation dialog appears with category name
3. User confirms deletion
4. ViewModel calls `deleteCategory(id)`
5. Repository deletes category from SQLite
6. `watchAllCategoriesProvider` emits list without deleted category
7. CategoryListPage rebuilds without the deleted item
8. Dialog closes automatically

### Watching All Categories

1. Page watches `watchAllCategoriesProvider`
2. Provider watches `categoryRepositoryProvider.watchCategories()`
3. Repository returns stream from `_db.select(_db.categories)...`
4. Drift watches database table
5. Any category change (create/update/delete) emits new list
6. Page updates automatically

## CategoryFormPage Details

### Dual Mode (Create & Edit)
- Accepts optional `CategoryModel` parameter
- If no category: Create mode (form title: "Create Category", button: "Create")
- If category provided: Edit mode (form title: "Edit Category", button: "Update")
- Pre-fills name field in edit mode
- Same validation and submission flow for both modes

### Features
- **Text Input**: Material 3 outlined text field with label and hint
- **Validation**: Checks for empty/whitespace-only names
- **Keyboard Handling**: Auto-focus on mount, submit on Enter key
- **Loading State**: Shows progress indicator while submitting, disables controls
- **Error Handling**: Shows SnackBar on validation or save error
- **Navigation**: Back button closes page, automatic pop on success
- **Mobile UX**: Full-page form with proper spacing (24px padding), button row at bottom

### State Management
- Uses `ConsumerStatefulWidget` for local UI state
- `TextEditingController` for form input with optional initial value
- `FocusNode` for keyboard focus management
- `_isSubmitting` flag to disable controls during async operation
- `_isEditMode` getter determines form behavior

## CategoryItemWidget Details

### Layout
- List tile with category name as title
- Two icon buttons in trailing area: edit and delete
- Explicit icons: edit (pencil), delete (trash)
- Tooltips for accessibility

### Callbacks
- `onEdit`: Triggered when edit button pressed
- `onDelete`: Triggered when delete button pressed
- No hidden menus or long-press interactions

## Delete Confirmation Dialog

### Behavior
- Shows when user taps delete icon
- Displays category name in confirmation message
- Explains action is irreversible
- Two buttons: "Cancel" and "Delete" (red text)
- Deletion only occurs after confirmation
- Automatic dialog close after deletion

## Compliance Checklist

✅ **MVVM Architecture**
- Clear separation between UI, ViewModel, Repository, Database
- Pages delegate to ViewModel
- ViewModel delegates to Repository
- Stateful UI state in pages only (form inputs)
- ViewModel exposes `createCategory`, `updateCategory`, `deleteCategory`

✅ **CRUD Pattern**
- **Create**: Dedicated form page with validation
- **Read**: Reactive list page with Drift watch streams
- **Update**: Form page pre-fills existing data, saves changes
- **Delete**: Confirmation dialog, irreversible action warning

✅ **Navigation Pattern**
- Dedicated page for form instead of dialogs
- Page-based routing using Flutter Navigator
- Edit passes category parameter to form
- Delete uses modal confirmation dialog
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
