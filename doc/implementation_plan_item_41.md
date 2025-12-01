# Task 41: PM - Export Contract List

## Overview
Export contract list to Excel/CSV with selected columns and applied filters.

## Implementation Status
✅ **COMPLETED**

## Technical Implementation

### Files Created
1. **app/services/contract_list_exporter.rb** - Service class for generating Excel exports
2. **doc/implementation_plan_item_41.md** - This documentation

### Files Modified
1. **app/controllers/exports_controller.rb** - Implemented contracts export action

## Features

### 1. Respects Current Filters
The export includes only contracts that match the currently applied filters:
- **Search**: Contract number, title, or contractor name
- **Site**: Specific site filter
- **Type**: Contract type filter
- **Family**: Contract family filter (MAIN, NETT, CTRL, etc.)
- **Subfamily**: Purchase subfamily filter
- **Status**: Active, Pending, Expired, Suspended

### 2. Respects Column Visibility
Only exports columns that the user has visible in their current view:
- Uses session storage: `session[:contract_columns]`
- Default columns if no preferences set

### 3. Respects Current Sort Order
Exports data in the same order as displayed in the list:
- Sort column (contract_number, title, amounts, dates, etc.)
- Sort direction (ascending/descending)
- NULL handling (NULL values appear at end)

### 4. Excel File Features
- **Sheet name**: "Liste des Contrats"
- **Header styling**: Purple background (#4F46E5), white text, bold
- **Frozen header**: Header row stays visible when scrolling
- **Column widths**: Optimized for content readability
- **Date formatting**: DD/MM/YYYY
- **Currency formatting**: X.XX €
- **Status labels**: French translations

### 5. Available Columns
- N° Contrat
- Titre
- Prestataire
- Type
- Famille
- Sous-famille
- Site
- Montant HT
- Montant TTC
- Date Signature
- Date Début
- Date Fin
- Statut

### 6. Filename Pattern
```
contrats_{organization-name}_{YYYYMMDD}.xlsx
```
Example: `contrats_organization-1_20251201.xlsx`

## Testing Guide

### Prerequisites
- Login as portfolio manager (portfolio@hubsight.com / Password123!)
- Ensure organization has contracts in database

### Test 1: Basic Export (No Filters)
1. Navigate to `/contracts`
2. Verify you see list of contracts
3. Click "Exporter" button (gray button with file icon)
4. Verify Excel file downloads
5. Open file in Excel/LibreOffice/Google Sheets
6. Verify:
   - Sheet named "Liste des Contrats"
   - Purple header row with white text
   - All contracts from organization visible
   - Default columns displayed (9 columns)
   - Dates formatted as DD/MM/YYYY
   - Amounts formatted with € symbol
   - Status labels in French (Actif, En attente, Expiré, Suspendu)

### Test 2: Export with Search Filter
1. Navigate to `/contracts`
2. Enter "MAIN" in search box
3. Click "Filtrer" button
4. Verify filtered contracts display in list
5. Click "Exporter" button
6. Open exported file
7. Verify:
   - Only contracts matching "MAIN" search are exported
   - Row count matches filtered list (not total contracts)

### Test 3: Export with Site Filter
1. Navigate to `/contracts`
2. Select specific site from "Site" dropdown
3. Click "Filtrer"
4. Verify filtered contracts display
5. Click "Exporter"
6. Verify exported file contains only contracts for selected site

### Test 4: Export with Multiple Filters
1. Navigate to `/contracts`
2. Apply multiple filters:
   - Search: "CVC"
   - Family: "Maintenance"
   - Status: "Actif"
3. Click "Filtrer"
4. Click "Exporter"
5. Verify exported file matches the filtered view exactly

### Test 5: Export with Column Customization
1. Navigate to `/contracts`
2. Click "Colonnes" button
3. Uncheck "Type" and "Sous-famille" columns
4. Verify these columns disappear from table
5. Click "Exporter"
6. Open exported file
7. Verify:
   - "Type" column NOT in export
   - "Sous-famille" column NOT in export
   - Other visible columns present
8. Close file
9. Click "Colonnes" again
10. Check "Type" and "Sous-famille" back
11. Export again
12. Verify columns now appear in new export

### Test 6: Export with Sorting
1. Navigate to `/contracts`
2. Click "Montant HT" column header to sort by amount descending
3. Verify arrow points down (↓)
4. Click "Exporter"
5. Open exported file
6. Verify data sorted by amount (highest first)
7. Verify NULL amounts appear at end

### Test 7: Organization Isolation
1. Login as portfolio@hubsight.com (Organization 1)
2. Navigate to `/contracts`
3. Note contract count
4. Click "Exporter"
5. Open file, count rows
6. Logout
7. Login as portfolio2@hubsight.com (Organization 2)
8. Navigate to `/contracts`
9. Note contract count (should be different)
10. Click "Exporter"
11. Open file, count rows
12. Verify:
    - Two files have different data
    - No overlap of contracts between organizations
    - Different filenames (organization-1 vs organization-2)

### Test 8: Authorization Check
1. Logout
2. Login as site manager (sitemanager@hubsight.com)
3. Navigate to `/my_contracts` (site manager contracts view)
4. Verify "Exporter" button NOT visible
5. Try accessing `/exports/contracts` directly via URL
6. Verify redirect to root with error message: "Accès non autorisé. Seuls les gestionnaires de portefeuille peuvent exporter des données."

### Test 9: Empty State
1. Login as portfolio manager with no contracts (or temporarily filter to show zero results)
2. Click "Exporter"
3. Open exported file
4. Verify:
   - Header row present
   - No data rows (just headers)
   - No errors or crashes

### Test 10: Large Dataset Performance
1. If organization has >100 contracts, apply no filters
2. Click "Exporter"
3. Verify:
   - File generates within 5 seconds
   - All contracts included
   - No timeout errors
   - File opens correctly in Excel

### Test 11: Excel Compatibility
1. Export a file with various data
2. Test opening in:
   - **Microsoft Excel** (Windows/Mac)
   - **LibreOffice Calc**
   - **Google Sheets** (upload file)
3. Verify in each:
   - Formatting preserved
   - Header frozen (scrolling works)
   - Currency symbols display correctly
   - Date format readable
   - No garbled characters

### Test 12: Combined Filters + Columns + Sort
1. Apply search filter: "energie"
2. Apply status filter: "Actif"
3. Hide "Type" and "Prestataire" columns
4. Sort by "Date début" ascending
5. Click "Exporter"
6. Verify exported file:
   - Only "energie" contracts with "Actif" status
   - Missing "Type" and "Prestataire" columns
   - Sorted by start date (earliest first)

## Error Handling

### Edge Cases Handled
1. **No contracts**: Exports header-only file
2. **NULL values**: Displays "-" for missing data
3. **Missing dates**: NULL dates sorted to end
4. **Missing amounts**: NULL amounts sorted to end
5. **Long text**: Column widths accommodate content
6. **Special characters**: Handled properly in Excel
7. **Organization parameterization**: Handles spaces/special chars in org name

### Error Scenarios
If export fails:
1. Error logged to Rails log with full message
2. User redirected to `/contracts` with error alert
3. Alert message: "Erreur lors de l'export: [error details]"

## Service Class Architecture

### ContractListExporter
```ruby
class ContractListExporter
  def initialize(organization, filter_params, visible_columns)
    # Store context
  end

  def generate
    # Create Excel package
    # Generate sheet with headers and data
    # Return Excel binary data
  end

  private

  def add_header(sheet)
    # Build dynamic header based on visible columns
  end

  def add_contract_data(sheet)
    # Add rows with proper formatting
  end

  def apply_filters(contracts)
    # Apply same filters as ContractsController#index
  end

  def apply_sorting(contracts)
    # Apply same sorting as ContractsController#index
  end
end
```

## Design Patterns

### Service Object Pattern
- Follows single responsibility principle
- Separates export logic from controller
- Reusable and testable

### Same Query as Index
- Uses same filter logic as `ContractsController#index`
- Ensures WYSIWYG (What You See Is What You Get)
- Maintains consistency between view and export

### Session-based Preferences
- Column visibility stored in session
- Persists across page refreshes
- User-specific customization

## Database Queries

### Optimized Loading
```ruby
contracts = @organization.contracts
  .includes(:site)  # Eager load site association
  .where(...)       # Apply filters
  .order(...)       # Apply sorting
```

### Organization Scoping
All queries automatically scoped to current user's organization:
```ruby
@organization.contracts  # Already filtered by organization_id
```

## Security Considerations

1. **Authorization**: Only portfolio managers and admins can export
2. **Organization isolation**: Queries scoped by organization_id
3. **SQL injection prevention**: Uses parameterized queries
4. **Column validation**: Only allowed columns exported
5. **No sensitive data**: Exports only visible contract data

## Maintenance Notes

### Adding New Export Columns
To add a new column to export:
1. Add column name to header in `add_header` method
2. Add data retrieval in `add_contract_data` method
3. Add column width in `apply_formatting` method
4. Add column name to allowed list in view's column customization

### Modifying Formatting
- Header style: `header_style` method
- Date formatting: `format_date` method
- Currency formatting: `format_currency` method
- Status labels: `format_status` method

## Related Tasks
- **Task 33**: PM - View Contract List (provides the list view)
- **Task 42**: PM - Export Equipment List (similar export pattern)
- **Task 43**: PM - Export Sites Structure (similar export pattern)

## Future Enhancements
Potential improvements for Brick 2:
- CSV format option
- PDF export option
- Scheduled exports (email reports)
- Custom column selection in export dialog
- Additional filter options (date ranges, amount ranges)
- Export templates (pre-configured column/filter sets)
