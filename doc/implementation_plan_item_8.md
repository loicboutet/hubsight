# Implementation Plan - Item 8: Admin - Create Portfolio Manager Account

## Overview
**Backlog Item:** Item 8 - Brick 1  
**Task Title:** Admin - Create Portfolio Manager Account  
**Description:** Implement functionality for Admin to create and configure Portfolio Manager accounts with proper permissions and organization assignment

## Current State Analysis

### What Exists
1. **User Model** (`app/models/user.rb`)
   - Has role-based system with 4 roles: admin, portfolio_manager, site_manager, technician
   - Has `organization_id` field in schema
   - Invitation system already implemented (token generation, email sending, acceptance)
   - Status tracking (active/inactive)
   - Devise authentication fully configured

2. **Portfolio Managers Controller** (`app/controllers/admin/portfolio_managers_controller.rb`)
   - Basic CRUD operations implemented
   - Invitation flow partially working
   - Missing proper admin authorization check (commented out)
   - Organization assignment exists in params but Organization model is missing

3. **Views** (`app/views/admin/portfolio_managers/`)
   - Basic form with user fields (first_name, last_name, email, phone, department)
   - Organization fields present but not functional (no Organization model yet)
   - Index, show, edit views exist

4. **Database Schema**
   - `users` table has `organization_id` column (integer, indexed)
   - No `organizations` table exists yet

### What's Missing
1. **Organization Model** - Not created yet (required for item 34, but needed now for reference)
2. **Proper Authorization** - Admin access control not enforced
3. **Audit Logging** - No tracking of admin actions on user accounts (required by item 9)
4. **Data Isolation** - No organization-based data scoping yet (required by item 51)
5. **Validation Enhancement** - Need better organization assignment validation
6. **Testing** - No test coverage for Portfolio Manager creation

## Implementation Plan

### Phase 1: Create Organization Foundation (Prerequisite)
**Note:** This is a minimal implementation for item 8; full Organization functionality is in item 34

#### 1.1 Create Organization Model and Migration
**Estimated Time:** 30 minutes

- [ ] Generate Organization model migration
- [ ] Add minimal fields needed for now:
  - `name` (string, required) - Organization name
  - `legal_name` (string) - Legal company name
  - `siret` (string) - French company identifier
  - `status` (string, default: 'active') - active/inactive
  - `created_at`, `updated_at` (timestamps)
- [ ] Add indexes on `status` and `siret`
- [ ] Run migration

**Files to Create/Modify:**
- `db/migrate/TIMESTAMP_create_organizations.rb`
- Update `db/schema.rb` (auto-generated)

#### 1.2 Create Basic Organization Model
**Estimated Time:** 20 minutes

- [ ] Create `app/models/organization.rb`
- [ ] Add validations:
  - Name presence and uniqueness
  - Status inclusion in ['active', 'inactive']
- [ ] Add associations:
  - `has_many :users, dependent: :restrict_with_error`
- [ ] Add scopes:
  - `active` scope
  - `inactive` scope

**Files to Create:**
- `app/models/organization.rb`

#### 1.3 Update User Model with Organization Association
**Estimated Time:** 15 minutes

- [ ] Add `belongs_to :organization` association (optional: true for now)
- [ ] Add validation for organization existence when organization_id present
- [ ] Add scope: `by_organization(organization_id)`

**Files to Modify:**
- `app/models/user.rb`

### Phase 2: Implement Admin Authorization
**Estimated Time:** 45 minutes

#### 2.1 Create Authorization Concern
- [ ] Create `app/controllers/concerns/admin_authorization.rb`
- [ ] Implement `require_admin!` method
- [ ] Add proper redirect with flash message for unauthorized access
- [ ] Log unauthorized access attempts

**Files to Create:**
- `app/controllers/concerns/admin_authorization.rb`

#### 2.2 Update Portfolio Managers Controller
- [ ] Include AdminAuthorization concern
- [ ] Replace placeholder `ensure_admin!` with `require_admin!`
- [ ] Add proper error handling
- [ ] Ensure all actions are protected

**Files to Modify:**
- `app/controllers/admin/portfolio_managers_controller.rb`

### Phase 3: Enhance Portfolio Manager Creation
**Estimated Time:** 2 hours

#### 3.1 Update Controller Logic
- [ ] Update `portfolio_manager_params` to properly handle organization_id
- [ ] Add organization validation before creating user
- [ ] Ensure organization is active before assignment
- [ ] Add better error messages for organization-related failures
- [ ] Implement proper transaction handling (atomic user + invitation creation)

**Business Rules to Implement:**
1. Organization must exist and be active
2. Only admins can create Portfolio Managers
3. Email must be unique across system
4. First name, last name, and organization are required
5. Status defaults to 'active'
6. Invitation email sent automatically after creation

**Files to Modify:**
- `app/controllers/admin/portfolio_managers_controller.rb`

#### 3.2 Enhance Form View
- [ ] Replace organization_name text input with organization selector
- [ ] Add organization dropdown/autocomplete (fetch active organizations)
- [ ] Add "Create New Organization" link (opens modal or new page)
- [ ] Display organization details when selected
- [ ] Add proper error display for all fields
- [ ] Remove non-functional address and role fields (not in schema)
- [ ] Show clear indication that invitation will be sent

**Files to Modify:**
- `app/views/admin/portfolio_managers/_form.html.erb`
- `app/views/admin/portfolio_managers/new.html.erb`

#### 3.3 Update Index View
- [ ] Add organization column to portfolio managers list
- [ ] Add filter by organization
- [ ] Add status indicator (active/inactive, invitation pending)
- [ ] Show invitation status (pending, accepted, expired)
- [ ] Add bulk actions capability (future enhancement hook)

**Files to Modify:**
- `app/views/admin/portfolio_managers/index.html.erb`

#### 3.4 Update Show View
- [ ] Display organization information
- [ ] Show invitation status and dates
- [ ] Display created_by (invited_by) information
- [ ] Add resend invitation button if pending
- [ ] Add deactivate/activate buttons
- [ ] Show last login information

**Files to Modify:**
- `app/views/admin/portfolio_managers/show.html.erb`

### Phase 4: Prepare for Audit Logging (Item 9 Integration)
**Estimated Time:** 30 minutes

**Note:** Full audit logging is part of Item 9 ("Admin - Access Client Data, including data isolation and audit logging"). However, since Item 8 involves admin actions on Portfolio Manager accounts, we should prepare hooks for future audit logging.

#### 4.1 Add Audit Logging Hooks (Preparation for Item 9)
- [ ] Check if `audit_trail_controller.rb` already provides audit infrastructure
- [ ] Add placeholder audit log calls in Portfolio Manager controller actions
- [ ] Use existing audit trail system if available
- [ ] Document audit logging requirements for Item 9 implementation
- [ ] Ensure admin actions can be tracked when Item 9 is implemented

**What to Track (for Item 9):**
- Portfolio Manager creation (user_id, action, changes, IP, timestamp)
- Portfolio Manager updates (what changed)
- Status changes (active/inactive)
- Invitation resends
- Deletion attempts

**Files to Review:**
- `app/controllers/audit_trail_controller.rb` (already exists)
- `app/views/audit_trail/index.html.erb` (already exists)

**Files to Modify:**
- `app/controllers/admin/portfolio_managers_controller.rb` (add audit hooks)

**Note:** Full audit model and logging implementation should be completed in Item 9.

### Phase 5: Implement Basic Organization Management
**Estimated Time:** 2 hours

#### 5.1 Create Basic Organizations Controller (Admin)
- [ ] Create `app/controllers/admin/organizations_controller.rb`
- [ ] Implement minimal CRUD:
  - Index (list all organizations)
  - New (create form)
  - Create (save new organization)
  - Show (view details)
  - Edit (update form)
  - Update (save changes)
- [ ] Add authorization (admin only)
- [ ] Add audit logging

**Files to Create:**
- `app/controllers/admin/organizations_controller.rb`

#### 5.2 Create Basic Organization Views
- [ ] Create simple form with name, legal_name, siret, status
- [ ] Create index page listing all organizations
- [ ] Create show page with organization details and associated users count
- [ ] Add "Create Organization" button to portfolio manager form

**Files to Create:**
- `app/views/admin/organizations/index.html.erb`
- `app/views/admin/organizations/new.html.erb`
- `app/views/admin/organizations/_form.html.erb`
- `app/views/admin/organizations/show.html.erb`
- `app/views/admin/organizations/edit.html.erb`

#### 5.3 Update Routes
- [ ] Add organizations resource under admin namespace
- [ ] Add custom routes for organization activation/deactivation
- [ ] Ensure proper RESTful routing

**Files to Modify:**
- `config/routes.rb`

### Phase 6: Data Validation & Error Handling
**Estimated Time:** 1 hour

#### 6.1 Add Comprehensive Validations
- [ ] Validate organization exists and is active on user creation
- [ ] Validate email format and uniqueness
- [ ] Validate name fields (no special characters, reasonable length)
- [ ] Validate phone format (optional but formatted when present)
- [ ] Add custom error messages in French

**Files to Modify:**
- `app/models/user.rb`
- `app/models/organization.rb`

#### 6.2 Improve Error Handling in Controller
- [ ] Handle ActiveRecord::RecordNotFound gracefully
- [ ] Handle validation errors with specific messages
- [ ] Handle email delivery failures
- [ ] Add flash messages for all scenarios (success, error, warning)
- [ ] Log errors for debugging

**Files to Modify:**
- `app/controllers/admin/portfolio_managers_controller.rb`

#### 6.3 Enhance View Error Display
- [ ] Display inline field errors
- [ ] Show error summary at top of form
- [ ] Maintain form values on validation failure
- [ ] Add helpful hints for each field

**Files to Modify:**
- `app/views/admin/portfolio_managers/_form.html.erb`

### Phase 7: Testing & Documentation
**Estimated Time:** 2 hours

#### 7.1 Create Tests
- [ ] Model tests for User organization association
- [ ] Model tests for Organization validations
- [ ] Controller tests for authorization enforcement
- [ ] Controller tests for create action (success & failure cases)
- [ ] Integration tests for full creation workflow
- [ ] Test invitation email sending

**Files to Create:**
- `test/models/organization_test.rb`
- `test/controllers/admin/portfolio_managers_controller_test.rb`
- `test/controllers/admin/organizations_controller_test.rb`
- `test/integration/admin_creates_portfolio_manager_test.rb`

#### 7.2 Update Documentation
- [ ] Document the Portfolio Manager creation process
- [ ] Document organization assignment requirements
- [ ] Document audit logging format
- [ ] Add API documentation if needed
- [ ] Update README with admin setup instructions

**Files to Create/Modify:**
- `doc/admin_portfolio_manager_creation.md`

### Phase 8: UI/UX Enhancements
**Estimated Time:** 1.5 hours

#### 8.1 Improve User Experience
- [ ] Add loading states for form submission
- [ ] Add confirmation dialog for deletion
- [ ] Add success animation/feedback
- [ ] Improve mobile responsiveness
- [ ] Add keyboard shortcuts for common actions
- [ ] Add tooltips for complex fields

#### 8.2 Add Organization Autocomplete (Enhancement)
- [ ] Create Stimulus controller for organization search
- [ ] Add AJAX endpoint for organization search
- [ ] Implement dropdown with search
- [ ] Show organization details on selection
- [ ] Add "Create New" option in dropdown

**Files to Create:**
- `app/javascript/controllers/organization_selector_controller.js`

**Files to Modify:**
- `app/views/admin/portfolio_managers/_form.html.erb`

### Phase 9: Security Hardening
**Estimated Time:** 1 hour

#### 9.1 Security Measures
- [ ] Implement CSRF protection verification
- [ ] Add rate limiting for user creation
- [ ] Sanitize all input parameters
- [ ] Prevent email enumeration attacks
- [ ] Add honeypot fields for bot detection
- [ ] Implement secure invitation token generation (already exists, verify)
- [ ] Set appropriate session timeouts
- [ ] Add Content Security Policy headers

**Files to Modify:**
- `app/controllers/admin/portfolio_managers_controller.rb`
- `config/application.rb` or `config/initializers/security.rb`

### Phase 10: Integration with Existing System
**Estimated Time:** 1 hour

#### 10.1 Admin Layout Integration
- [ ] Verify integration with existing admin layout
- [ ] Add navigation menu item for Portfolio Managers
- [ ] Add navigation menu item for Organizations
- [ ] Update admin dashboard to show Portfolio Manager stats
- [ ] Add breadcrumbs navigation

**Files to Modify:**
- `app/views/layouts/admin.html.erb`
- `app/views/dashboard/admin.html.erb` (if exists)

#### 10.2 Email Template Verification
- [ ] Verify invitation email template exists and is correct
- [ ] Ensure email includes organization information
- [ ] Test email delivery in development
- [ ] Configure production email settings

**Files to Verify/Modify:**
- `app/views/user_mailer/invitation_instructions.html.erb`
- `app/mailers/user_mailer.rb`

## Implementation Order

### Sprint 1: Foundation (4-5 hours)
1. Phase 1: Create Organization Foundation
2. Phase 2: Implement Admin Authorization
3. Phase 3.1-3.2: Basic Controller and Form Updates

### Sprint 2: Core Features (4-5 hours)
4. Phase 3.3-3.4: View Enhancements
5. Phase 4: Prepare for Audit Logging (Item 9)
6. Phase 5: Organization Management

### Sprint 3: Polish & Quality (3-4 hours)
7. Phase 6: Validation & Error Handling
8. Phase 7: Testing & Documentation
9. Phase 8: UI/UX Enhancements

### Sprint 4: Security & Integration (2-3 hours)
10. Phase 9: Security Hardening
11. Phase 10: System Integration

**Total Estimated Time:** 12-16 hours

## Testing Strategy

### Manual Testing Checklist
- [ ] Admin can access Portfolio Manager creation page
- [ ] Non-admin cannot access Portfolio Manager creation page
- [ ] Form validates all required fields
- [ ] Organization dropdown shows only active organizations
- [ ] Creating Portfolio Manager sends invitation email
- [ ] Invitation email contains correct information
- [ ] Portfolio Manager appears in index page after creation
- [ ] Audit logging hooks are in place (for Item 9)
- [ ] Organization assignment is correct
- [ ] Status toggling works (active/inactive)
- [ ] Editing Portfolio Manager preserves organization
- [ ] Deleting Portfolio Manager shows confirmation
- [ ] Search and filter work correctly
- [ ] Mobile layout is responsive
- [ ] All error messages display correctly in French
- [ ] Invitation can be resent if pending
- [ ] Expired invitations are detected and can be renewed

### Automated Testing Areas
- Unit tests for models (validations, associations)
- Controller tests (authorization, CRUD operations)
- Integration tests (full user creation workflow)
- System tests (browser-based end-to-end testing)
- Email delivery tests
- Audit log creation tests

## Success Criteria

### Functional Requirements ✅
- [ ] Admin can successfully create Portfolio Manager accounts
- [ ] Portfolio Managers are assigned to organizations
- [ ] Invitation emails are sent automatically
- [ ] Only admins can access this functionality
- [ ] Audit logging hooks prepared (full implementation in Item 9)
- [ ] Organization association is enforced
- [ ] Status management works (active/inactive)
- [ ] Form validation prevents invalid data

### Non-Functional Requirements ✅
- [ ] Page loads in under 2 seconds
- [ ] Form submission completes in under 3 seconds
- [ ] Mobile responsive (works on tablets and phones)
- [ ] Accessible (WCAG 2.1 Level AA compliance)
- [ ] Secure (passes security audit)
- [ ] Code coverage > 80%
- [ ] French language interface
- [ ] Proper error messages shown to users

### Business Requirements ✅
- [ ] Supports multi-client data isolation (organization-based)
- [ ] Audit trail hooks prepared (full implementation in Item 9)
- [ ] Invitation-based onboarding workflow
- [ ] Role-based access control enforced
- [ ] Email verification requirement satisfied
- [ ] Password strength validation enforced

## Risk Mitigation

### Technical Risks
1. **Organization Model Dependency**
   - Mitigation: Create minimal Organization model first
   - Fallback: Allow NULL organization initially, migrate later

2. **Email Delivery Failures**
   - Mitigation: Queue emails with retry logic
   - Fallback: Show invitation link to admin for manual sending

3. **Database Migration Issues**
   - Mitigation: Test migrations in development first
   - Rollback plan: Keep migration reversible

### Business Risks
1. **User Confusion with Invitation Flow**
   - Mitigation: Clear UI messaging and help text
   - Training materials for admins

2. **Data Isolation Breach**
   - Mitigation: Thorough testing of organization scoping
   - Security audit before production

## Future Enhancements (Post-Item 8)
- Bulk Portfolio Manager creation (CSV import)
- Advanced organization search and filtering
- Portfolio Manager activity dashboard
- Email template customization per organization
- Multi-language support (currently French only)
- API endpoints for Portfolio Manager management
- Integration with external identity providers (SSO)
- Automated organization assignment based on email domain
- Portfolio Manager profile completeness indicators
- Onboarding workflow tracking

## Dependencies on Other Backlog Items

### Prerequisite Items (Must Complete First)
- Item 7: Role-Based Access Control (RBAC) - ⚠️ Partially exists, needs completion

### Related Items (Will Need Coordination)
- **Item 9: Admin - Access Client Data** - This item includes full audit logging implementation. Item 8 should prepare hooks for this.
- Item 34: PM - Create Organizations (full Organization CRUD)

### Dependent Items (Will Use This Feature)
- Item 10: PM - Create Site Manager Profiles
- Item 11: PM - Assign Sites to Site Managers

## Notes for Implementation

### Code Style Guidelines
- Follow Ruby on Rails best practices
- Use Rails 8.0 conventions
- Follow existing codebase patterns
- Write self-documenting code
- Add comments for complex business logic

### Internationalization
- All user-facing text in French
- Use I18n for all strings (prepare for multi-language)
- Date/time formatting according to French locale

### Performance Considerations
- Index foreign keys (organization_id, invited_by_id)
- Eager load associations in list views (includes :organization)
- Paginate index pages (25 items per page)
- Cache organization dropdown data

### Accessibility
- Proper form labels with `for` attributes
- ARIA labels where needed
- Keyboard navigation support
- Screen reader friendly
- High contrast mode support

## Resources Required

### Development Tools
- Ruby on Rails 8.0
- PostgreSQL or SQLite (current: SQLite)
- Git for version control
- Letter Opener for email testing (development)

### Testing Tools
- Minitest (Rails default)
- Capybara for system tests
- Factory Bot for test data

### Third-Party Services
- Email delivery service (Postmark, SendGrid, or SMTP)
- Monitoring service for production errors

## Rollout Plan

### Development Environment
1. Complete all phases in feature branch
2. Run all tests
3. Manual QA testing

### Staging Environment
1. Deploy to staging
2. Run smoke tests
3. Perform security audit
4. Invite stakeholders for UAT

### Production Environment
1. Deploy during maintenance window
2. Enable feature flag if using feature toggles
3. Monitor error rates
4. Gather user feedback

## Support & Maintenance

### Documentation to Maintain
- Admin user guide
- Technical documentation
- API documentation (if applicable)
- Troubleshooting guide

### Monitoring
- Track creation success rate
- Monitor invitation email delivery rate
- Monitor page load times
- Track authorization failures (potential security issues)

### Maintenance Tasks
- Clean up expired invitations (monthly)
- Review audit logs (weekly)
- Update gem dependencies (monthly)
- Security patches (as needed)

---

## Summary

This implementation plan provides a comprehensive roadmap for Item 8: Admin - Create Portfolio Manager Account. The plan is divided into 10 phases with clear deliverables, time estimates, and success criteria. The implementation will take approximately 13-17 hours spread across 4 sprints.

Key deliverables:
1. Organization model and basic management
2. Enhanced Portfolio Manager creation with organization assignment
3. Proper admin authorization
4. Audit logging for compliance
5. Comprehensive testing and documentation
6. Production-ready security hardening

The plan accounts for dependencies on other backlog items and provides contingency measures for identified risks.
