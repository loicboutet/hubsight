# Implementation Plan - Item 33: PM - View Contract List

**Task**: Display contracts in list/table view with pagination, sorting, and column customization

**Status**: ✅ COMPLETED

**Date**: December 1, 2025

---

## Overview

This implementation provides Portfolio Managers with a comprehensive contract list view featuring:
- Real-time database queries with organization scoping
- Advanced filtering (8 parameters)
- Column sorting (ascending/descending)
- Column visibility customization
- Pagination (configurable items per page)
- Responsive design

---

## Implementation Details

### 1. Backend (Controller)

**File**: `app/controllers/contracts_controller.rb`

#### Key Features:

**Index Action**:
- Queries `Contract.by_organization(current_user.organization_id)` for data isolation
- Applies filters via `apply_filters` method
- Applies sorting via `apply_sorting` method
- Paginates with Kaminari (15 per page default, configurable)
- Stores column visibility preferences in user session

**Filtering Logic** (`apply_filters` method):
```ruby
# Search filter (contract_number, title, contractor_organization_name)
# Site filter (site_id)
# Contract type filter
# Family filter (contract_family LIKE)
# Subfamily filter (purchase_subfamily)
# Provider filter (contractor_organization_name LIKE)
# Renewal mode filter
# Status filter (active/expired/pending/suspended)
```

**Sorting Logic** (`apply_sorting` method):
- Validates column names against whitelist (SQL injection prevention)
- Handles NULL values (pushes them to end of results)
- Supports ASC/DESC directions
- Sortable columns:
  - contract_number
  - title
  - contractor_organization_name
  - annual_amount_ht
  - annual_amount_ttc
  - signature_date
  - execution_start_date
  - end_date
  - status
  - contract_type
  - purchase_subfamily

**Column Customization**:
- `update_columns` action stores preferences in session
- `default_columns` method defines default visible columns
- Session storage: `session[:contract_columns]`

### 2. Frontend (View)

**File**: `app/views/contracts/index.html.erb`

#### Key Features:

**Stimulus Controller Integration**:
- Controller: `contract-list`
- Targets: `columnCheckbox`, `table`, `filterForm`
- Actions: `sort`, `toggleColumn`, `clearFilters`, `toggleColumnDropdown`

**Filter Form**:
- 5 active filters displayed in responsive grid
- Search box (contract number, title, contractor)
- Site dropdown (populated from organization's sites)
- Type dropdown (populated from distinct contract types)
- Family dropdown (from ContractFamily.families_only)
- Status dropdown (active/expired/pending/suspended)
- Items per page selector (15/25/50/100)
- Clear button to reset all filters
- Submit button to apply filters

**Column Customization Dropdown**:
- Checkbox list for each column
- Real-time column show/hide
- Preferences saved via AJAX to session
- Positioned absolutely at top-right

**Data Table**:
- Sortable column headers (click to sort)
- Visual sort indicators (↑ ↓)
- Conditional column visibility based on user preferences
- Responsive horizontal scrolling
- Status badges with color coding
- Currency formatting for amounts
- Date formatting (DD/MM/YYYY)
- Action buttons (View, Edit)

**Pagination**:
- Kaminari gem integration
- Bootstrap 4 theme styling
- Shows page numbers and navigation
- Only displays if > 1 page

### 3. JavaScript (Stimulus Controller)

**File**: `app/javascript/controllers/contract_list_controller.js`

#### Methods:

1. **sort(event)**:
   - Captures column name and current direction
   - Toggles direction (asc ↔ desc)
   - Updates URL with sort parameters
   - Navigates to sorted view

2. **toggleColumn(event)**:
   - Shows/hides table columns in real-time
   - Saves preference via AJAX

3. **updateColumnVisibility(columnName, isVisible)**:
   - Updates CSS display property for th/td elements
   - Uses data-column attributes for targeting

4. **saveColumnPreferences()**:
   - Collects checked checkbox values
   - AJAX PATCH request to `/contracts/update_columns`
   - Stores in session storage

5. **clearFilters(event)**:
   - Clears all form inputs
   - Submits form to reload without filters

6. **toggleColumnDropdown(event)**:
   - Shows/hides column customization panel
   - Toggles `.hidden` class

7. **loadColumnPreferences()**:
   - Applies saved column visibility on page load
   - Reads from checkbox states

### 4. Routes

**File**: `config/routes.rb`

Added route for column preferences:
```ruby
patch 'update_columns'  # PATCH /contracts/update_columns
```

---

## Database Queries

### Main Query Structure:

```ruby
@contracts = Contract.by_organization(current_user.organization_id)
  .where(/* filters */)
  .order("#{sort_column} #{sort_direction}")
  .page(params[:page])
  .per(params[:per_page] || 15)
```

### Performance Optimizations:

1. **Organization Scoping**: Single WHERE clause for data isolation
2. **Index Usage**: Assumes indexes on:
   - organization_id
   - contract_number
   - status
   - contract_type
   - site_id
3. **Pagination**: Only loads current page records
4. **Count Queries**: Kaminari handles total_count efficiently

---

## User Experience Features

### 1. Filter Persistence
- Filter values preserved in URL parameters
- Can bookmark filtered views
- Back button works correctly

### 2. Column Customization
- Preferences saved per user session
- Survives page refreshes
- Quick toggle via dropdown
- Visual feedback (checkboxes)

### 3. Sorting
- Click any column header to sort
- Visual indicators show current sort
- Toggle between ASC/DESC
- URL-based (shareable links)

### 4. Pagination
- Configurable items per page
- Page numbers in URL
- Jump to any page
- First/Last/Prev/Next navigation

### 5. Responsive Design
- Mobile-friendly filters (stack vertically)
- Horizontal scroll for table on small screens
- Touch-friendly buttons
- Adaptive grid layout

---

## Testing Guide

### Test 1: Basic Display
```
1. Login as portfolio manager (portfolio@hubsight.com / Password123!)
2. Navigate to /contracts
3. Verify contracts table displays with real data
4. Verify pagination shows correct page count
5. Verify total contract count displays in header
```

### Test 2: Sorting
```
1. Click "N° Contrat" header
2. Verify contracts sort by contract number ascending
3. Verify ↑ indicator appears
4. Click again - verify descending sort with ↓ indicator
5. Test other columns (Title, Amount, Dates)
6. Verify NULL values appear at end
```

### Test 3: Filtering
```
1. Enter search term in "Recherche" box
2. Click "Filtrer" button
3. Verify only matching contracts display
4. Add site filter - verify combined filters work
5. Add family filter - verify further narrows results
6. Click "Effacer" - verify all filters clear
7. Verify URL parameters update correctly
```

### Test 4: Column Customization
```
1. Click "Colonnes" button
2. Verify dropdown appears with column checkboxes
3. Uncheck "Type" checkbox
4. Verify Type column hides immediately
5. Check it again - verify column reappears
6. Refresh page - verify preferences persist
7. Open DevTools Network tab
8. Toggle column - verify AJAX request to update_columns
```

### Test 5: Pagination
```
1. If contracts < 15, create more test contracts
2. Verify pagination controls appear at bottom
3. Click page 2 - verify loads next 15 contracts
4. Change "Afficher" to 25 - verify shows 25 per page
5. Verify page resets to 1 when changing per_page
6. Test First/Last/Prev/Next buttons
```

### Test 6: Organization Isolation
```
1. Login as portfolio@hubsight.com
2. Note count of contracts for Organization 1
3. Logout and login as portfolio2@hubsight.com
4. Verify sees only Organization 2 contracts
5. Verify completely different data (no overlap)
6. Test filters work independently per organization
```

### Test 7: Combined Features
```
1. Apply search filter: "Maintenance"
2. Add family filter: "MAIN"
3. Sort by Amount HT descending
4. Hide "Type" and "Sous-famille" columns
5. Change to 25 items per page
6. Navigate to page 2
7. Verify URL contains all parameters
8. Copy URL and open in new tab
9. Verify exact same view loads (all filters/sort/columns)
```

### Test 8: Empty States
```
1. Apply filter with no matches
2. Verify "Aucun contrat trouvé" message displays
3. Click "Effacer" - verify contracts reappear
```

### Test 9: Performance
```
1. Create 100+ test contracts
2. Navigate to /contracts
3. Verify page loads in < 1 second
4. Apply filters - verify instant response
5. Sort columns - verify immediate update
6. Toggle columns - verify no lag
7. Change pagination - verify smooth transition
```

### Test 10: Mobile Responsiveness
```
1. Open /contracts on mobile device or resize browser to 768px
2. Verify filter grid stacks vertically
3. Verify table scrolls horizontally
4. Verify buttons remain accessible
5. Verify column dropdown is usable
6. Test all interactions work on touch
```

---

## Security Considerations

### 1. SQL Injection Prevention
✅ Column names validated against whitelist
✅ User inputs sanitized via ActiveRecord query methods
✅ No raw SQL with user input

### 2. Authorization
✅ Organization scoping on all queries
✅ `by_organization(current_user.organization_id)` enforced
✅ No cross-organization data leakage

### 3. CSRF Protection
✅ AJAX requests include CSRF token
✅ Form submissions protected by Rails default

### 4. Session Security
✅ Column preferences stored in session (server-side)
✅ No sensitive data in client-side storage

---

## Future Enhancements

### Potential Improvements:

1. **Saved Filters**:
   - Allow users to save favorite filter combinations
   - Named filter presets
   - Quick-apply saved searches

2. **Bulk Actions**:
   - Select multiple contracts
   - Bulk export
   - Bulk status update
   - Bulk delete

3. **Advanced Search**:
   - Date range picker
   - Amount range slider
   - Multiple simultaneous filters per field

4. **Column Reordering**:
   - Drag-and-drop column reodering
   - Save custom column order

5. **Export Current View**:
   - Export filtered/sorted contracts to Excel
   - PDF generation of current view
   - Email report

6. **Real-time Updates**:
   - ActionCable for live contract updates
   - Notifications for new contracts
   - Collaborative filtering (see what colleagues filter)

---

## Dependencies

- **Kaminari**: Pagination gem (already installed)
- **Stimulus**: JavaScript framework (already configured)
- **Rails 8**: ActiveRecord query interface
- **Bootstrap 4**: For pagination theme (optional)

---

## Files Modified

1. ✅ `app/controllers/contracts_controller.rb` - Controller logic
2. ✅ `app/views/contracts/index.html.erb` - View template
3. ✅ `app/javascript/controllers/contract_list_controller.js` - Stimulus controller
4. ✅ `config/routes.rb` - Added update_columns route
5. ✅ `doc/implementation_plan_item_33.md` - This documentation

---

## Compatibility

- **Rails Version**: 8.0+
- **Ruby Version**: 3.0+
- **Browsers**: Chrome, Firefox, Safari, Edge (latest versions)
- **Mobile**: iOS 12+, Android 8+

---

## Notes

- Column preferences stored in session (temporary per login)
- Filter values preserved in URL (bookmarkable)
- Sorting is server-side (handles large datasets)
- Pagination efficient (doesn't load all records)
- Organization isolation enforced at query level
- Responsive design supports all screen sizes

---

## Related Tasks

- Task 34: PM - Filter Contracts (extended filtering)
- Task 41: PM - Export Contract List (export functionality)
- Task 52: System - Data Isolation (security foundation)

---

## Completion Checklist

- [x] Controller updated with real queries
- [x] Filtering logic implemented (8 parameters)
- [x] Sorting logic implemented with validation
- [x] Pagination configured (Kaminari)
- [x] Column customization working
- [x] Stimulus controller created
- [x] View updated with real data
- [x] Routes configured
- [x] Organization isolation verified
- [x] Documentation complete
- [x] Ready for testing

**Status**: ✅ Implementation Complete - Ready for User Testing
