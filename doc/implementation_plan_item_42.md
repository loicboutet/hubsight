# Task 42: PM - Export Equipment List

## Overview

This feature allows Portfolio Managers to export the complete equipment list to Excel (.xlsx) format with full hierarchy context (Site > Building > Level > Space). The export provides a comprehensive flat list view with all equipment details in a single sheet, ideal for analysis, filtering, and reporting.

## Implementation Details

### Components Created

#### 1. Service Class: `EquipmentListExporter`
**Location:** `app/services/equipment_list_exporter.rb`

**Purpose:** Handles the generation of Excel files with equipment data including full location hierarchy.

**Key Methods:**
- `initialize(organization)` - Sets up the exporter with organization context
- `generate` - Main method that generates the Excel file
- `generate_equipment_sheet(workbook)` - Creates single-sheet equipment export
- `add_header(sheet)` - Adds column headers
- `add_equipment_data(sheet)` - Populates equipment rows with data
- `apply_formatting(sheet)` - Applies Excel formatting (frozen headers, column widths)

**Features:**
- Organization-scoped data queries
- Proper eager loading to avoid N+1 queries (includes space, level, building, site)
- Formatted numbers, dates, and currency
- Styled headers with purple gradient background (#4F46E5)
- Auto-fit column widths for optimal readability
- Frozen header row for easy scrolling
- Comprehensive 28 columns of equipment data

#### 2. Controller: `ExportsController#equipment`
**Location:** `app/controllers/exports_controller.rb`

**Implementation:**
- Organization-scoped queries (current_user.organization)
- Excel file generation using EquipmentListExporter service
- Proper MIME type for .xlsx files
- Error handling with user-friendly French messages
- Automatic file download with descriptive filename

**Authorization:**
- Only Portfolio Managers and Admins can export
- Site Managers are blocked from accessing exports
- Uses existing `authorize_portfolio_manager!` callback

#### 3. View Integration
**Location:** `app/views/equipment/index.html.erb`

**Updates:**
- Added orange/yellow gradient export button in page header
- Button positioned next to "Nouvel Équipement" button
- Download icon (SVG) for visual clarity
- Button uses `data: { turbo: false }` to force full page reload (required for file downloads)
- Responsive layout with flexbox gap spacing

### Excel File Structure

**Single Sheet:** "Liste des Équipements"

**Columns (28 total):**

1. **Hierarchy Context (4 columns):**
   - Site
   - Bâtiment
   - Niveau
   - Espace

2. **Equipment Identification (7 columns):**
   - Nom Équipement
   - Type
   - Catégorie
   - Fabricant
   - Modèle
   - Numéro de Série
   - Référence BDD

3. **Technical Specifications (6 columns):**
   - Puissance Nominale
   - Tension Nominale
   - Courant
   - Fréquence
   - Poids (kg)
   - Dimensions

4. **Dates (4 columns):**
   - Date Fabrication
   - Date Mise en Service
   - Date Fin Garantie
   - Prochaine Maintenance

5. **Commercial Information (4 columns):**
   - Fournisseur
   - Prix d'Achat (formatted with € symbol)
   - Numéro Commande
   - Numéro Facture

6. **Status & Additional (3 columns):**
   - Statut (French labels: Actif, Inactif, En maintenance, etc.)
   - Criticité (French labels: Faible, Moyen, Élevé, Critique)
   - Notes

### Data Handling

**Null Values:** Displayed as "-" for consistency and readability

**Number Formatting:**
- Weight: Rounded to 2 decimal places
- Purchase price: Formatted with € symbol (e.g., "1250.00 €")

**Date Formatting:**
- Pattern: DD/MM/YYYY (French format)
- Example: 15/03/2023

**Status/Criticality:**
- Uses French labels from Equipment model methods
- `status_label`: Converts 'active' → 'Actif', 'maintenance' → 'En maintenance', etc.
- `criticality_label`: Converts 'low' → 'Faible', 'critical' → 'Critique', etc.

### Dependencies

#### Gems (Already in Gemfile from Task 43)
```ruby
gem "caxlsx", "~> 3.4"       # Excel (.xlsx) generation
gem "caxlsx_rails", "~> 0.6" # Rails integration for caxlsx
```

These gems provide:
- Excel 2007+ format (.xlsx) generation
- Cell styling (colors, fonts, borders)
- Column width control
- Frozen panes
- Number and date formatting

### Routes

**Exports Controller:**
```ruby
namespace :exports do
  get :contracts  # Task 41 (to be implemented)
  get :equipment  # Task 42 (implemented)
  get :sites      # Task 43 (implemented)
end
```

**URL:** `GET /exports/equipment`

### File Naming Convention

Generated files follow this pattern:
```
equipements_{organization_name}_{YYYYMMDD}.xlsx
```

**Examples:**
- `equipements_organization-1_20251201.xlsx`
- `equipements_acme-corp_20251201.xlsx`

### Data Scoping & Security

**Organization Isolation:**
- All queries scoped to `current_user.organization_id`
- Portfolio Manager from Organization A cannot export Organization B's equipment
- Enforced at both controller and service layer

**Query Optimization:**
```ruby
@organization.equipment
  .includes(space: { level: { building: :site } })
  .order('sites.name, buildings.name, levels.level_number, spaces.name, equipment.name')
```

**Benefits:**
- Single query with eager loading (4 levels deep)
- Prevents N+1 query problems
- Efficient ordering by full hierarchy
- Scalable to hundreds or thousands of equipment items

**Authorization:**
- Only Portfolio Managers and Admins allowed
- Other roles (Site Managers, Technicians) redirected with error message

### Styling & Formatting

**Header Styling:**
- Background color: #4F46E5 (purple/indigo - matches app theme)
- Text color: #FFFFFF (white)
- Bold text, size 11
- Center aligned
- Text wrapping enabled
- Frozen row (stays visible when scrolling)

**Column Widths:**
Optimized for content type:
- Site, Building, Level names: 20-25 chars
- Equipment name: 30 chars
- Technical fields: 12-18 chars
- Serial numbers, references: 15-20 chars
- Notes: 30 chars (allows longer text)

**Excel Features:**
- Frozen header row for scrolling
- Professional appearance
- Compatible with Excel, LibreOffice Calc, Google Sheets
- No formulas (pure data export)
- Ready for pivot tables and analysis

### Testing Checklist

**Functional Tests:**
- [x] Portfolio Manager can access /exports/equipment
- [ ] Excel file generates correctly
- [ ] Organization data properly scoped (no data leakage)
- [ ] Export button visible on equipment index page
- [ ] Button triggers download (not page navigation)

**Data Integrity Tests:**
- [ ] All equipment exported for organization
- [ ] Full hierarchy context included (Site > Building > Level > Space)
- [ ] Equipment ordered by location hierarchy
- [ ] Null values handled gracefully (shown as "-")
- [ ] Status and criticality labels in French
- [ ] Dates formatted correctly (DD/MM/YYYY)
- [ ] Currency formatted with € symbol
- [ ] Empty equipment list handled (empty Excel with headers only)

**Format Tests:**
- [ ] Headers styled correctly (purple background, white text, bold)
- [ ] All 28 columns present with correct labels
- [ ] Column widths appropriate for content
- [ ] Frozen header works when scrolling
- [ ] Numbers formatted with 2 decimals
- [ ] Dates formatted as DD/MM/YYYY

**Authorization Tests:**
- [ ] Portfolio Manager can export
- [ ] Admin can export
- [ ] Site Manager blocked from export (401/redirect)
- [ ] Unauthenticated user redirected to login

**Organization Isolation:**
- [ ] PM from Org 1 sees only Org 1 equipment
- [ ] PM from Org 2 sees only Org 2 equipment
- [ ] No cross-organization data leakage
- [ ] Equipment count matches organization filter

**Excel Compatibility:**
- [ ] File opens in Microsoft Excel (Windows/Mac)
- [ ] File opens in LibreOffice Calc
- [ ] File opens in Google Sheets (upload test)
- [ ] All formatting preserved
- [ ] All data readable
- [ ] No corruption or errors

**Edge Cases:**
- [ ] Organization with no equipment (graceful handling)
- [ ] Equipment without space (should not happen due to validation)
- [ ] Equipment with minimal data (many null fields)
- [ ] Very large datasets (1000+ equipment items)
- [ ] Special characters in equipment names
- [ ] Long text in notes field

### Error Handling

**Controller Level:**
```ruby
rescue StandardError => e
  Rails.logger.error "Equipment export error: #{e.message}"
  redirect_to equipment_index_path, alert: "Erreur lors de l'export: #{e.message}"
end
```

**Possible Errors:**
- Missing organization (nil current_user.organization)
- Database connection issues
- Excel generation errors (gem failures)
- Memory issues with very large datasets
- File system permissions

**User Experience:**
- All errors logged to Rails logger for debugging
- User sees friendly French error message
- Redirected back to equipment index
- Can retry export after issue is resolved

### Performance Considerations

**Query Efficiency:**
- Single database query with 4-level eager loading
- No N+1 problems
- Indexed foreign keys (space_id, building_id, level_id, site_id)
- Proper ordering at database level

**Memory Usage:**
- Excel generation done in memory
- Stream sent directly to browser
- No temporary files created
- Suitable for up to ~5,000 equipment items

**Response Time Estimates:**
- Small dataset (50 equipment): < 1 second
- Medium dataset (500 equipment): 1-2 seconds
- Large dataset (2000 equipment): 2-4 seconds
- Very large (5000+ equipment): Consider background job

**Future Optimization (if needed):**
- Use ActiveJob for very large exports
- Add progress indicator
- Email download link when ready
- Add export queue/scheduling
- Implement pagination/batching

### User Interface

**Export Button Location:**
- Top right of equipment index page
- Left of "Nouvel Équipement" button
- Part of header action buttons group

**Button Style:**
- Orange/yellow gradient (#f59e0b to #d97706)
- White text
- Download icon (SVG document with down arrow)
- Hover effects for better UX
- Touch-friendly on mobile

**Button Code:**
```erb
<%= link_to exports_equipment_path, 
    class: "typo-btn", 
    style: "background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; border: none;", 
    data: { turbo: false } do %>
  <svg><!-- Download icon --></svg>
  Exporter la Liste
<% end %>
```

**Mobile Responsive:**
- Buttons stack vertically on small screens
- Icons remain visible
- Touch-friendly tap targets
- Maintains spacing with flexbox gap

### Use Cases

**Primary Use Cases:**

1. **Equipment Inventory Report:**
   - Export all equipment for annual inventory
   - Share with management or auditors
   - Archive for compliance records

2. **Maintenance Planning:**
   - Filter by commissioning dates to identify aging equipment
   - Sort by next maintenance date
   - Group by site/building for planning routes

3. **Budget Analysis:**
   - Sort by purchase price for replacement planning
   - Calculate total equipment value
   - Identify high-value critical equipment

4. **Technical Documentation:**
   - Share equipment specifications with technicians
   - Provide to contractors for service planning
   - Reference during equipment upgrades

5. **Data Analysis:**
   - Import into BI tools
   - Create pivot tables in Excel
   - Generate custom reports
   - Trend analysis over time

### Maintenance Notes

**Adding New Columns:**

To add a new column to the export:

1. Update header in `add_header` method
2. Add data field in `add_equipment_data` method
3. Adjust column width in `apply_formatting` method
4. Update documentation

**Example - Adding GPS Coordinates:**
```ruby
# In add_header method
sheet.add_row [
  # ... existing columns ...
  'Coordonnées GPS',
  'Notes'
]

# In add_equipment_data method
sheet.add_row [
  # ... existing data ...
  equipment.gps_coordinates || '-',
  equipment.notes || '-'
]

# In apply_formatting method
sheet.column_widths(
  # ... existing widths ...
  20,  # Coordonnées GPS
  30   # Notes
)
```

**Changing Column Order:**
- Update all three methods consistently
- Maintain array index alignment
- Test after changes

**Performance Tuning:**
If export becomes slow:
1. Check database query explain plan
2. Ensure indexes exist on foreign keys
3. Consider adding database indexes
4. Implement background job for large exports

### Related Tasks

- **Task 17:** PM - Create and Manage Equipment (data source)
- **Task 16:** PM - Create and Manage Spaces (hierarchy context)
- **Task 15:** PM - Create and Manage Levels (hierarchy context)
- **Task 14:** PM - Create and Manage Buildings (hierarchy context)
- **Task 13:** PM - Create and Manage Sites (hierarchy context)
- **Task 41:** PM - Export Contract List (similar pattern, to be implemented)
- **Task 43:** PM - Export Sites Structure (implemented, similar pattern)

### Future Enhancements

**Potential Improvements:**

1. **Export Format Options:**
   - CSV export (simpler but no formatting)
   - PDF export (read-only report format)
   - JSON export (API integration)

2. **Filtering Options:**
   - Export specific sites only
   - Filter by status (only active equipment)
   - Filter by criticality
   - Filter by equipment type/category
   - Date range filters (commissioning date)

3. **Column Selection:**
   - User-selectable columns
   - Custom column order
   - Save export templates
   - Preset templates (Technical, Commercial, Minimal)

4. **Additional Formats:**
   - Grouped by site (visual hierarchy)
   - Summary statistics sheet
   - Charts embedded in Excel
   - Multiple sheets by category

5. **Scheduling:**
   - Weekly/monthly automatic exports
   - Email delivery
   - FTP/SFTP upload
   - Integration with BI tools

6. **Advanced Features:**
   - Include photos/attachments references
   - QR codes for equipment tracking
   - Maintenance history summary
   - Contract references
   - Equipment relationships/dependencies

### Support & Troubleshooting

**Common Issues:**

1. **Excel file doesn't download**
   - Check browser download settings
   - Verify `data: { turbo: false }` on link
   - Check browser console for JavaScript errors
   - Try different browser

2. **Empty/corrupt file**
   - Check Rails logs for errors
   - Verify organization has equipment
   - Test database connection
   - Check caxlsx gem version

3. **Permission denied**
   - Verify user has portfolio_manager role
   - Check authorization callback
   - Review user session validity
   - Confirm not logged in as site manager

4. **Slow export**
   - Check dataset size (>1000 equipment?)
   - Review database query performance
   - Check server resources (memory, CPU)
   - Consider background job implementation

5. **Missing data in export**
   - Check equipment associations (space, level, building, site)
   - Verify organization_id scoping
   - Review eager loading includes
   - Test with different organization

**Debug Commands:**
```ruby
# Rails console
org = Organization.first
exporter = EquipmentListExporter.new(org)
data = exporter.generate  # Test generation
data.present?  # Should return true

# Check equipment count
org.equipment.count

# Test with different organization
org2 = Organization.find(2)
exporter2 = EquipmentListExporter.new(org2)
data2 = exporter2.generate

# Test query
equipment = org.equipment.includes(space: { level: { building: :site } })
equipment.first.site  # Should not trigger additional query
```

### Documentation Links

- **Caxlsx Gem:** https://github.com/caxlsx/caxlsx
- **Rails Routing:** https://guides.rubyonrails.org/routing.html
- **ActiveRecord Includes:** https://guides.rubyonrails.org/active_record_querying.html#eager-loading-associations
- **Equipment Model:** app/models/equipment.rb
- **Task 43 Documentation:** doc/implementation_plan_item_43.md

### Testing Instructions

**Manual Testing Steps:**

1. **Setup:**
   - Ensure database has equipment data
   - Login as portfolio manager (portfolio@hubsight.com / Password123!)
   - Navigate to /equipment

2. **Export Test:**
   - Click "Exporter la Liste" button
   - Verify file downloads automatically
   - Check filename format: equipements_organization-1_YYYYMMDD.xlsx
   - Open file in Excel/LibreOffice/Google Sheets

3. **Content Verification:**
   - Verify header row is purple with white text, bold
   - Verify all 28 columns present
   - Verify equipment data matches database
   - Verify hierarchy context correct (Site > Building > Level > Space)
   - Verify dates formatted DD/MM/YYYY
   - Verify status/criticality in French
   - Verify currency formatted with €

4. **Authorization Test:**
   - Logout, login as site manager
   - Try accessing /exports/equipment directly
   - Verify redirected with error message

5. **Organization Isolation:**
   - Login as portfolio@hubsight.com - export, count equipment
   - Logout, login as portfolio2@hubsight.com - export, count equipment
   - Verify different counts, no data overlap

6. **Excel Functionality:**
   - Sort columns (verify works)
   - Filter columns (verify works)
   - Create pivot table (verify data structure supports it)
   - Frozen header scrolling (verify stays visible)

---

**Implementation Date:** December 1, 2025  
**Version:** 1.0  
**Status:** ✅ Complete
