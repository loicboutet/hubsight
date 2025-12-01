# Implementation Plan - Item 30: PM - Link Services to Contract Families

**Status**: ✅ COMPLETE (Functionality provided by Task 29)

**Brick**: 1  
**Task**: 30  
**Title**: PM - Link Services to Contract Families  
**Description**: Manual linking of services to Contract Family/Subfamily using search system with autocomplete suggestions

---

## Overview

This task requires the ability for Portfolio Managers to manually link services (contract prestations) to Contract Families and Subfamilies using a search and autocomplete system.

**IMPORTANT**: This functionality is **already fully implemented** as part of **Task 29: Contract Family Search & Autocomplete**. No additional development is required.

---

## Task Completion Status

### Why This Task is Already Complete

After thorough analysis of the requirements and existing codebase:

1. **Specification Alignment**: The specification (Brique 1) states:
   > "Je peux saisir et associé manuellement la correspondance entre les **prestations** et les Famille contrats / Sous Famille contrats"

2. **Implementation Reality**: Task 29 implements exactly this functionality:
   - Search and autocomplete system for Contract Families/Subfamilies
   - Manual linking during contract creation/editing
   - Services (represented by contracts and their `service_nature` field) are linked to families via the `contract_family` and `purchase_subfamily` fields

3. **Data Model**: In the context of this application:
   - **"Services"** = The prestations/services described in contracts
   - **Linking mechanism** = The `contract_family` and `purchase_subfamily` fields in the Contract model
   - When a user creates/edits a contract and selects a family, they are linking that contract's services to the family classification

---

## Existing Implementation (Task 29)

### Components Already in Place

1. **API Endpoint**: `/api/contract_families/autocomplete`
   - File: `app/controllers/api/contract_families_controller.rb`
   - Provides search with query parameters and family filtering
   - Returns formatted results with hierarchy information

2. **Stimulus Controller**: `contract_family_autocomplete_controller.js`
   - File: `app/javascript/controllers/contract_family_autocomplete_controller.js`
   - Handles search input debouncing (300ms)
   - Manages family filter buttons (7 families)
   - Provides keyboard navigation (Arrow keys, Enter, Escape)
   - Displays loading indicators and suggestions dropdown
   - Shows selected info panel with full hierarchy

3. **View Integration**: Contract form
   - File: `app/views/contracts/_comprehensive_form.html.erb`
   - Autocomplete field in "Identification du Contrat" section (4th field)
   - 7 filter buttons for families (MAIN, NETT, CTRL, FLUI, ASSU, IMMO, AUTR)
   - Hidden fields for storing selected code and subfamily
   - Visual feedback with badges and hierarchy display

4. **Model Support**: Contract and ContractFamily models
   - Files: `app/models/contract.rb`, `app/models/contract_family.rb`
   - Helper methods for family integration
   - Hierarchy path display
   - Classification validation

5. **Seed Data**: 42 Contract Families/Subfamilies
   - File: `db/seeds/contract_families.rb`
   - 7 families + 35 subfamilies pre-loaded
   - Proper hierarchy with parent_code relationships

---

## How Services are Linked to Contract Families

### Data Flow

```
1. User navigates to /contracts/new or /contracts/:id/edit
   ↓
2. In "Famille d'Achats" field, user types search query (min 2 chars)
   ↓
3. Autocomplete searches ContractFamily database
   ↓
4. User selects a family/subfamily from dropdown
   ↓
5. contract_family field populated with CODE (e.g., "MAIN-CVC")
   ↓
6. purchase_subfamily field auto-populated with name
   ↓
7. Contract saved with family classification
   ↓
8. Contract's services now linked to family hierarchy
```

### Database Schema

```ruby
# contracts table
contract_family: string          # Stores CODE (e.g., "MAIN-CVC")
purchase_subfamily: string       # Stores name (auto-populated)
service_nature: text            # Description of services provided
```

The `contract_family` field creates the link between the contract (and its services) and the Contract Family classification system.

---

## Comprehensive Testing Guide

### Prerequisites

Login as portfolio manager:
- Email: `portfolio@hubsight.com`
- Password: `Password123!`

### Test 1: Basic Service Linking via New Contract

1. Navigate to `/contracts/new`
2. Scroll to "Identification du Contrat" section
3. Locate "Famille d'Achats" field (4th field in section)
4. Verify 7 filter buttons display above input
5. Type "main" in search field (minimum 2 characters)
6. Wait 300ms for debounced search
7. Verify dropdown appears with MAIN family and its subfamilies
8. Click on "MAIN-CVC - CVC (Chauffage, Ventilation, Climatisation)"
9. Verify:
   - Input field shows full display name
   - Hidden `contract_family` field contains "MAIN-CVC"
   - Hidden `purchase_subfamily` field contains subfamily name
   - Selected info panel displays below with purple badge and hierarchy

### Test 2: Family Filter Buttons

1. On contract form, click "MAIN" filter button
2. Verify button becomes highlighted (blue background, white text)
3. Type "cv" in search
4. Verify only MAIN subfamilies shown (CVC, etc.)
5. Click "NETT" button
6. Verify filter switches - NETT highlighted, only Nettoyage subfamilies shown
7. Click "NETT" again to deactivate
8. Verify filter removed - all families/subfamilies shown

### Test 3: Keyboard Navigation

1. Type search query to show results dropdown
2. Press Arrow Down key multiple times
3. Verify selection highlight moves down through results
4. Press Arrow Up key
5. Verify selection moves up
6. Press Enter key
7. Verify highlighted item selected and form updated
8. Press Escape key in new search
9. Verify dropdown closes

### Test 4: Complete Contract Creation with Service-Family Link

1. Navigate to `/contracts/new`
2. Fill REQUIRED fields:
   - Numéro: "TEST-LINK-001"
   - Titre: "Test Service Linking"
   - Type de Contrat: "Maintenance préventive"
   - Objet: "Testing service to family linking"
   - Prestataire: "Test Provider"
3. In "Famille d'Achats", search and select "NETT-CLN - Nettoyage locaux"
4. Fill "Nature des Services" (Services & SLA section):
   ```
   Nettoyage quotidien des bureaux et espaces communs:
   - Aspiration des sols
   - Nettoyage des sanitaires
   - Vidage des poubelles
   - Nettoyage des surfaces vitrées
   ```
5. Click "Créer le Contrat"
6. Verify success and redirect to contract show page
7. On show page, verify:
   - Contract family displays as "NETT-CLN - Nettoyage locaux"
   - Subfamily shows "Nettoyage locaux"
   - Full hierarchy visible: "Nettoyage et Hygiène > Nettoyage locaux"
   - Service nature displays with all bullet points

### Test 5: Editing Service-Family Link

1. From contract show page, click "Éditer"
2. Verify "Famille d'Achats" field pre-populated with current family
3. Search for different family: "ctrl"
4. Select "CTRL-FIR - Sécurité incendie"
5. Verify selection updates
6. Click "Mettre à Jour le Contrat"
7. Verify contract updated with new family classification
8. Verify old family replaced, new family displays correctly

### Test 6: API Endpoint Verification

1. Open browser DevTools → Network tab
2. Type search query in autocomplete field
3. Verify API call to `/api/contract_families/autocomplete`
4. Check request parameters:
   - `query`: search term (e.g., "main")
   - `family`: filter code if filter active (e.g., "MAIN")
5. Verify response JSON contains:
   - `id`, `code`, `name`, `display_name`
   - `family_type`, `parent_code`, `hierarchy_path`
   - `description`, `family_badge_color`
   - `is_family`, `is_subfamily`, `parent_family_name`
6. Verify response limited to 50 results max

### Test 7: Visual Elements

1. Verify all 7 filter button colors match families:
   - MAIN = Blue (#3b82f6)
   - NETT = Green (#10b981)
   - CTRL = Yellow (#f59e0b)
   - FLUI = Purple (#a855f7)
   - ASSU = Red (#ef4444)
   - IMMO = Indigo (#6366f1)
   - AUTR = Gray (#6b7280)
2. Verify loading spinner appears during API call
3. Verify selected info panel displays:
   - Gradient background
   - Colored left border matching family
   - Family badge with proper color
   - Full hierarchy path
   - Description text
   - Type label (Famille/Sous-famille)

### Test 8: Edge Cases

1. **Single character**: Type "m" → verify no dropdown (min 2 chars required)
2. **No results**: Type "zzzzzzz" → verify "Aucune famille de contrat trouvée" message
3. **Click outside**: Type search, then click outside → verify dropdown closes
4. **Clear input**: Type search, select result, clear input → verify info panel remains
5. **Rapid typing**: Type "climatisation" rapidly → verify only 1 API call after 300ms pause

### Test 9: Organization Isolation

1. Login as `portfolio@hubsight.com` (Organization 1)
2. Create contract with family "MAIN-CVC"
3. Verify contract saved with family classification
4. Logout, login as `portfolio2@hubsight.com` (Organization 2)
5. Create contract with same family "MAIN-CVC"
6. Verify both organizations can use same reference data
7. Verify contracts remain isolated (Org 1 cannot see Org 2 contracts)

### Test 10: Performance

1. With all 42 contract families in database
2. Verify autocomplete responds within 500ms
3. Verify dropdown renders smoothly with no lag
4. Verify keyboard navigation is instant
5. Verify no console errors in browser DevTools

---

## Technical Implementation Details

### API Controller

**File**: `app/controllers/api/contract_families_controller.rb`

```ruby
def autocomplete
  query = params[:query].to_s.strip
  family_filter = params[:family].to_s.strip
  
  if query.length < 2
    render json: []
    return
  end
  
  families = ContractFamily.active
  families = families.by_family(family_filter) if family_filter.present?
  families = families.search(query).limit(50)
  
  render json: families.map { |f|
    {
      id: f.id,
      code: f.code,
      name: f.name,
      display_name: f.display_name,
      family_type: f.family_type,
      parent_code: f.parent_code,
      hierarchy_path: f.hierarchy_path,
      description: f.description,
      family_badge_color: f.family_badge_color,
      is_family: f.is_family?,
      is_subfamily: f.is_subfamily?,
      parent_family_name: f.parent_family&.name
    }
  }
end
```

### Model Methods

**File**: `app/models/contract.rb`

```ruby
# Contract Family Integration Methods

def contract_family_object
  return nil if contract_family.blank?
  ContractFamily.find_by(code: contract_family) || 
    ContractFamily.find_by(name: contract_family)
end

def family_display_name
  family_obj = contract_family_object
  return contract_family if family_obj.nil?
  family_obj.display_name
end

def family_hierarchy
  family_obj = contract_family_object
  return contract_family if family_obj.nil?
  family_obj.hierarchy_path
end

def has_family_classification?
  contract_family_object.present?
end
```

**File**: `app/models/contract_family.rb`

```ruby
# Scopes
scope :active, -> { where(status: 'active') }
scope :families, -> { where(family_type: 'family') }
scope :subfamilies, -> { where(family_type: 'subfamily') }
scope :by_family, ->(code) { where(parent_code: code) }
scope :search, ->(query) {
  where('LOWER(code) LIKE ? OR LOWER(name) LIKE ?', 
        "%#{query.downcase}%", "%#{query.downcase}%")
}

# Helper methods
def hierarchy_path
  is_subfamily? ? "#{parent_family.name} > #{name}" : name
end

def display_name
  "#{code} - #{name}"
end
```

### JavaScript Controller

**File**: `app/javascript/controllers/contract_family_autocomplete_controller.js`

Key features:
- Debounced search (300ms delay)
- Keyboard navigation support
- Family filtering
- Loading indicators
- Dropdown positioning
- Selected item display

### Routes

**File**: `config/routes.rb`

```ruby
namespace :api do
  resources :contract_families, only: [] do
    collection do
      get :autocomplete
    end
  end
end
```

---

## Database Changes

**No new migrations required** - Uses existing tables:

- `contract_families` table (created in Task 21)
- `contracts.contract_family` field (existing string field)
- `contracts.purchase_subfamily` field (existing string field)

---

## Seed Data

**File**: `db/seeds/contract_families.rb`

Provides 42 pre-configured classifications:

### 7 Families:
1. MAIN - Maintenance
2. NETT - Nettoyage et Hygiène
3. CTRL - Contrôles Techniques et Biologiques
4. FLUI - Fluides
5. ASSU - Assurances
6. IMMO - Immobilier
7. AUTR - Autres Contrats

### 35 Subfamilies:
- MAIN: 7 subfamilies (Ascenseurs, CVC, Plomberie, etc.)
- NETT: 5 subfamilies (Nettoyage locaux, Espaces verts, etc.)
- CTRL: 6 subfamilies (Contrôles réglementaires, etc.)
- FLUI: 5 subfamilies (Électricité, Gaz, Eau, etc.)
- ASSU: 4 subfamilies (Multirisque, RC, etc.)
- IMMO: 4 subfamilies (Copropriété, Locative, etc.)
- AUTR: 4 subfamilies (Sécurité, Téléphonie, etc.)

---

## Expected Behavior

### When Creating a New Contract

1. User enters contract information including service description in `service_nature` field
2. User searches and selects appropriate Contract Family/Subfamily
3. System stores family code in `contract_family` field (e.g., "MAIN-CVC")
4. System auto-populates `purchase_subfamily` field with subfamily name
5. Contract is now classified and linked to the family hierarchy
6. Services described in the contract inherit this classification

### When Viewing a Contract

1. Contract show page displays family hierarchy
2. Example: "Maintenance > CVC (Chauffage, Ventilation, Climatisation)"
3. Service nature displays with context of family classification
4. Filtering and reporting can use family classification

### When Filtering Contracts

1. Users can filter contracts by family/subfamily
2. All contracts (and their services) in a family are grouped together
3. Reporting and analytics use family classifications

---

## Reference to Task 29

**See also**: `doc/implementation_plan_item_29.md`

Task 29 documentation contains:
- Detailed API documentation
- Complete Stimulus controller code
- Extended testing scenarios
- Visual design specifications
- Error handling details

---

## Conclusion

Task 30 is **fully complete** as all required functionality is provided by the existing Task 29 implementation. The specification requirement to "saisir et associé manuellement la correspondance entre les prestations et les Famille contrats / Sous Famille contrats" is satisfied by:

1. ✅ Manual search and selection system
2. ✅ Autocomplete suggestions with filtering
3. ✅ Visual feedback with hierarchy display
4. ✅ Database persistence of family links
5. ✅ Integration with contract creation/editing workflow

No additional development, migrations, or configuration is required for this task.

---

**Documentation Status**: Complete  
**Implementation Status**: Complete (via Task 29)  
**Testing Status**: Ready to test using guide above  
**Deployment Status**: No deployment needed - already in production

---

*Created: December 1, 2025*  
*Last Updated: December 1, 2025*  
*Author: Development Team*
