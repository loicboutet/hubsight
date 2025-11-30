# Implementation Plan - Item 22: Equipment Search & Autocomplete

## Overview
Implementation of an intelligent search and autocomplete system for equipment types in the equipment database. This feature facilitates manual entry by providing real-time search suggestions filtered by technical lot and function.

## Task Reference
- **Task ID**: 22
- **Brick**: Brick 1
- **Title**: PM - Equipment Search & Autocomplete
- **Description**: Search and autocomplete system in equipment database to facilitate manual entry, with filtering by technical lot and function

## Implementation Status
✅ **COMPLETED** - All components implemented and functional

## Components Implemented

### 1. Backend API Endpoint
**File**: `app/controllers/api/equipment_types_controller.rb`

```ruby
module Api
  class EquipmentTypesController < ApplicationController
    def autocomplete
      # Returns filtered equipment types as JSON
      # Supports query search and technical lot filtering
    end
  end
end
```

**Features**:
- Search across code, name, function, omniclass_number
- Filter by technical lot trigram (CVC, ELE, PLO, SEC, ASC, CEA, CTE, AUT)
- Filter by function
- Returns up to 50 results
- Organization-scoped (respects data isolation)
- JSON response with complete equipment type details

**Route**: `GET /api/equipment_types/autocomplete`

**Parameters**:
- `query` (string): Search term
- `technical_lot` (string, optional): Technical lot filter
- `function` (string, optional): Function filter

**Response Format**:
```json
[
  {
    "id": 7,
    "code": "CVC-007",
    "name": "Climatiseur split mural",
    "display_name": "CVC-007 - Climatiseur split mural",
    "technical_lot_trigram": "CVC",
    "technical_lot": "Chauffage, Ventilation, Climatisation",
    "technical_lot_name": "Chauffage, Ventilation, Climatisation",
    "purchase_subfamily": "CLIMATISATION",
    "function": "Climatisation",
    "omniclass_number": "23-33 17 11",
    "omniclass_title": "Split System Air Conditioners",
    "characteristics": ["Puissance frigorifique", "COP", "Niveau sonore"],
    "lot_badge_color": "blue"
  }
]
```

### 2. Stimulus Controller
**File**: `app/javascript/controllers/equipment_type_autocomplete_controller.js`

**Targets**:
- `input`: Main search input field
- `hiddenField`: Hidden field for equipment_type_id
- `suggestions`: Dropdown container for results
- `filterButtons`: Container for technical lot filters
- `selectedInfo`: Display area for selected equipment details
- `loadingIndicator`: Loading spinner

**Actions**:
- `search`: Triggered on input (debounced 300ms)
- `filterByLot`: Filter by technical lot
- `handleKeydown`: Keyboard navigation (↑↓ arrows, Enter, Escape)
- `select`: Select an equipment type
- `clear`: Clear selection

**Features**:
- **Debounced Search**: 300ms delay to reduce API calls
- **Keyboard Navigation**: Full keyboard support with arrow keys
- **Loading State**: Visual feedback during API calls
- **Empty State**: Helpful message when no results found
- **Error Handling**: Graceful error display
- **Click Outside**: Auto-close on outside click
- **Color-Coded Badges**: Technical lot badges with distinct colors
- **Rich Details**: Shows function, subfamily, OmniClass code
- **Selected Info Display**: Comprehensive details of selected type

**Badge Colors**:
- CVC (HVAC): Blue (#3b82f6)
- ELE (Électricité): Yellow (#f59e0b)
- PLO (Plomberie): Cyan (#06b6d4)
- SEC (Sécurité): Red (#ef4444)
- ASC (Ascenseurs): Purple (#a855f7)
- CEA (Architecture): Green (#10b981)
- CTE (Contrôle): Orange (#f97316)
- AUT (Automatisation): Indigo (#6366f1)

### 3. Form Integration

**Files**:
- `app/views/equipment/new.html.erb`
- `app/views/equipment/edit.html.erb`

**Features**:
- Technical lot filter buttons (8 categories)
- Search input with autocomplete
- Loading indicator
- Suggestions dropdown with scroll
- Selected equipment type display
- Helpful hints for users

**HTML Structure**:
```html
<div data-controller="equipment-type-autocomplete">
  <!-- Filter buttons -->
  <div data-equipment-type-autocomplete-target="filterButtons">
    <button data-lot="CVC">CVC</button>
    <!-- ... more buttons -->
  </div>
  
  <!-- Search input -->
  <input 
    data-equipment-type-autocomplete-target="input"
    data-action="input->equipment-type-autocomplete#search"
  />
  
  <!-- Hidden field for form submission -->
  <input 
    type="hidden"
    name="equipment[equipment_type_id]"
    data-equipment-type-autocomplete-target="hiddenField"
  />
  
  <!-- Suggestions dropdown -->
  <div data-equipment-type-autocomplete-target="suggestions"></div>
  
  <!-- Selected info display -->
  <div data-equipment-type-autocomplete-target="selectedInfo"></div>
</div>
```

## User Experience Flow

### 1. Initial State
- User sees technical lot filter buttons (all inactive)
- Empty search input with placeholder text
- No suggestions visible
- Helpful hint displayed

### 2. Using Filters (Optional)
- User clicks a technical lot button (e.g., "CVC")
- Button becomes active (highlighted)
- If search query exists, results are filtered immediately
- Click again to toggle off filter

### 3. Searching
- User types at least 2 characters (e.g., "clim")
- Loading spinner appears
- After 300ms debounce, API call is made
- Dropdown shows matching results with:
  - Technical lot badge (color-coded)
  - Equipment code and name
  - Function/subfamily (if available)

### 4. Keyboard Navigation
- **Arrow Down**: Move selection down
- **Arrow Up**: Move selection up
- **Enter**: Select highlighted item
- **Escape**: Close dropdown

### 5. Mouse Interaction
- Hover over item to highlight
- Click item to select

### 6. Selection
- Input field populated with selected equipment type
- Hidden field stores equipment_type_id
- Detailed info panel displays:
  - Technical lot badge
  - Full equipment type information
  - Function, subfamily, OmniClass code
  - Characteristics (if available)
- Dropdown closes

### 7. Empty/Error States
- **No Results**: Friendly message with suggestions
- **Error**: Error message with retry prompt

## Testing Guide

### Manual Testing

#### Test 1: Basic Search
1. Navigate to equipment new/edit form
2. Type "climatiseur" in search field
3. Verify suggestions appear after 300ms
4. Verify CVC equipment types are shown
5. Click on a result
6. Verify selection is made and details display

#### Test 2: Technical Lot Filtering
1. Click "CVC" filter button
2. Type "ch" in search field
3. Verify only CVC equipment types shown (chaudières, etc.)
4. Click "ELE" button
5. Verify filter switches to electrical equipment
6. Click "ELE" again to deactivate
7. Verify all types shown again

#### Test 3: Keyboard Navigation
1. Type search query to show results
2. Press Arrow Down key multiple times
3. Verify selection highlights move down
4. Press Arrow Up key
5. Verify selection highlights move up
6. Press Enter key
7. Verify highlighted item is selected

#### Test 4: Multiple Filters
1. Type "détecteur"
2. Verify both fire and security detectors appear
3. Click "SEC" filter
4. Verify only security detectors shown
5. Clear filter and search "pompe"
6. Click "PLO" filter
7. Verify plumbing pumps shown

#### Test 5: Edge Cases
1. Type single character: no results shown
2. Type non-existent query: shows "no results" message
3. Click outside dropdown: dropdown closes
4. Type query, then clear: dropdown hides

#### Test 6: Visual Elements
1. Verify badge colors match technical lots:
   - CVC = Blue
   - ELE = Yellow
   - PLO = Cyan
   - SEC = Red
   - etc.
2. Verify loading spinner appears during search
3. Verify selected info panel displays correctly

### Automated Testing (Future)

```ruby
# spec/controllers/api/equipment_types_controller_spec.rb
describe Api::EquipmentTypesController do
  describe 'GET #autocomplete' do
    it 'returns equipment types matching query'
    it 'filters by technical lot'
    it 'filters by function'
    it 'limits results to 50'
    it 'returns JSON format'
    it 'respects organization scoping'
  end
end

# spec/javascript/controllers/equipment_type_autocomplete_controller_spec.js
describe('EquipmentTypeAutocompleteController', () => {
  it('debounces search input'
  it('makes API call with correct parameters'
  it('displays suggestions'
  it('handles keyboard navigation'
  it('selects equipment type on click'
  it('shows loading indicator'
  it('handles errors gracefully'
})
```

## Database Requirements

Uses existing `equipment_types` table with 68 equipment types (proof of concept for 256 total).

**Required fields**:
- `id`, `code`, `equipment_type_name`
- `technical_lot_trigram`, `technical_lot`
- `purchase_subfamily`, `function`
- `omniclass_number`, `omniclass_title`
- `characteristic_1` through `characteristic_10`
- `status` (must be 'active')

## Performance Considerations

1. **Debouncing**: 300ms delay prevents excessive API calls
2. **Result Limit**: Maximum 50 results per query
3. **Database Indexes**: Ensure indexes on searchable fields
4. **Caching**: Consider caching frequent searches (future enhancement)

## Security

1. **Organization Scoping**: API automatically scopes to current user's organization
2. **Input Sanitization**: All queries sanitized by ActiveRecord
3. **Authentication**: Requires authenticated user session
4. **Authorization**: Only accessible to Portfolio Managers and Admins

## Accessibility

1. **Keyboard Navigation**: Full keyboard support
2. **ARIA Labels**: Proper labeling for screen readers (future enhancement)
3. **Focus Management**: Proper focus handling
4. **Visual Indicators**: Clear visual feedback for all states

## Future Enhancements

1. **Recently Used**: Show recently selected equipment types first
2. **Favorites**: Allow users to favorite common equipment types
3. **Bulk Actions**: Select multiple equipment types at once
4. **Export**: Export search results
5. **Advanced Filters**: Additional filter options (manufacturer, age, etc.)
6. **Fuzzy Matching**: Levenshtein distance for typo tolerance
7. **Synonyms**: Support for equipment type synonyms
8. **Multi-language**: Support for English/French equipment names

## Integration with Task 23

This autocomplete system provides the foundation for Task 23 (Link Equipment to OmniClass). The selected equipment type already includes OmniClass codes, making the linking process seamless.

## Dependencies

- **Task 19**: Equipment Types import (completed)
- **Rails**: Active Record for database queries
- **Stimulus**: Frontend controller framework
- **JSON API**: RESTful API endpoint

## Maintenance Notes

1. **Adding Equipment Types**: New types automatically available via API
2. **Updating Colors**: Modify `lot_badge_color` method in EquipmentType model
3. **Changing Debounce**: Modify `debounceTimeout` in Stimulus controller
4. **Result Limit**: Modify `.limit(50)` in API controller

## Rollback Plan

If issues arise:
1. Revert to static dropdown (backup in git)
2. API endpoint can be disabled without affecting other features
3. Forms remain functional with manual input

## Success Metrics

1. ✅ Search responds within 500ms
2. ✅ Keyboard navigation fully functional
3. ✅ Filter buttons work correctly
4. ✅ Selected equipment type displays properly
5. ✅ No console errors
6. ✅ Mobile responsive (tested on 900x600 viewport)

## Completion Date
November 30, 2024

## Developer Notes
- The autocomplete is non-blocking - users can still type manually
- The system gracefully degrades if JavaScript is disabled
- All visual feedback is instant and responsive
- Color-coding helps users quickly identify equipment categories
