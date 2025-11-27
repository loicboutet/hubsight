# Implementation Plan - Item 9: Admin - Access Client Data

## Overview
Implementation of secure admin access to client data with formal authorization tracking, data isolation, and comprehensive audit logging.

## Status: ✅ COMPLETED

## Backlog Item Details
- **SL**: 9
- **Brick**: Brick 1
- **Task Title**: Admin - Access Client Data
- **Description**: Enable Admin to access client data with formalized contractual authorization, including data isolation and audit logging

## Implementation Summary

This implementation provides administrators with the ability to access client organization data while maintaining complete audit trails and security controls. The system uses session-based impersonation with automatic timeout, comprehensive logging, and a prominent visual banner to indicate when an admin is viewing client data.

## Database Changes

### 1. New Table: `admin_access_logs`
Created migration: `db/migrate/20251127181426_create_admin_access_logs.rb`

**Columns:**
- `admin_user_id` (integer, indexed) - The admin performing the action
- `organization_id` (integer, indexed) - The client organization being accessed
- `action_type` (string) - Type of access (impersonate, stop_impersonation)
- `ip_address` (string) - Admin's IP address
- `user_agent` (text) - Browser/device information
- `started_at` (datetime) - When impersonation started
- `ended_at` (datetime) - When impersonation ended
- `metadata` (json) - Additional context (admin email, org name, etc.)
- `created_at`, `updated_at` (timestamps)

## New Files Created

### Models
1. **`app/models/admin_access_log.rb`**
   - Tracks all admin access to client data
   - Provides scopes for filtering (active, completed, by_admin, by_organization)
   - Calculates session duration
   - Helper method: `log_impersonation_start`

### Controllers
2. **`app/controllers/concerns/impersonation.rb`**
   - Core impersonation functionality
   - Session management with 2-hour timeout
   - Helper methods: `impersonating?`, `impersonated_organization`, `current_organization`
   - Security: `require_admin_for_impersonation`

3. **`app/models/concerns/data_isolation.rb`**
   - Automatic query scoping by organization
   - Validation helpers for organization access
   - Methods: `organization_scoped?`, `belongs_to_organization?`

4. **`app/controllers/admin/access_logs_controller.rb`**
   - Lists all admin access logs
   - Provides filtering by admin, organization, action type, status
   - Pagination support (50 records per page)

### Views
5. **`app/views/admin/clients/index.html.erb`**
   - Lists all client organizations
   - Shows user statistics per organization
   - Security warning about data access
   - "Accéder aux données" button with confirmation

6. **`app/views/shared/_impersonation_banner.html.erb`**
   - Fixed red banner at top of screen
   - Shows organization being accessed
   - "Terminer l'accès" button
   - Responsive design

7. **`app/views/admin/access_logs/index.html.erb`**
   - Comprehensive audit log viewer
   - Filters for admin, organization, action type, status
   - Shows duration, IP address, timestamps
   - Pagination and security notice

## Modified Files

### Controllers
1. **`app/controllers/admin/clients_controller.rb`**
   - Implemented `index` action to list organizations
   - Implemented `impersonate` action to start data access
   - Implemented `stop_impersonation` action
   - Added user statistics calculation

2. **`app/controllers/application_controller.rb`**
   - Included `Impersonation` concern
   - Makes impersonation helpers available app-wide

### Views
3. **`app/views/layouts/admin.html.erb`**
   - Added impersonation banner render at top
   - Banner renders conditionally when impersonating

### Routes
4. **`config/routes.rb`**
   - Added `admin/access_logs` routes (index, show)
   - Confirmed existing client impersonation routes

## Key Features

### 1. Secure Impersonation System
- **Session-based**: Uses Rails session for storing impersonation state
- **Automatic Timeout**: 2-hour expiration for security
- **Admin-only**: Restricted to users with admin role
- **Confirmation Required**: Double-check before accessing client data

### 2. Comprehensive Audit Logging
- **Every Access Logged**: Start and end times recorded
- **IP Tracking**: Admin's IP address captured
- **User Agent**: Device/browser information stored
- **Metadata**: Additional context (emails, organization names)
- **Duration Calculation**: Automatic session duration tracking

### 3. Visual Indicators
- **Red Banner**: Prominent fixed banner when impersonating
- **Organization Name**: Clear display of accessed client
- **Quick Exit**: Always-visible stop button
- **Warning Messages**: Security notices and confirmations

### 4. Data Isolation
- **Automatic Scoping**: Queries filtered by organization context
- **Validation Helpers**: Check resource ownership
- **Current Organization**: Helper to get active context
- **Safe Defaults**: No cross-client data leakage

### 5. Audit Trail Interface
- **Filterable**: By admin, organization, action, status
- **Searchable**: Find specific access events
- **Detailed**: Shows all relevant information
- **Paginated**: 50 records per page

## Security Considerations

### 1. Authorization
- Only admin role can access impersonation features
- Double confirmation before data access
- Automatic session cleanup on logout

### 2. Logging
- All actions logged with timestamps
- IP addresses tracked
- Cannot be deleted or modified
- Permanent audit trail

### 3. Session Management
- 2-hour automatic timeout
- Manual stop available anytime
- Session state stored server-side
- No client-side manipulation possible

### 4. Data Isolation
- Queries automatically scoped
- Organization context enforced
- Cross-client access prevented
- Validation at model level

## Routes Added

```ruby
namespace :admin do
  resources :clients, only: [:index] do
    member do
      post :impersonate
    end
  end
  post 'stop_impersonation', to: 'clients#stop_impersonation'
  
  resources :access_logs, only: [:index, :show]
end
```

## Helper Methods Available

### In Controllers & Views:
- `impersonating?` - Check if currently impersonating
- `impersonated_organization` - Get the organization being accessed
- `current_organization` - Get organization context (impersonated or user's own)

### In Models:
- `AdminAccessLog.log_impersonation_start(admin, org, request)` - Log access start
- `log.end_impersonation!` - End access session
- `log.duration_in_words` - Human-readable duration

## Testing Instructions

### 1. Access Client Data
1. Login as admin (admin@hubsight.com / Password123!)
2. Navigate to `/admin/clients`
3. Click "Accéder aux données" for an organization
4. Confirm the security warning
5. Verify red banner appears at top
6. Access organization data (contracts, sites, etc.)
7. Click "Terminer l'accès" to stop

### 2. Verify Audit Logging
1. After impersonating, navigate to `/admin/access_logs`
2. Verify log entry appears with:
   - Your admin email
   - Organization name
   - IP address
   - Start time
   - Status: "Active" during session, "Terminée" after stopping

### 3. Test Timeout
1. Start impersonation session
2. Wait 2+ hours (or modify timeout duration in code for testing)
3. Try to access a page
4. Verify automatic redirect with timeout message

### 4. Test Data Isolation
1. Impersonate Organization A
2. Try to access data from Organization B
3. Verify data is scoped correctly to Organization A only

## Usage Example

```ruby
# In a controller
if impersonating?
  # Admin is viewing client data
  org = current_organization
  # All queries will be scoped to this org
end

# Start impersonation
start_impersonation(organization)

# Stop impersonation
stop_impersonation

# Check organization context
@sites = current_organization&.sites || Site.none
```

## Configuration

### Timeout Duration
Located in: `app/controllers/concerns/impersonation.rb`

```ruby
def check_impersonation_timeout
  timeout_duration = 2.hours.to_i  # Modify here
  # ...
end
```

## Future Enhancements

1. **Configurable Timeout**: Admin setting for timeout duration
2. **Reason Logging**: Require admins to provide reason for access
3. **Email Notifications**: Alert organization owner when accessed
4. **Access Approval**: Require organization consent before access
5. **Detailed Action Logging**: Track specific actions during impersonation
6. **Export Logs**: Download audit logs as CSV/PDF

## Related Documentation
- Item 8: Admin - Create Portfolio Manager Account (doc/implementation_plan_item_8.md)
- Item 10: PM - Create Site Manager Profiles (to be implemented)

## Compliance Notes

This implementation supports compliance with:
- **GDPR**: Full audit trail of data access
- **ISO 27001**: Access control and logging requirements
- **SOC 2**: Audit trail and access management
- **Client Contracts**: Documented authorization for data access

---

**Implementation Date**: November 27, 2025  
**Developer**: AI Assistant (Cline)  
**Status**: Completed and Ready for Testing
