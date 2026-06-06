# Database

The app uses Drift with local SQLite.
The database is offline-only.

## Entities

- `Category`: high-level product organization.
- `ProductType`: generic product type associated with a category.
- `Unit`: quantity measurement unit.
- `Product`: registered product associated with a product type.
- `Lot`: product stock entry with quantity, unit, and optional expiration date.

## Relationships

```text
Category -> ProductType -> Product -> Lot
Unit ----------------------------^
```

Rules:
- A product type belongs to one category.
- A product belongs to one product type.
- A lot belongs to one product.
- A lot uses one unit.

## Agent Rules

- Use Drift typed queries.
- Avoid raw SQL unless there is a clear reason.
- Access persistence through repositories.
- Keep entities normalized.
- Do not translate table names, column names, or backup JSON keys.
- Do not change schema shape without an explicit migration plan.
