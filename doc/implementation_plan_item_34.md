# Implementation Plan - Item 34: PM - Filter Contracts

**Status:** ✅ DONE  
**Task:** Multiple filter options: by site, building, contract family, service provider, status, date ranges, amount ranges  
**Related Files:**
- `app/controllers/contracts_controller.rb`
- `app/views/contracts/index.html.erb`
- `app/javascript/controllers/contract_list_controller.js`

## Summary

Extended the contract filtering system from Task 33 by adding 9 new filter parameters, bringing the total to **17 filters**. Implemented a collapsible "Advanced Filters" panel to organize filters into basic (always visible) and advanced (collapsible) categories, maintaining a clean UI while providing powerful filtering capabilities.

## Filter Categories

### Basic Filters (Always Visible - 5 filters)
1. **Search** - Full-text search across contract number, title, contractor name
2. **Site** - Dropdown of sites from organization
3. **Building** - Dropdown of buildings from organization (**NEW**)
4. **Family** - Contract family classification (MAIN, NETT, CTRL, etc.)
5. **Status** - Contract status (Actif, Expiré, En attente, Suspendu)

### Advanced Filters (Collapsible - 12 filters)

#### Additional Filters (4 filters)
6. **Type** - Contract type dropdown (Contrat initial, Avenant, etc.)
7. **Subfamily** - Purchase subfamily dropdown
8. **Provider** - Partial text match on contractor organization name
9. **Renewal** - Renewal mode (Automatique, Manuelle, Tacite)

#### Date Range Filters (6 filters - 3 ranges)
10-11. **Signature Date** - From/To date range for signature_date
12-13. **Start Date** - From/To date range for execution_start_date
14-15. **End Date** - From/To date range for end_date

#### Amount Range Filters (4 filters - 2 ranges)
16-17. **Amount HT** - Min/Max range for annual_amount_ht
18-19. **Amount TTC** - Min/Max range for annual_amount_ttc

**Total: 17 filters working together with AND logic**

## Implementation Details

### 1. Controller Updates (`app/controllers/contracts_controller.rb`)

#### Extended `index` Action
```ruby
def index
  # ... existing code ...
  
  # Store filter values for the view (17 total filters)
  @filter_params = {
    # Basic filters (5)
    search: params[:search],
    site: params[:site],
    building: params[:building],  # NEW
    # ... existing filters ...
    # Date range filters (6) - NEW
    signature_date_from: params[:signature_date_from],
    signature_date_to: params[:signature_date_to],
    start_date_from: params[:start_date_from],
    start_date_to: params[:start_date_to],
    end_date_from: params[:end_date_from],
    end_date_to: params[:end_date_to],
    # Amount range filters (4) - NEW
    amount_ht_min: params[:amount_ht_min],
    amount_ht_max: params[:amount_ht_max],
    amount_ttc_min: params[:amount_ttc_min],
    amount_ttc_max: params[:amount_ttc_max]
  }
  
  # Get buildings for dropdown
  @buildings = Building.by_organization(current_user.organization_id).order(:name)
end
```

#### Enhanced `apply_filters` Method
```ruby
def apply_filters(contracts)
  # Existing filters (8)
  # ... search, site, type, family, subfamily, provider, renewal, status ...
  
  # Building filter (NEW - Task 34)
  if params[:building].present?
    contracts = contracts.where(building_id: params[:building])
  end
  
  # Date range filters (NEW - Task 34)
  if params[:signature_date_from].present?
    contracts = contracts.where("signature_date >= ?", params[:signature_date_from])
  end
  if params[:signature_date_to].present?
    contracts = contracts.where("signature_date <= ?", params[:signature_date_to])
  end
  # ... similar for start_date and end_date ranges ...
  
  # Amount range filters (NEW - Task 34)
  if params[:amount_ht_min].present?
    contracts = contracts.where("annual_amount_ht >= ?", params[:amount_ht_min].to_f)
  end
  if params[:amount_ht_max].present?
    contracts = contracts.where("annual_amount_ht <= ?", params[:amount_ht_max].to_f)
  end
  # ... similar for TTC amount range ...
  
  contracts
end
```

### 2. View Updates (`app/views/contracts/index.html.erb`)

#### Collapsible Filter UI Structure
```erb
<!-- Basic Filters (Always Visible) -->
<div class="filters-grid-contracts">
  <!-- 5 fields: Search, Site, Building, Family, Status -->
  <div>
    <label>Bâtiment</label>
    <%= f.select :building, options_for_select([['Tous les bâtiments', '']] + @buildings.map { |b| [b.name, b.id] }, @filter_params[:building]), ... %>
  </div>
</div>

<!-- Advanced Filters Toggle Button -->
<button type="button" data-action="click->contract-list#toggleAdvancedFilters" class="advanced-filters-toggle">
  <svg class="advanced-filters-icon"><!-- chevron icon --></svg>
  <span class="advanced-filters-text">Filtres Avancés (Dates, Montants, etc.)</span>
</button>

<!-- Advanced Filters (Collapsible) -->
<div id="advanced-filters" class="hidden">
  <!-- Additional Filters Section -->
  <h4>Filtres Additionnels</h4>
  <div class="filters-grid-contracts">
    <!-- 4 fields: Type, Subfamily, Provider, Renewal -->
  </div>
  
  <!-- Date Range Filters Section -->
  <h4>Filtres par Dates</h4>
  <div class="filters-grid-contracts">
    <!-- 3 date ranges: Signature, Start, End -->
    <div>
      <label>Date de Signature</label>
      <div style="display: flex; gap: var(--space-sm);">
        <%= f.date_field :signature_date_from, ... %>
        <span>→</span>
        <%= f.date_field :signature_date_to, ... %>
      </div>
    </div>
  </div>
  
  <!-- Amount Range Filters Section -->
  <h4>Filtres par Montants</h4>
  <div class="filters-grid-contracts">
    <!-- 2 amount ranges: HT and TTC -->
    <div>
      <label>Montant Annuel HT (€)</label>
      <div style="display: flex; gap: var(--space-sm);">
        <%= f.number_field :amount_ht_min, step: "0.01", min: "0", ... %>
        <span>→</span>
        <%= f.number_field :amount_ht_max, step: "0.01", min: "0", ... %>
      </div>
    </div>
  </div>
</div>
```

#### Visual Design Elements
- **Purple gradient toggle button** with chevron icon
- **Collapsible panel** with smooth CSS transitions
- **Section headers** with purple (#667eea) color
- **Arrow separators** (→) between range inputs
- **Responsive grid** that stacks on mobile

### 3. JavaScript Updates (`app/javascript/controllers/contract_list_controller.js`)

#### New `toggleAdvancedFilters` Method
```javascript
toggleAdvancedFilters(event) {
  event.preventDefault()
  
  const advancedPanel = document.getElementById('advanced-filters')
  const toggleButton = event.currentTarget
  const icon = toggleButton.querySelector('.advanced-filters-icon')
  const text = toggleButton.querySelector('.advanced-filters-text')
  
  if (advancedPanel) {
    const isHidden = advancedPanel.classList.contains('hidden')
    
    if (isHidden) {
      // Show advanced filters
      advancedPanel.classList.remove('hidden')
      icon.style.transform = 'rotate(180deg)'
      text.textContent = 'Masquer les Filtres Avancés'
    } else {
      // Hide advanced filters
      advancedPanel.classList.add('hidden')
      icon.style.transform = 'rotate(0deg)'
      text.textContent = 'Filtres Avancés (Dates, Montants, etc.)'
    }
  }
}
```

#### Updated `clearFilters` Method
```javascript
clearFilters(event) {
  event.preventDefault()
  
  if (this.hasFilterFormTarget) {
    const form = this.filterFormTarget
    form.querySelectorAll('input[type="text"]').forEach(input => input.value = '')
    form.querySelectorAll('input[type="number"]').forEach(input => input.value = '')  // NEW
    form.querySelectorAll('input[type="date"]').forEach(input => input.value = '')    // NEW
    form.querySelectorAll('select').forEach(select => select.value = '')
    
    form.submit()
  }
}
```

## Database Schema

No new migrations required. All filter fields already exist in `contracts` table:
- `building_id` (integer, nullable, indexed)
- `signature_date` (date, nullable)
- `execution_start_date` (date, nullable)
- `end_date` (date, nullable)
- `annual_amount_ht` (decimal, precision: 15, scale: 2)
- `annual_amount_ttc` (decimal, precision: 15, scale: 2)

## URL Parameters

All 17 filters are encoded in URL for bookmarkability:

```
/contracts?search=MAIN&site=1&building=5&family=MAIN&status=active
  &type=Contrat+initial&subfamily=CVC&provider=ENGIE&renewal=automatic
  &signature_date_from=2024-01-01&signature_date_to=2024-12-31
  &start_date_from=2024-06-01&start_date_to=2024-12-31
  &end_date_from=2025-01-01&end_date_to=2025-12-31
  &amount_ht_min=10000&amount_ht_max=100000
  &amount_ttc_min=12000&amount_ttc_max=120000
  &page=1&per_page=15
```

## UX Improvements

1. **Clean Initial UI** - Only 5 basic filters visible on load
2. **Progressive Disclosure** - Advanced filters hidden until needed
3. **Visual Feedback** - Toggle button changes text/icon on expand/collapse
4. **Consistent Design** - Matches existing filter styling from Task 33
5. **Mobile-Friendly** - All filters stack vertically on small screens
6. **Help Text** - Clear labels and placeholders guide users

## Testing Scenarios

### Basic Filter Combinations
1. Site + Building + Family → Shows contracts matching ALL criteria
2. Search + Status → Full-text search within status subset
3. Building alone → All contracts for selected building

### Date Range Testing
1. Signature date: 2024-01-01 to 2024-12-31 → Only 2024 signatures
2. Start date: From 2024-06-01 (no end) → All contracts starting after June
3. End date: To 2025-12-31 (no start) → All contracts ending before 2026
4. All 3 date ranges together → Complex temporal filtering

### Amount Range Testing
1. HT: Min 10000, Max 50000 → Contracts between 10k-50k EUR
2. HT: Min 20000 only → Contracts >= 20k
3. HT: Max 30000 only → Contracts <= 30k
4. HT + TTC ranges together → Both constraints applied

### Edge Cases
1. No matches → "Aucun contrat trouvé" message
2. All filters applied → Complex AND query works correctly
3. Clear all → All 17 filters reset, advanced panel closes
4. URL bookmark → Exact filtered view restores

## Performance Considerations

- **Query Optimization**: All filters use indexed columns where appropriate
- **Efficient SQL**: Multiple WHERE clauses combined in single query
- **No N+1 Queries**: Building dropdown pre-loaded in controller
- **Pagination**: Results paginated to limit memory usage

## Organization Isolation

All filters respect organization boundaries:
- Building dropdown: Only shows current user's organization buildings
- All queries: Scoped to `current_user.organization_id`
- No cross-organization data leakage

## Future Enhancements

Possible improvements for Brick 2:
1. **Saved Filters** - Save common filter combinations
2. **Filter Presets** - Quick access to "Expiring Soon", "High Value", etc.
3. **Filter Count Badges** - Show number of active filters
4. **Filter History** - Recently used filter combinations
5. **Export Filtered Results** - Export only filtered contracts

## Dependencies

**Gems:**
- None (uses standard Rails form helpers and Stimulus)

**Related Tasks:**
- Task 33: Contract List View (foundation)
- Task 13: Sites CRUD (provides site data)
- Task 14: Buildings CRUD (provides building data)
- Task 21: Contract Families (provides family classifications)

## Notes

- **Backward Compatible**: Existing Task 33 functionality fully preserved
- **No Breaking Changes**: All existing filters continue to work
- **Consistent Patterns**: Follows same filter architecture as Task 33
- **Clean Code**: Filter logic centralized in `apply_filters` method

## Completion Checklist

- [x] Added 9 new filter parameters to controller
- [x] Implemented building filter with dropdown
- [x] Implemented 3 date range filters (6 parameters)
- [x] Implemented 2 amount range filters (4 parameters)
- [x] Created collapsible advanced filters UI
- [x] Added toggle button with icon rotation
- [x] Updated JavaScript controller
- [x] Updated clear filters functionality
- [x] Tested all 17 filters individually
- [x] Tested complex filter combinations
- [x] Verified URL parameter persistence
- [x] Tested organization isolation
- [x] Updated backlogs.html with testing instructions
- [x] Created implementation documentation

**Implementation Date:** December 1, 2025  
**Developer:** Cline AI Assistant
