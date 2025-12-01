# Implementation Plan - Item 31: Auto-Calculate Contract Dates

## Overview
**Task**: PM - Auto-Calculate Contract Dates  
**Description**: Automatically calculate last renewal date, contract expiry date, termination deadline, and last amount update date based on contract parameters.

## Implementation Status
✅ **COMPLETED** - December 1, 2025

## Features Implemented

### 1. Auto-Calculated Date Fields (4 fields)

#### a) Contract End Date (`end_date`)
- **Calculation**: `execution_start_date + initial_duration_months + (renewal_count × renewal_duration_months)`
- **Example**: Start Jan 1, 2024 + 12 months initial + (2 renewals × 12 months each) = Jan 1, 2027
- **Display**: Read-only field with purple "AUTO" badge in form
- **Visual**: Gray background (#f3f4f6) to indicate calculated field

#### b) Last Renewal Date (`last_renewal_date`)
- **Calculation**: `execution_start_date + initial_duration_months + ((renewal_count - 1) × renewal_duration_months)`
- **Example**: Start Jan 1, 2024 + 12 months + (1 × 12 months) = Jan 1, 2026 (for 2 renewals)
- **Logic**: Only calculated if `renewal_count > 0`
- **Display**: Read-only with "AUTO" badge

#### c) Termination Deadline (`next_deadline_date`)
- **Calculation**: `end_date - notice_period_days`
- **Example**: Expiry Jan 1, 2027 - 90 days notice = Oct 3, 2026
- **Purpose**: Shows the deadline by which termination notice must be given
- **Display**: Read-only with explanatory text

#### d) Last Amount Update (`last_amount_update`)
- **Calculation**: Auto-set to current date when any amount field changes
- **Tracked Fields**: `annual_amount_ht`, `annual_amount_ttc`, `monthly_amount`
- **Purpose**: Track when contract pricing was last modified
- **Display**: Read-only in Financial Aspects section

## Technical Implementation

### Model (app/models/contract.rb)

#### Callbacks Added
```ruby
before_save :calculate_contract_dates
before_save :track_amount_updates
```

#### Calculation Methods
1. **`calculate_end_date`** - Computes final contract expiry date
2. **`calculate_last_renewal_date`** - Computes when last renewal period started
3. **`calculate_termination_deadline`** - Computes notice deadline
4. **`update_calculated_dates`** - Master method to update all dates
5. **`date_calculation_inputs_changed?`** - Detects when recalculation is needed
6. **`amount_fields_changed?`** - Detects pricing changes

#### Auto-Calculation Logic
```ruby
def calculate_contract_dates
  # Only recalculate if relevant fields changed or dates are nil
  if date_calculation_inputs_changed? || end_date.nil? || 
     last_renewal_date.nil? || next_deadline_date.nil?
    update_calculated_dates
  end
end

def track_amount_updates
  if amount_fields_changed?
    self.last_amount_update = Date.current
  end
end
```

### Form Updates (app/views/contracts/_comprehensive_form.html.erb)

#### Visual Indicators
- **AUTO Badge**: Purple gradient badge next to field label
- **Disabled State**: Gray background (#f3f4f6), cursor: not-allowed
- **Help Text**: Explanatory text with 📊 emoji showing calculation formula
- **Color Coding**: Distinct visual styling for auto-calculated fields

#### Field Layout
```erb
<div style="position: relative;">
  <label class="typo-body-small typo-bold" style="display: flex; align-items: center; gap: var(--space-sm);">
    Date d'Expiration du Contrat
    <span style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
                 color: white; padding: 2px 8px; border-radius: 4px;">AUTO</span>
  </label>
  <%= f.date_field :end_date, 
    value: contract.end_date || contract.calculate_end_date, 
    disabled: true,
    style: "background-color: #f3f4f6; cursor: not-allowed; color: #6b7280;" %>
  <p style="font-style: italic; color: #6b7280;">
    📊 Calculée automatiquement : Date de début + Durée initiale + (N reconductions × Durée reconduction)
  </p>
</div>
```

## Calculation Examples

### Example 1: Simple Contract (No Renewals)
- **Start Date**: January 1, 2024
- **Initial Duration**: 12 months
- **Renewals**: 0
- **Notice Period**: 60 days

**Results**:
- **End Date**: January 1, 2025
- **Last Renewal Date**: nil (no renewals)
- **Termination Deadline**: November 2, 2024

### Example 2: Contract with 2 Renewals
- **Start Date**: January 1, 2024
- **Initial Duration**: 24 months
- **Renewal Duration**: 12 months each
- **Renewal Count**: 2
- **Notice Period**: 90 days

**Results**:
- **End Date**: January 1, 2028 (24 + 12 + 12 = 48 months total)
- **Last Renewal Date**: January 1, 2027 (when 2nd renewal started)
- **Termination Deadline**: October 3, 2027

### Example 3: Contract with 3 Renewals
- **Start Date**: March 15, 2024
- **Initial Duration**: 12 months
- **Renewal Duration**: 12 months each
- **Renewal Count**: 3
- **Notice Period**: 30 days

**Results**:
- **End Date**: March 15, 2028 (12 + 12 + 12 + 12 = 48 months)
- **Last Renewal Date**: March 15, 2027 (when 3rd renewal started)
- **Termination Deadline**: February 14, 2028

## Edge Cases Handled

### 1. Missing Input Data
- If `execution_start_date` is nil → no calculation performed
- If `initial_duration_months` is nil → no calculation performed
- Methods return `nil` gracefully without errors

### 2. Zero Renewals
- `last_renewal_date` set to nil if `renewal_count == 0`
- `end_date` = start + initial duration only

### 3. No Notice Period
- `next_deadline_date` set to nil if `notice_period_days` is 0 or nil

### 4. Amount Updates
- `last_amount_update` only set when amounts actually change
- Not set on initial creation unless amounts provided

## User Experience

### On Contract Creation
1. User fills **input fields**: start date, durations, renewal count, notice period
2. Upon save, **calculated fields** are automatically computed
3. User sees auto-calculated dates in read-only format with clear visual indicators

### On Contract Update
1. If user changes any input parameter (e.g., extends duration)
2. Calculated dates **automatically recalculate** on save
3. No manual intervention required

### Form Display
- **Clear labeling**: "AUTO" badges on calculated fields
- **Help text**: Explains calculation formula for transparency
- **Disabled state**: Users cannot manually edit calculated fields
- **Visual distinction**: Gray background differentiates from editable fields

## Database Fields

### Input Fields (User Provides)
- `execution_start_date` (date)
- `initial_duration_months` (integer)
- `renewal_duration_months` (integer)
- `renewal_count` (integer)
- `notice_period_days` (integer)
- `annual_amount_ht` (decimal)
- `annual_amount_ttc` (decimal)
- `monthly_amount` (decimal)

### Calculated Fields (Auto-Generated)
- `end_date` (date) - Contract expiry
- `last_renewal_date` (date) - Last renewal start
- `next_deadline_date` (date) - Termination notice deadline
- `last_amount_update` (date) - Last pricing change

## Benefits

### 1. Accuracy
- Eliminates manual calculation errors
- Ensures consistency across all contracts
- Dates always in sync with contract parameters

### 2. Efficiency
- No need for users to manually calculate dates
- Automatic recalculation when parameters change
- Reduces data entry time

### 3. Compliance
- Critical deadline tracking (termination notice)
- Helps prevent missed renewal deadlines
- Audit trail for pricing changes

### 4. User-Friendly
- Clear visual indicators (AUTO badges)
- Explanatory text for transparency
- No confusion about which fields are editable

## Testing Checklist

### Unit Tests (Model)
- ✅ Calculate end date with no renewals
- ✅ Calculate end date with multiple renewals
- ✅ Calculate last renewal date correctly
- ✅ Handle zero renewals (nil last renewal date)
- ✅ Calculate termination deadline
- ✅ Handle missing start date (return nil)
- ✅ Track amount updates on changes
- ✅ Don't update amount date if amounts unchanged

### Integration Tests (Form)
- ✅ Display calculated fields as disabled
- ✅ Show AUTO badges on calculated fields
- ✅ Display help text with formulas
- ✅ Recalculate on parameter changes
- ✅ Handle nil values gracefully

### Manual Testing Scenarios
1. **Create new contract** with all date parameters → verify calculations
2. **Edit existing contract** changing duration → verify recalculation
3. **Update contract amounts** → verify last_amount_update changes
4. **Create contract without dates** → verify no errors
5. **View contract with calculated dates** → verify display formatting

## Future Enhancements

### Potential Additions
1. **Automatic alerts** for upcoming deadlines
2. **Dashboard widget** showing contracts nearing termination deadline
3. **Bulk recalculation** for existing contracts
4. **Manual override option** with audit trail
5. **Historical tracking** of date changes

## Documentation

### For Users
- Fields marked with "AUTO" badge are automatically calculated
- Cannot be manually edited
- Update input fields (duration, dates) to change calculated values
- Hover over help text to see calculation formula

### For Developers
- All calculation logic in Contract model
- `before_save` callbacks ensure automatic updates
- Methods are defensive (handle nil gracefully)
- Add validations for input fields if needed

## Related Tasks
- Task 28: Manual Contract Creation (provides input fields)
- Task 26: LLM Data Structuring (can auto-populate input fields)
- Task 33: View Contract List (displays calculated dates)
- Task 45: Key Indicators Display (uses calculated dates for metrics)

## Migration Notes
- No database migration needed (fields already exist in schema)
- Existing contracts will have dates calculated on next save
- Can run one-time update to calculate for all existing contracts

## Backward Compatibility
- ✅ Fully backward compatible
- ✅ Existing contracts not affected until edited
- ✅ No breaking changes to database schema
- ✅ Methods handle nil values safely

## Performance Considerations
- Date calculations are simple arithmetic (negligible overhead)
- Only recalculates when input fields change
- No external API calls or complex queries
- Suitable for high-volume contract processing

## Completion Summary
All 4 date fields are successfully auto-calculated:
1. ✅ Contract End Date
2. ✅ Last Renewal Date 
3. ✅ Termination Deadline
4. ✅ Last Amount Update

The feature is production-ready with proper error handling, clear UI indicators, and comprehensive documentation.
