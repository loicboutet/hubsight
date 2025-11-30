# Implementation Plan - Item 23: PM - Link Equipment to OmniClass

**Task**: Manual linking interface for associating equipment with OmniClass classification codes via search system

**Status**: ✅ COMPLETED

**Date**: November 30, 2025

---

## Overview

Task 23 implements the manual linking interface for associating equipment with OmniClass Table 23 classification codes. This feature builds upon Task 22 (Equipment Search & Autocomplete) and Task 19 (Import OmniClass Table 23) to provide a complete workflow for linking equipment to standardized BIM classification codes.

## Technical Implementation

### 1. Database Schema

The equipment table already has the necessary foreign key relationship:

```ruby
# db/schema.rb
create_table "equipment" do |t|
  # ... other fields ...
  t.integer "equipment_type_id"
  # ... other fields ...
end

add_foreign_key "equipment", "equipment_types"
```

### 2. Model Association

```ruby
# app/models/equipment.rb
class Equipment < ApplicationRecord
  belongs_to :equipment_type, optional: true
  # ... other associations and validations ...
end

# app/models/equipment_type.rb
class EquipmentType < ApplicationRecord
  has_many :equipment, dependent: :nullify
  # ... validations and scopes ...
end
```

### 3. Controller Updates

**File**: `app/controllers/equipment_controller.rb`

Added `:equipment_type_id` to permitted parameters:

```ruby
def equipment_params
  params.require(:equipment).permit(
    :space_id,
    :name,
    :equipment_type,
    :equipment_type_id,  # ← Added for OmniClass linking
    :equipment_category,
    # ... other fields ...
  )
end
```

### 4. Views Integration

#### Create Form (new.html.erb)

The form includes the complete equipment type autocomplete widget with:
- **8 Technical Lot Filter Buttons**: CVC, ELE, PLO, SEC, ASC, CEA, CTE, AUT
- **Search Input**: With debounced search (300ms delay)
- **Autocomplete Dropdown**: Displays matching equipment types with OmniClass codes
- **Selected Info Panel**: Shows full details of selected type
- **Loading Indicator**: Visual feedback during API calls

```erb
<div data-controller="equipment-type-autocomplete">
  <!-- Filter Buttons -->
  <div data-equipment-type-autocomplete-target="filterButtons">
    <button type="button" data-lot="CVC" data-action="click->equipment-type-autocomplete#filterByLot">CVC</button>
    <!-- ... 7 more buttons ... -->
  </div>
  
  <!-- Search Input -->
  <input 
    type="text" 
    data-equipment-type-autocomplete-target="input"
    data-action="input->equipment-type-autocomplete#search keydown->equipment-type-autocomplete#handleKeydown"
    placeholder="Rechercher un type d'équipement (ex: climatiseur, chaudière...)"
  />
  
  <!-- Hidden Field for equipment_type_id -->
  <input 
    type="hidden" 
    name="equipment[equipment_type_id]"
    data-equipment-type-autocomplete-target="hiddenField"
  />
  
  <!-- Suggestions Dropdown -->
  <div data-equipment-type-autocomplete-target="suggestions"></div>
  
  <!-- Selected Info Panel -->
  <div data-equipment-type-autocomplete-target="selectedInfo"></div>
</div>
```

#### Edit Form (edit.html.erb)

Same autocomplete widget as create form, but pre-populated with existing values:

```erb
<input 
  type="text" 
  data-equipment-type-autocomplete-target="input"
  value="<%= @equipment.equipment_type&.display_name %>"
/>
<input 
  type="hidden" 
  name="equipment[equipment_type_id]"
  value="<%= @equipment.equipment_type_id %>"
  data-equipment-type-autocomplete-target="hiddenField"
/>
```

#### Show Page (show.html.erb)

Updated to display dynamic OmniClass data from the `equipment_type` association:

**Type d'Équipement Field**:
```erb
<% if @equipment.equipment_type %>
  <p class="typo-body-small typo-bold">
    <%= @equipment.equipment_type.equipment_type_name %>
    <% if @equipment.equipment_type.technical_lot_trigram.present? %>
      <span style="background-color: <%= lot_color %>; color: white;">
        <%= @equipment.equipment_type.technical_lot_trigram %>
      </span>
    <% end %>
  </p>
<% else %>
  <p class="typo-body-small typo-bold">Non spécifié</p>
<% end %>
```

**Référence OmniClass Field**:
```erb
<% if @equipment.equipment_type&.omniclass_number.present? %>
  <p class="typo-body-small typo-bold">
    <%= @equipment.equipment_type.omniclass_number %>
    <% if @equipment.equipment_type.omniclass_title.present? %>
      <span style="color: var(--medium-gray);">
        (<%= @equipment.equipment_type.omniclass_title %>)
      </span>
    <% end %>
  </p>
<% else %>
  <p class="typo-body-small" style="color: var(--medium-gray);">Non spécifié</p>
<% end %>
```

**Sous-domaine Achat Field**:
```erb
<% if @equipment.equipment_type&.purchase_subfamily.present? %>
  <p class="typo-body-small typo-bold">
    <%= @equipment.equipment_type.technical_lot_trigram %> - 
    <%= @equipment.equipment_type.purchase_subfamily %>
  </p>
<% elsif @equipment.equipment_type&.technical_lot.present? %>
  <p class="typo-body-small typo-bold">
    <%= @equipment.equipment_type.technical_lot %>
  </p>
<% else %>
  <p class="typo-body-small" style="color: var(--medium-gray);">Non spécifié</p>
<% end %>
```

### 5. JavaScript Controller

**File**: `app/javascript/controllers/equipment_type_autocomplete_controller.js`

Already implemented in Task 22. Key features:
- Debounced search (300ms)
- Technical lot filtering
- Keyboard navigation (Arrow Up/Down, Enter, Escape)
- Visual feedback (loading spinner, badges, colors)
- Displays OmniClass codes, characteristics, and hierarchy

### 6. API Endpoint

**File**: `app/controllers/api/equipment_types_controller.rb`

Already implemented in Task 22:

```ruby
class Api::EquipmentTypesController < ApplicationController
  def autocomplete
    query = params[:query]
    technical_lot = params[:technical_lot]
    
    equipment_types = EquipmentType.active
    equipment_types = equipment_types.by_technical_lot(technical_lot) if technical_lot.present?
    equipment_types = equipment_types.search(query) if query.present?
    equipment_types = equipment_types.ordered.limit(50)
    
    render json: equipment_types.map { |et| 
      {
        id: et.id,
        code: et.code,
        name: et.equipment_type_name,
        display_name: et.display_name,
        technical_lot_trigram: et.technical_lot_trigram,
        technical_lot_name: et.technical_lot_name,
        function: et.function,
        purchase_subfamily: et.purchase_subfamily,
        omniclass_number: et.omniclass_number,
        omniclass_title: et.omniclass_title,
        characteristics: et.characteristics,
        lot_badge_color: et.lot_badge_color
      }
    }
  end
end
```

---

## Features

### 1. Equipment Type Autocomplete Search

- **Minimum Characters**: 2 characters required to trigger search
- **Debounce**: 300ms delay to reduce API calls
- **Results Limit**: Maximum 50 results per search
- **Search Fields**: Searches across code, name, OmniClass number, and function

### 2. Technical Lot Filtering

8 filter buttons for technical lots:
- **CVC** (Blue): Chauffage, Ventilation, Climatisation
- **ELE** (Yellow): Électricité
- **PLO** (Cyan): Plomberie
- **SEC** (Red): Sécurité et Systèmes d'Urgence
- **ASC** (Purple): Ascenseurs et Élévateurs
- **CEA** (Green): Corps d'État Architecturaux
- **CTE** (Orange): Contrôle Technique
- **AUT** (Indigo): Automatisation et GTB

### 3. Visual Display

Each autocomplete result shows:
- **Technical Lot Badge**: Color-coded (CVC=Blue, ELE=Yellow, etc.)
- **Equipment Code**: e.g., "CVC-007"
- **Equipment Name**: e.g., "Climatiseur split mural"
- **Function**: e.g., "Climatisation des locaux"
- **Purchase Subfamily**: e.g., "CLIMATISATION"

### 4. Selected Equipment Type Info Panel

After selection, displays:
- Technical lot badge with full name
- Complete equipment type name and code
- Function and purchase subfamily
- OmniClass Table 23 code and title
- Characteristics (dynamic, from characteristic_1 to characteristic_10)

### 5. Keyboard Navigation

- **Arrow Down/Up**: Navigate through suggestions
- **Enter**: Select highlighted item
- **Escape**: Close dropdown

### 6. OmniClass Code Display on Show Page

Displays with proper nil checking:
- Equipment type name with color-coded technical lot badge
- Full OmniClass code with title (e.g., "23-33 11 11 (Gas Boilers)")
- Purchase subfamily with technical lot prefix
- Graceful fallback to "Non spécifié" for missing data

---

## Testing Guide

### Prerequisites

1. Database must be seeded with equipment types: `bin/rails db:seed`
2. Login as portfolio manager: `portfolio@hubsight.com / Password123!`

### Test 1: Create Equipment with OmniClass Link

**Steps**:
1. Navigate to a space (e.g., /spaces/1)
2. Click "Nouvel Équipement" button
3. Fill equipment name (e.g., "Climatiseur Daikin AC-500")
4. In "Type d'Équipement" field, type "clim" (minimum 2 characters)
5. Verify loading spinner appears briefly
6. Verify autocomplete dropdown shows matching results with CVC badges
7. Click "CVC" filter button
8. Verify dropdown shows only CVC equipment types
9. Click on "CVC-007 - Climatiseur split mural"
10. Verify selected info panel appears showing full details
11. Verify hidden field populated with equipment_type_id
12. Fill manufacturer (e.g., "Daikin")
13. Submit form
14. Verify creation success message
15. Verify redirect to equipment show page

**Expected Results**:
- Equipment created successfully with equipment_type_id saved
- Show page displays OmniClass information from linked equipment type

### Test 2: Filter by Technical Lot

**Steps**:
1. Go to equipment new/edit page
2. Type "détecteur" in search field
3. Verify results include both fire detectors (SEC badge, red) and other types
4. Click "SEC" filter button
5. Verify button highlighted (blue background, white text)
6. Verify dropdown shows only security-related detectors (SEC badge, red)
7. Click "SEC" button again
8. Verify filter deactivated (button returns to normal)
9. Verify all detector types shown again

**Expected Results**:
- Filtering correctly limits results to selected technical lot
- Visual feedback shows active filter
- Toggle behavior works correctly

### Test 3: Keyboard Navigation

**Steps**:
1. Type "pompe" in search field to show results
2. Press Arrow Down key multiple times
3. Verify highlight moves down through results
4. Verify selected item scrolls into view if needed
5. Press Arrow Up key
6. Verify highlight moves up
7. Press Enter key on highlighted item
8. Verify item selected and form updated
9. Type search query again
10. Press Escape key
11. Verify dropdown closes

**Expected Results**:
- Keyboard navigation works smoothly
- Visual highlight updates correctly
- Enter selects item, Escape closes dropdown

### Test 4: Edit Equipment with Existing OmniClass Link

**Steps**:
1. Navigate to an existing equipment (e.g., /equipment/1)
2. Click "Éditer" button
3. Verify autocomplete field pre-populated with current equipment type
4. Verify selected info panel shows current type details
5. Change equipment type: type "chaud" in search
6. Select "CVC-001 - Chaudière gaz murale"
7. Verify selected info panel updates with new type
8. Submit form
9. Verify update success message
10. Verify show page displays new OmniClass information

**Expected Results**:
- Edit form correctly shows existing equipment type
- Can change equipment type via autocomplete
- Updates persist correctly

### Test 5: Show Page OmniClass Display

**Steps**:
1. Create/edit equipment with OmniClass type linked
2. Navigate to equipment show page
3. Verify "Type d'Équipement" displays:
   - Equipment type name (e.g., "Climatiseur split mural")
   - Technical lot badge (e.g., "CVC" in blue)
4. Verify "Référence OmniClass" displays:
   - OmniClass code (e.g., "23-35 17 13")
   - OmniClass title in gray (e.g., "(Air Conditioning Equipment)")
5. Verify "Sous-domaine Achat" displays:
   - Technical lot prefix (e.g., "CVC")
   - Purchase subfamily (e.g., "CLIMATISATION")
6. Test with equipment without OmniClass link
7. Verify all fields show "Non spécifié" gracefully

**Expected Results**:
- OmniClass data displays correctly when linked
- Badges show correct colors per technical lot
- Nil values handled gracefully with "Non spécifié"

### Test 6: Search Edge Cases

**Steps**:
1. Type single character "c"
2. Verify no dropdown appears (minimum 2 chars)
3. Type "zzzzzzz" (non-existent)
4. Verify "Aucun type d'équipement trouvé" message
5. Verify helpful text displayed
6. Click outside dropdown
7. Verify dropdown closes
8. Start typing, then clear input
9. Verify dropdown hides

**Expected Results**:
- Minimum character requirement enforced
- Empty results handled with friendly message
- Click outside closes dropdown

### Test 7: Debouncing

**Steps**:
1. Open browser DevTools Network tab
2. Type rapidly: "climatiseur"
3. Verify only ONE API call made after 300ms pause
4. Verify no excessive API calls during typing

**Expected Results**:
- Debouncing reduces API calls efficiently
- Performance is smooth without lag

### Test 8: Multiple Equipment Types

**Steps**:
1. Search for "climatiseur" - should return multiple AC types
2. Verify all have CVC badge (blue)
3. Search for "chaudière" - should return multiple boiler types
4. Verify results show different characteristics
5. Select different types and compare info panels

**Expected Results**:
- Multiple results for common equipment categories
- Each type has unique code, characteristics, OmniClass code

### Test 9: Organization Isolation

**Steps**:
1. Login as portfolio@hubsight.com (Organization 1)
2. Use autocomplete - verify sees all 68 equipment types
3. Logout, login as portfolio2@hubsight.com (Organization 2)
4. Use autocomplete - verify sees same 68 types (shared reference data)
5. Create equipment in each organization
6. Verify each org only sees their own equipment instances

**Expected Results**:
- Equipment types are shared reference data (not org-scoped)
- Equipment instances are organization-scoped
- No data leakage between organizations

### Test 10: API Response Verification

**Steps**:
1. Open browser DevTools Network tab
2. Type search query "pompe"
3. Click on API call to /api/equipment_types/autocomplete
4. Verify response JSON contains all expected fields:
   - id, code, name, display_name
   - technical_lot_trigram, technical_lot_name
   - function, purchase_subfamily
   - omniclass_number, omniclass_title
   - characteristics array
   - lot_badge_color
5. Verify response limited to 50 results max

**Expected Results**:
- API returns complete equipment type data
- JSON structure matches controller specification
- Performance is acceptable (< 500ms)

---

## Data Structure

### Equipment Types (OmniClass Table 23)

```
68 representative types from 256 total classifications:
- CVC (20 types): Boilers, Heat Pumps, Chillers, AC, Ventilation, Distribution
- ELE (11 types): Distribution, Lighting, Power Supply
- PLO (10 types): Water Distribution, Drainage, Fixtures
- SEC (15 types): Fire Detection, Fire Suppression, Access Control, Surveillance
- ASC (5 types): Elevators
- CEA (3 types): Architectural Elements
- CTE (2 types): Technical Control
- AUT (2 types): Automation/BMS
```

### Example Equipment Type Record

```ruby
{
  code: "CVC-007",
  equipment_type_name: "Climatiseur split mural",
  technical_lot_trigram: "CVC",
  technical_lot: "Chauffage, Ventilation, Climatisation",
  purchase_subfamily: "CLIMATISATION",
  function: "Climatisation des locaux par détente directe",
  omniclass_number: "23-35 17 13",
  omniclass_title: "Split System Air Conditioners",
  characteristic_1: "Puissance frigorifique",
  characteristic_2: "Classe énergétique",
  characteristic_3: "Type de réfrigérant",
  # ... up to characteristic_10
  status: "active"
}
```

---

## Dependencies

This implementation depends on:

1. **Task 19**: OmniClass Table 23 import (equipment_types table and seed data)
2. **Task 22**: Equipment search & autocomplete system (API endpoint and Stimulus controller)
3. **Task 17**: Equipment CRUD functionality (base equipment management)

---

## Files Modified

1. `app/controllers/equipment_controller.rb` - Added `:equipment_type_id` to permitted params
2. `app/views/equipment/new.html.erb` - Already had autocomplete (from Task 22)
3. `app/views/equipment/edit.html.erb` - Already had autocomplete (from Task 22)
4. `app/views/equipment/show.html.erb` - Updated to display dynamic OmniClass data

---

## Files Not Modified (Already Complete from Task 22)

1. `app/javascript/controllers/equipment_type_autocomplete_controller.js`
2. `app/controllers/api/equipment_types_controller.rb`
3. `app/models/equipment.rb`
4. `app/models/equipment_type.rb`
5. `config/routes.rb`

---

## Notes

- Equipment types are **shared reference data** (OmniClass standard), not organization-scoped
- Equipment **instances** are organization-scoped
- The autocomplete supports up to 256 equipment types (68 currently seeded)
- Linking is **optional** - equipment can exist without an equipment_type_id
- The legacy `equipment_type` string field is maintained for backward compatibility
- All OmniClass codes follow international BIM standard format (XX-XX XX XX)

---

## Future Enhancements

1. **Admin Interface**: Create admin UI to manage equipment types (add/edit/deactivate)
2. **Bulk Import**: Import all 256 types from client's Excel file
3. **Custom Characteristics**: Allow organizations to define custom characteristics per type
4. **Equipment Type Analytics**: Dashboard showing equipment distribution by OmniClass code
5. **Auto-Suggestions**: Suggest equipment type based on manufacturer + model combination
6. **QR Code Integration**: Link equipment types to QR code scanning workflow

---

## Conclusion

Task 23 successfully implements the manual linking interface for associating equipment with OmniClass classification codes. The integration leverages the autocomplete system from Task 22 and provides a seamless user experience for Portfolio Managers to classify equipment according to international BIM standards.
