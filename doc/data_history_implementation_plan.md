# Data History Implementation Plan

**Created**: December 8, 2025  
**Status**: Phase 1 Complete (Preparation)  
**Next Phase**: Backend Implementation with PaperTrail

---

## Overview

This document outlines the implementation plan for the Data History feature in HubSight. The feature will allow users to track all modifications made to records, including who made changes, when they were made, and what values changed.

---

## Phase 1: UI Preparation ✅ COMPLETE

### Completed Items

1. **"View History" Button Partial** ✅
   - Created: `app/views/shared/_view_history_button.html.erb`
   - Reusable component for all show pages
   - Displays "Coming Soon" alert with feature preview
   - Styled with purple theme (#667eea)

2. **Placeholder Functionality** ✅
   - Button shows informative alert about upcoming feature
   - Explains what users will be able to see:
     - Who made modifications
     - When modifications were made
     - What values changed
     - Before/after values

### Usage

To add the "View History" button to any show page:

```erb
<%= render 'shared/view_history_button' %>
```

**Recommended placement**: Near Edit/Delete buttons in the header actions section.

---

## Phase 2: Backend Setup (Future - 15-20 hours)

### 2.1 Add PaperTrail Gem

**File**: `Gemfile`

```ruby
gem 'paper_trail', '~> 15.0'
```

**Commands**:
```bash
bundle install
rails generate paper_trail:install
rails db:migrate
```

### 2.2 Enable Versioning on Models

**Models to version**:
- Contract (`app/models/contract.rb`)
- Equipment (`app/models/equipment.rb`)
- Site (`app/models/site.rb`)
- Building (`app/models/building.rb`)
- Organization (`app/models/organization.rb`)
- Level (`app/models/level.rb`)
- Space (`app/models/space.rb`)

**Implementation** (add to each model):
```ruby
class Contract < ApplicationRecord
  has_paper_trail
  # ... rest of model
end
```

**Estimated time**: 2-3 hours

---

## Phase 3: Controller & Routes (Future - 8-10 hours)

### 3.1 Create Audit History Controller

**File**: `app/controllers/audit_history_controller.rb`

```ruby
class AuditHistoryController < ApplicationController
  before_action :authenticate_user!
  before_action :set_versionable
  
  def index
    @versions = @versionable.versions
                             .order(created_at: :desc)
                             .page(params[:page])
                             .per(20)
  end
  
  def show
    @version = PaperTrail::Version.find(params[:id])
    @changes = @version.changeset
  end
  
  private
  
  def set_versionable
    # Determine the model and ID from params
    model_class = params[:model_type].constantize
    @versionable = model_class.find(params[:model_id])
  end
end
```

### 3.2 Add Routes

**File**: `config/routes.rb`

```ruby
# Audit History
get 'audit_history/:model_type/:model_id', to: 'audit_history#index', as: :audit_history
get 'audit_history/version/:id', to: 'audit_history#show', as: :audit_history_version
```

**Estimated time**: 3-4 hours

---

## Phase 4: Frontend Views (Future - 10-12 hours)

### 4.1 Timeline View Component

**File**: `app/views/audit_history/index.html.erb`

**Features**:
- Chronological timeline of all changes
- User avatars and names
- Timestamp display
- Change summary (fields modified)
- Link to detailed view

### 4.2 Before/After Comparison Component

**File**: `app/views/audit_history/show.html.erb`

**Features**:
- Side-by-side comparison
- Highlighted differences
- Field-by-field breakdown
- User and timestamp information

### 4.3 Update "View History" Button

**File**: `app/views/shared/_view_history_button.html.erb`

Replace alert with actual link:
```erb
<%= link_to audit_history_path(
  model_type: @record.class.name,
  model_id: @record.id
), class: "..." do %>
  <!-- SVG and text -->
<% end %>
```

**Estimated time**: 8-10 hours

---

## Phase 5: Settings Tab Integration (Future - 3-4 hours)

### 5.1 Add Data History Tab to Settings

**File**: `app/views/settings/index.html.erb`

**Features**:
- New tab for "Historique des Données"
- Global audit trail view
- Filter by user, date range, entity type
- Export functionality

**Estimated time**: 3-4 hours

---

## Phase 6: Export Functionality (Future - 5-6 hours)

### 6.1 CSV Export

**Controller method**:
```ruby
def export_csv
  # Generate CSV of version history
end
```

### 6.2 PDF Export

**Using Prawn or Wicked PDF**:
- Professional audit report format
- Includes all changes with timestamps
- Company branding

**Estimated time**: 5-6 hours

---

## Total Time Estimates

| Phase | Description | Time | Status |
|-------|-------------|------|--------|
| Phase 1 | UI Preparation | 3-4 hours | ✅ **COMPLETE** |
| Phase 2 | Backend Setup | 2-3 hours | ⏳ Pending |
| Phase 3 | Controller & Routes | 8-10 hours | ⏳ Pending |
| Phase 4 | Frontend Views | 10-12 hours | ⏳ Pending |
| Phase 5 | Settings Integration | 3-4 hours | ⏳ Pending |
| Phase 6 | Export Functionality | 5-6 hours | ⏳ Pending |
| **TOTAL** | | **31-39 hours** | **Phase 1 Done** |

---

## Testing Checklist (For Future Phases)

- [ ] Create test records and modify them
- [ ] Verify versions are created on update
- [ ] Test timeline view displays all changes
- [ ] Test before/after comparison shows correct data
- [ ] Test filtering by user, date, entity type
- [ ] Test CSV export contains all required data
- [ ] Test PDF export formatting
- [ ] Test permissions (users can only see their org's data)
- [ ] Performance test with large version history
- [ ] Test with different user roles (admin, site_manager, etc.)

---

## Technical Considerations

### Performance
- Index the `versions` table on `item_type` and `item_id`
- Consider archiving old versions after a certain period
- Implement pagination for large history lists

### Security
- Ensure users can only view history for records they have access to
- Log who viewed audit history (meta-auditing)
- Implement role-based access (maybe only admins can see full history)

### Data Retention
- Define retention policy (how long to keep versions)
- Implement automatic cleanup job for old versions
- Consider compliance requirements (GDPR, etc.)

---

## References

- **PaperTrail Documentation**: https://github.com/paper-trail-gem/paper_trail
- **Rails Versioning Best Practices**: https://guides.rubyonrails.org/
- **Audit Trail Design Patterns**: Industry standard approaches

---

## Notes

- Phase 1 (UI Preparation) completed as part of HP Laptop tasks
- "View History" button added to show pages (currently shows "Coming Soon" message)
- Backend implementation should be prioritized in next development sprint
- Consider user feedback on desired audit trail features before full implementation

---

**Last Updated**: December 8, 2025  
**Next Review**: After Phase 2 completion
