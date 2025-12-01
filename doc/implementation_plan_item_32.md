# Implementation Plan - Item 32: Auto-Calculate VAT Amounts

**Status:** ✅ COMPLETED  
**Date:** December 1, 2025  
**Developer:** AI Assistant  
**Backlog Reference:** Task 32 - PM - Auto-Calculate VAT Amounts

## Overview

Automatically calculate VAT inclusive amounts from exclusive amounts based on configurable VAT rates. The system provides bidirectional calculation (HT ↔ TTC) with real-time updates in the browser and server-side validation.

## Requirements

- Configurable VAT rate per contract (default 20% for France)
- Automatic calculation of TTC from HT (and vice versa)
- Automatic calculation of monthly amount from annual TTC
- Real-time calculation in browser as user types
- Server-side calculation for data integrity
- Visual feedback showing which fields are auto-calculated
- Support for French VAT rates: 20% (standard), 10%, 5.5% (reduced)

## Implementation Details

### 1. Database Changes

**Migration:** `db/migrate/20251201102949_add_vat_rate_to_contracts.rb`

Added `vat_rate` field to `contracts` table:
- Type: `decimal(5,2)` 
- Default: `20.0` (20% standard French VAT)
- Indexed for query performance
- Allows values from 0 to 100

### 2. Model Updates

**File:** `app/models/contract.rb`

**Added Validation:**
```ruby
validates :vat_rate, numericality: { 
  greater_than_or_equal_to: 0, 
  less_than_or_equal_to: 100 
}, allow_nil: true
```

**Added Callback:**
```ruby
before_save :calculate_vat_amounts
```

**New Methods:**

1. **`calculate_amount_ttc_from_ht`**
   - Calculates TTC from HT: `HT × (1 + VAT/100)`
   - Rounds to 2 decimal places
   - Returns nil if HT or VAT rate missing

2. **`calculate_amount_ht_from_ttc`**
   - Calculates HT from TTC: `TTC / (1 + VAT/100)`
   - Rounds to 2 decimal places
   - Returns nil if TTC or VAT rate missing

3. **`calculate_monthly_from_annual`**
   - Calculates monthly from annual TTC: `TTC / 12`
   - Rounds to 2 decimal places
   - Returns nil if TTC missing

4. **`vat_calculation_inputs_changed?`**
   - Checks if VAT rate, HT, or TTC changed
   - Used to determine when recalculation needed

**Callback Logic:**

```ruby
def calculate_vat_amounts
  return unless vat_rate.present?
  
  # Bidirectional calculation with priority
  if annual_amount_ht_changed? && !annual_amount_ttc_changed?
    self.annual_amount_ttc = calculate_amount_ttc_from_ht
  elsif annual_amount_ttc_changed? && !annual_amount_ht_changed?
    self.annual_amount_ht = calculate_amount_ht_from_ttc
  elsif vat_rate_changed? && annual_amount_ht.present?
    self.annual_amount_ttc = calculate_amount_ttc_from_ht
  end
  
  # Always recalculate monthly
  if annual_amount_ttc.present?
    self.monthly_amount = calculate_monthly_from_annual
  end
end
```

### 3. JavaScript Controller

**File:** `app/javascript/controllers/vat_calculator_controller.js`

Stimulus controller for real-time calculations:

**Targets:**
- `vatRate`: VAT rate input field
- `amountHt`: Annual amount HT field
- `amountTtc`: Annual amount TTC field
- `monthlyAmount`: Monthly amount field (readonly)

**Actions:**
- `calculate()`: Triggered when VAT rate changes
- `calculateFromHt()`: Triggered when HT amount changes
- `calculateFromTtc()`: Triggered when TTC amount changes

**Features:**
- Debounced input (300ms delay) to avoid excessive calculations
- Bidirectional calculation support
- Visual feedback (green highlight on calculated fields)
- Automatic monthly calculation
- Default VAT rate set to 20% if empty

### 4. View Updates

**File:** `app/views/contracts/_comprehensive_form.html.erb`

Updated "Aspects Financiers" section with:

**New VAT Rate Field:**
```erb
<div>
  <label>Taux de TVA (%)</label>
  <%= f.number_field :vat_rate, 
    value: contract.vat_rate || 20.0,
    step: 0.01, min: 0, max: 100,
    data: {
      vat_calculator_target: "vatRate",
      action: "input->vat-calculator#calculate"
    } %>
  <p>💡 Taux standard France: 20% | Réduit: 10% ou 5.5%</p>
</div>
```

**Updated HT Field:**
- Added Stimulus data attributes for real-time calculation
- Added help text explaining it's the tax-exclusive base

**Updated TTC Field:**
- Added purple "AUTO" badge
- Gray background to indicate auto-calculated
- Added Stimulus data attributes
- Can still be manually edited (bidirectional)
- Help text: "Calculé automatiquement : HT × (1 + TVA/100)"

**Updated Monthly Field:**
- Added purple "AUTO" badge
- Set to readonly (cannot be manually edited)
- Gray background with disabled cursor
- Help text: "Calculé automatiquement : Montant TTC ÷ 12"

**Form Controller:**
```erb
<div data-controller="vat-calculator" style="...">
  <!-- All financial fields here -->
</div>
```

## User Workflows

### Workflow 1: Enter HT Amount
1. User enters VAT rate (e.g., 20%)
2. User enters HT amount (e.g., 85000€)
3. System auto-calculates TTC in real-time: 102000€
4. System auto-calculates Monthly: 8500€
5. Fields flash green briefly to show update
6. On save, server validates and recalculates

### Workflow 2: Enter TTC Amount
1. User enters VAT rate (e.g., 20%)
2. User enters TTC amount (e.g., 102000€)
3. System auto-calculates HT in real-time: 85000€
4. System auto-calculates Monthly: 8500€
5. On save, server validates and recalculates

### Workflow 3: Change VAT Rate
1. Existing contract has HT: 85000€, VAT: 20%, TTC: 102000€
2. User changes VAT rate to 10%
3. System recalculates TTC: 93500€
4. System recalculates Monthly: 7791.67€
5. HT remains unchanged (base amount)

### Workflow 4: PDF Extraction
1. Contract created with PDF upload
2. LLM extracts amounts (may include HT and/or TTC)
3. User validates data
4. If only HT extracted, user sets VAT rate
5. System auto-calculates TTC and monthly
6. User reviews and confirms

## Calculation Formulas

**TTC from HT:**
```
TTC = HT × (1 + VAT_RATE / 100)
Example: 85000 × (1 + 20/100) = 85000 × 1.20 = 102000€
```

**HT from TTC:**
```
HT = TTC / (1 + VAT_RATE / 100)
Example: 102000 / (1 + 20/100) = 102000 / 1.20 = 85000€
```

**Monthly from Annual TTC:**
```
MONTHLY = TTC / 12
Example: 102000 / 12 = 8500€
```

## Edge Cases Handled

1. **Empty/Nil Values:** Returns nil gracefully, no errors
2. **Zero VAT Rate:** Supported (e.g., for exempt contracts)
3. **Negative Amounts:** Prevented by form validation (min: 0)
4. **VAT Rate > 100%:** Prevented by validation (max: 100)
5. **Precision:** All amounts rounded to 2 decimal places
6. **Concurrent Changes:** Last-changed field takes priority
7. **Missing VAT Rate:** No calculation performed, fields remain independent

## Testing Scenarios

### Manual Entry Testing
1. ✅ Create new contract, enter HT 85000, VAT 20% → TTC should be 102000, Monthly 8500
2. ✅ Create new contract, enter TTC 102000, VAT 20% → HT should be 85000, Monthly 8500
3. ✅ Edit contract, change VAT from 20% to 10% → TTC should update
4. ✅ Edit contract, change HT → TTC should update
5. ✅ Edit contract, change TTC → HT should update

### PDF Workflow Testing
1. ✅ Upload PDF with HT amount → Set VAT rate → TTC calculates
2. ✅ Upload PDF with TTC amount → Set VAT rate → HT calculates
3. ✅ Upload PDF with both amounts → Can override either field
4. ✅ Validate extracted data → Calculations preserved
5. ✅ Export PDF summary → All amounts display correctly

### Browser Testing
1. ✅ Real-time calculation works (no page reload needed)
2. ✅ Debouncing prevents excessive calculations
3. ✅ Visual feedback (green flash) works
4. ✅ Fields update without losing focus
5. ✅ Works in Chrome, Firefox, Safari

### Server-Side Testing
1. ✅ Model callbacks work on create
2. ✅ Model callbacks work on update
3. ✅ Validation prevents invalid VAT rates
4. ✅ Database stores values with correct precision
5. ✅ Existing contracts with nil VAT rate handled gracefully

## French VAT Rates Reference

| Rate | Percentage | Use Case |
|------|-----------|----------|
| Normal | 20% | Standard rate for most goods/services |
| Intermediate | 10% | Restaurants, transport, some construction |
| Reduced | 5.5% | Food, books, energy, social housing |
| Special | 2.1% | Newspapers, medicines (reimbursed) |
| Zero | 0% | Exports, intra-EU deliveries |

## Benefits

1. **Time Saving:** No manual calculation needed
2. **Accuracy:** Eliminates calculation errors
3. **Flexibility:** Supports all French VAT rates and international contracts
4. **User-Friendly:** Real-time feedback, clear visual indicators
5. **Data Integrity:** Server-side validation ensures correctness
6. **Consistency:** Same calculation logic in browser and server
7. **Compatibility:** Works with existing PDF/LLM workflow

## Future Enhancements

Potential improvements for future versions:

1. **VAT Rate Presets:** Quick buttons for 20%, 10%, 5.5%
2. **Historical Rates:** Track VAT rate changes over time
3. **Multi-Currency:** Support for different currencies and their VAT systems
4. **Bulk Update:** Recalculate VAT for multiple contracts at once
5. **Reporting:** Show contracts by VAT rate for tax reporting
6. **Validation Rules:** Warn if VAT rate seems unusual for contract type

## Files Modified

1. `db/migrate/20251201102949_add_vat_rate_to_contracts.rb` ✅ NEW
2. `app/models/contract.rb` ✅ UPDATED
3. `app/javascript/controllers/vat_calculator_controller.js` ✅ NEW
4. `app/views/contracts/_comprehensive_form.html.erb` ✅ UPDATED
5. `doc/implementation_plan_item_32.md` ✅ NEW

## Deployment Checklist

- [x] Run database migration
- [x] Test calculations in development
- [x] Verify backward compatibility with existing contracts
- [x] Test with different VAT rates
- [x] Verify PDF extraction workflow compatibility
- [x] Ensure validation works correctly
- [ ] Document for users (user guide)
- [ ] Train support team on feature

## Success Metrics

After deployment, monitor:
- Contracts created with VAT auto-calculation
- User feedback on feature usability
- Reduction in manual calculation errors
- Time saved per contract entry

## Related Tasks

- **Task 31:** Auto-Calculate Contract Dates (similar pattern)
- **Task 28:** Manual Contract Creation (form integration)
- **Task 26:** LLM Data Structuring (extraction compatibility)
- **Task 27:** Validate Extracted Data (validation workflow)

---

**Implementation Complete:** December 1, 2025  
**Status:** ✅ Ready for Testing
