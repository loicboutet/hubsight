# HubSight Development Backlog Reference
**Total Tasks: 92 | Budget: €10,000 (€5,000 per Brick)**

This document serves as a quick reference for all backlog tasks. When implementing, refer to this by SL number.

---

## 🔐 AUTHENTICATION & USER REGISTRATION (SL 1-7) - BRICK 1

### SL 1: User Registration - Sign Up
**Brick:** 1  
**Description:** Implement user registration/signup form with email, password, name fields. Email verification required before account activation  
**Files to Create/Modify:**
- `app/views/devise/registrations/new.html.erb`
- `app/controllers/application_controller.rb` (email verification)
- Email templates for verification

### SL 2: User Login - Sign In
**Brick:** 1  
**Description:** Implement secure login functionality with email/password, remember me option, and failed login attempt tracking  
**Files to Create/Modify:**
- `app/views/devise/sessions/new.html.erb`
- Login tracking in User model
- Failed attempt counter

### SL 3: Password Reset - Forgot Password
**Brick:** 1  
**Description:** Implement password reset flow: request reset link via email, verify token, set new password with strength validation  
**Files to Create/Modify:**
- `app/views/devise/passwords/new.html.erb`
- `app/views/devise/passwords/edit.html.erb`
- Password strength validator

### SL 4: Email Verification
**Brick:** 1  
**Description:** Email confirmation system: send verification email on signup, validate confirmation token, activate account  
**Files to Create/Modify:**
- `app/views/devise/confirmations/new.html.erb`
- Email templates
- User model confirmation logic

### SL 5: User Profile Management
**Brick:** 1  
**Description:** Allow users to update their profile: name, email, password, notification preferences, language settings  
**Files to Create/Modify:**
- `app/views/devise/registrations/edit.html.erb`
- User settings controller
- Profile update validations

### SL 6: Session Management
**Brick:** 1  
**Description:** Secure session handling with timeout, "remember me" cookie, concurrent session management, logout functionality  
**Files to Create/Modify:**
- `config/initializers/devise.rb`
- Session timeout configuration
- Logout routes

### SL 7: Role-Based Access Control (RBAC)
**Brick:** 1  
**Description:** Implement role-based permissions system for Admin, Portfolio Manager, Site Manager, and Technician roles  
**Files to Create/Modify:**
- User model with role enum
- Authorization helpers
- Controller before_action filters

---

## 📋 ADMIN FEATURES (SL 8-10) - BRICK 1

### SL 8: Admin - Create Portfolio Manager Account
**Brick:** 1  
**Description:** Implement functionality for Admin to create and configure Portfolio Manager accounts with proper permissions and organization assignment  
**Routes:** `/admin/portfolio_managers`

### SL 9: Admin - Access Client Data
**Brick:** 1  
**Description:** Enable Admin to access client data with formalized contractual authorization, including data isolation and audit logging  
**Routes:** `/admin/clients`

### SL 10: Admin - Client Impersonation
**Brick:** 1  
**Description:** Implement secure client impersonation feature allowing Admin to view and navigate the platform as a specific client for support purposes  
**Routes:** `/admin/clients/:id/impersonate`

---

## 👑 PORTFOLIO MANAGER - USER MANAGEMENT (SL 11-12) - BRICK 1

### SL 11: PM - Create Site Manager Profiles
**Brick:** 1  
**Description:** Portfolio Manager can create and manage Site Manager profiles for their organization with role-based permissions  
**Routes:** `/site_managers`

### SL 12: PM - Assign Sites to Site Managers
**Brick:** 1  
**Description:** Implement site assignment functionality allowing Portfolio Managers to assign specific sites to Site Manager users  
**Routes:** `/site_managers/:id/assign_sites`

---

## 🏗️ PORTFOLIO MANAGER - ASSET STRUCTURE (SL 13-18) - BRICK 1

### SL 13: PM - Create and Manage Sites
**Brick:** 1  
**Description:** Full CRUD functionality for sites including name, address, area, site type, and other attributes from the data model  
**Routes:** `/sites`

### SL 14: PM - Create and Manage Buildings
**Brick:** 1  
**Description:** Full CRUD functionality for buildings nested under sites, including construction year, area, ERP classification, energy data, etc.  
**Routes:** `/sites/:site_id/buildings`, `/buildings/:id`

### SL 15: PM - Create and Manage Levels
**Brick:** 1  
**Description:** Full CRUD functionality for levels (floors) nested under buildings, including level number, altitude, and floor area  
**Routes:** `/buildings/:building_id/levels`, `/levels/:id`

### SL 16: PM - Create and Manage Spaces
**Brick:** 1  
**Description:** Full CRUD functionality for spaces/rooms nested under levels, including type, area, capacity, usage, and technical characteristics  
**Routes:** `/levels/:level_id/spaces`, `/spaces/:id`

### SL 17: PM - Create and Manage Equipment
**Brick:** 1  
**Description:** Full CRUD functionality for equipment nested under spaces, including manufacturer, model, serial number, commissioning date, technical specs  
**Routes:** `/spaces/:space_id/equipment`, `/equipment/:id`

### SL 18: PM - Tree View Navigation
**Brick:** 1  
**Description:** Implement hierarchical tree navigation: Portfolio > Sites > Buildings > Levels > Spaces > Equipment with expand/collapse functionality  
**Implementation:** JavaScript-based tree component with AJAX loading

---

## 🔧 PORTFOLIO MANAGER - EQUIPMENT DATABASE (SL 19-23) - BRICK 1

### SL 19: PM - Import OmniClass Table 23
**Brick:** 1  
**Description:** Import OmniClass Table 23 equipment classification (256 equipment types) from Excel file provided by client  
**Routes:** `/imports/equipment_types`

### SL 20: PM - Import Space Structure
**Brick:** 1  
**Description:** Import space structure including OmniClass Table 13 space classifications (966 types) from Excel file  
**Routes:** `/imports/spaces`

### SL 21: PM - Import Contract Families
**Brick:** 1  
**Description:** Import contract families and subfamilies (7 families, 20+ subfamilies) from Excel file provided by client  
**Routes:** `/imports/contract_families`

### SL 22: PM - Equipment Search & Autocomplete
**Brick:** 1  
**Description:** Search and autocomplete system in equipment database to facilitate manual entry, with filtering by technical lot and function  
**Routes:** `/equipment/search`, `/api/autocomplete/equipment_types`

### SL 23: PM - Link Equipment to OmniClass
**Brick:** 1  
**Description:** Manual linking interface for associating equipment with OmniClass classification codes via search system  
**Implementation:** Form with OmniClass autocomplete

---

## 📄 PORTFOLIO MANAGER - CONTRACT MANAGEMENT (SL 24-34) - BRICK 1

### SL 24: PM - Upload PDF Contracts
**Brick:** 1  
**Description:** Upload multi-page PDF contract documents with progress indicator and file validation (max size, file type)  
**Routes:** `/contracts/upload`

### SL 25: PM - OCR Text Extraction (Mistral)
**Brick:** 1  
**Description:** Integrate Mistral OCR API for text extraction from uploaded PDF documents (~€0.10/contract cost)  
**Implementation:** Background job with Mistral API integration

### SL 26: PM - LLM Data Structuring (OpenRouter)
**Brick:** 1  
**Description:** Automatic data extraction via LLM (OpenRouter): contract number, dates, type, provider, durations, renewal, equipment, amounts (72 fields)  
**Implementation:** OpenRouter API integration for structured extraction

### SL 27: PM - Validate Extracted Data
**Brick:** 1  
**Description:** Manual validation interface showing extracted data side-by-side with PDF, allowing corrections and confirmations before saving  
**Routes:** `/contracts/:id/validate`

### SL 28: PM - Manual Contract Creation
**Brick:** 1  
**Description:** Create contracts manually when no document exists or extraction is incomplete, with comprehensive form for all 72 contract fields  
**Routes:** `/contracts/new`

### SL 29: PM - Contract Family Search
**Brick:** 1  
**Description:** Search and autocomplete system in contract family/subfamily database to facilitate manual linking during contract entry  
**Routes:** `/contract_families/search`

### SL 30: PM - Link Services to Contract Families
**Brick:** 1  
**Description:** Manual linking of services to Contract Family/Subfamily using search system with autocomplete suggestions  
**Implementation:** Form with autocomplete

### SL 31: PM - Auto-Calculate Contract Dates
**Brick:** 1  
**Description:** Automatically calculate last renewal date, contract expiry date, termination deadline, last amount update date based on contract parameters  
**Implementation:** Contract model callbacks/methods

### SL 32: PM - Auto-Calculate VAT Amounts
**Brick:** 1  
**Description:** Automatically calculate VAT inclusive amounts from exclusive amounts based on configurable VAT rates  
**Implementation:** Contract model calculations

### SL 33: PM - View Contract List
**Brick:** 1  
**Description:** Display contracts in list/table view with pagination, sorting, and column customization  
**Routes:** `/contracts`

### SL 34: PM - Filter Contracts
**Brick:** 1  
**Description:** Multiple filter options: by site, building, contract family, service provider, status, date ranges, amount ranges  
**Implementation:** Advanced filtering on contracts index

---

## 🏢 PORTFOLIO MANAGER - ORGANIZATION MANAGEMENT (SL 35-39) - BRICK 1

### SL 35: PM - Create Organizations
**Brick:** 1  
**Description:** Create and manage organizations (companies) with 12 fields: name, legal name, SIRET, type, address, contacts, specialties, status  
**Routes:** `/organizations`

### SL 36: PM - Create Contacts
**Brick:** 1  
**Description:** Create and manage contacts nested under organizations with 11 fields: name, position, phone, email, availability, languages  
**Routes:** `/organizations/:organization_id/contacts`, `/contacts`

### SL 37: PM - Create Agencies
**Brick:** 1  
**Description:** Create and manage agencies/establishments under organizations with address, service area, certifications  
**Implementation:** Nested resource under organizations

### SL 38: PM - Organization Search & Autocomplete
**Brick:** 1  
**Description:** Search and autocomplete for organizations and contacts databases to facilitate manual linking during contract entry  
**Routes:** `/organizations/search`, `/api/autocomplete/organizations`

### SL 39: PM - Link Organizations to Contracts
**Brick:** 1  
**Description:** Manual linking of organizations (service providers) to contracts using search system with organization details preview  
**Implementation:** Organization selector in contract form

---

## 📊 PORTFOLIO MANAGER - EXPORTS & REPORTS (SL 40-43) - BRICK 1

### SL 40: PM - Generate Contract PDF Summary
**Brick:** 1  
**Description:** Generate PDF summary sheets per contract with emergency numbers, references, equipment list, based on client template  
**Routes:** `/contracts/:id/pdf`

### SL 41: PM - Export Contract List
**Brick:** 1  
**Description:** Export contract list to Excel/CSV with selected columns and applied filters  
**Routes:** `/exports/contracts`

### SL 42: PM - Export Equipment List
**Brick:** 1  
**Description:** Export equipment list to Excel/CSV with hierarchy context (site > building > level > space)  
**Routes:** `/exports/equipment`

### SL 43: PM - Export Sites Structure
**Brick:** 1  
**Description:** Export complete sites structure to Excel with hierarchical indentation or nested sheets  
**Routes:** `/exports/sites`

---

## 📈 PORTFOLIO MANAGER - DASHBOARD & VISUALIZATION (SL 44-46) - BRICK 1

### SL 44: PM - Portfolio Overview Dashboard
**Brick:** 1  
**Description:** Dashboard displaying portfolio overview: total sites, buildings, equipment, contracts, total contract value, key metrics  
**Routes:** `/dashboard`

### SL 45: PM - Key Indicators Display
**Brick:** 1  
**Description:** Display key indicators: contracts by status, contracts by family, upcoming renewals, total spend by category  
**Implementation:** Dashboard widgets

### SL 46: PM - Analytics Dashboard
**Brick:** 1  
**Description:** Analytics page with charts and graphs showing contract distribution, spending trends, equipment distribution by type  
**Routes:** `/analytics`

---

## 🏢 SITE MANAGER FEATURES (SL 47-51) - BRICK 1

### SL 47: SM - View Assigned Sites
**Brick:** 1  
**Description:** Site Manager can view only sites assigned to them by Portfolio Manager with restricted access to other sites  
**Routes:** `/my_sites`

### SL 48: SM - View Site Contracts
**Brick:** 1  
**Description:** View contracts related to assigned sites with read-only access to contract details  
**Routes:** `/my_contracts`

### SL 49: SM - Upload Contracts for Scope
**Brick:** 1  
**Description:** Upload contract PDFs for sites within their scope, triggering OCR/LLM extraction workflow  
**Routes:** `/my_contracts/upload`

### SL 50: SM - View Site Equipment
**Brick:** 1  
**Description:** View list of equipment for assigned sites with hierarchical navigation (building > level > space > equipment)  
**Routes:** `/my_sites/:id/equipment`

### SL 51: SM - Generate Contract PDF
**Brick:** 1  
**Description:** Generate and export contract summary sheets in PDF format for contracts within their scope  
**Routes:** `/my_contracts/:id/pdf`

---

## ⚙️ SYSTEM FEATURES - BRICK 1 (SL 52-56)

### SL 52: System - Data Isolation
**Brick:** 1  
**Description:** Complete data isolation between clients ensuring no cross-client data access or visibility  
**Implementation:** Tenant-based scoping in all queries

### SL 53: System - Responsive Web Design
**Brick:** 1  
**Description:** Responsive web interface working seamlessly on desktop, tablet, and mobile devices  
**Implementation:** Tailwind CSS responsive utilities

### SL 54: System - Client Branding
**Brick:** 1  
**Description:** Clean design with client's graphic charter (logo and colors integration)  
**Implementation:** Customizable theme system

### SL 55: System - HTTPS & Security
**Brick:** 1  
**Description:** Secure hosting in France with HTTPS connections, SSL certificates, and data encryption  
**Implementation:** Production deployment configuration

### SL 56: System - Global Search
**Brick:** 1  
**Description:** Global search functionality across contracts, equipment, sites, organizations with faceted filtering  
**Routes:** `/search`

---

## 📋 ADMIN FEATURES - BRICK 2 (SL 57-60)

### SL 57: Admin - Price Reference Management
**Brick:** 2  
**Description:** Administration interface for managing price reference database with CRUD operations  
**Routes:** `/admin/price_references`

### SL 58: Admin - Create Price References
**Brick:** 2  
**Description:** Create/modify price references by equipment type, service type, contract family/subfamily, and location  
**Implementation:** Price reference form with categorization

### SL 59: Admin - Import Price References
**Brick:** 2  
**Description:** Import price reference database from Excel files with validation and error handling  
**Routes:** `/admin/price_references/import`

### SL 60: Admin - Export Price References
**Brick:** 2  
**Description:** Export price reference database to Excel format for external analysis or updates  
**Routes:** `/admin/price_references/export`

---

## 🤖 PM - AUTOMATIC MATCHING - BRICK 2 (SL 61-65)

### SL 61: PM - Auto-Match Equipment to Database
**Brick:** 2  
**Description:** Automatic matching system between extracted equipment and Equipment Database using LLM with confidence scoring  
**Implementation:** LLM-based matching with confidence scores

### SL 62: PM - Auto-Match Contract Families
**Brick:** 2  
**Description:** Automatic matching of services to Contract Family/Subfamily using LLM with suggestion interface  
**Implementation:** LLM-based classification

### SL 63: PM - Auto-Match Organizations
**Brick:** 2  
**Description:** Automatic matching of service providers to Organizations database using LLM with confidence scoring  
**Implementation:** LLM-based entity matching

### SL 64: PM - Validate/Correct Suggestions
**Brick:** 2  
**Description:** Validation/correction interface for AI suggestions showing confidence scores with approve/reject/modify actions  
**Routes:** `/contracts/:id/validate_suggestions`

### SL 65: PM - Progressive Learning System
**Brick:** 2  
**Description:** System learns from user corrections to improve future matching accuracy using feedback loop  
**Implementation:** Machine learning feedback system

---

## 🔔 PM - ALERT SYSTEM - BRICK 2 (SL 66-72)

### SL 66: PM - Upcoming Alerts
**Brick:** 2  
**Description:** "Upcoming" alerts: X days before termination deadline with configurable delay per contract or globally  
**Implementation:** Scheduled job checking deadlines

### SL 67: PM - At-Risk Alerts
**Brick:** 2  
**Description:** "At risk" alerts: deadline passed without action, requiring immediate attention  
**Implementation:** Alert generation for overdue items

### SL 68: PM - Missing Contracts Alerts
**Brick:** 2  
**Description:** "Missing contracts" alerts: mandatory contracts not referenced for a site type based on regulatory requirements  
**Implementation:** Compliance checking system

### SL 69: PM - Acknowledge Alerts
**Brick:** 2  
**Description:** Manual validation of alerts by users with "acknowledged" status and history tracking  
**Routes:** `/alerts/:id/acknowledge`

### SL 70: PM - Email Notifications
**Brick:** 2  
**Description:** Automatic email notifications for critical alerts with configurable frequency and recipients  
**Implementation:** Mailer with alert digests

### SL 71: PM - Configure Notifications
**Brick:** 2  
**Description:** Configure email notification preferences: which alerts to receive, frequency, recipients, escalation rules  
**Routes:** `/alerts/settings`

### SL 72: PM - Alerts Dashboard
**Brick:** 2  
**Description:** Comprehensive alerts dashboard showing all active alerts by type, severity, and age with filtering capabilities  
**Routes:** `/alerts`

---

## 💰 PM - PRICE COMPARISON & SAVINGS - BRICK 2 (SL 73-79)

### SL 73: PM - Automatic Price Comparison
**Brick:** 2  
**Description:** Automatic comparison between contractual prices and reference prices from database  
**Implementation:** Background job comparing prices

### SL 74: PM - Calculate Potential Savings
**Brick:** 2  
**Description:** Calculate potential savings in absolute value (€) and percentage (%) for each contract  
**Implementation:** Savings calculation in Contract model

### SL 75: PM - View Savings by Contract
**Brick:** 2  
**Description:** Display potential savings on each contract with current price vs reference price comparison  
**Routes:** `/contracts/:id/compare`

### SL 76: PM - Consolidated Savings View
**Brick:** 2  
**Description:** Consolidated view of savings by site, by contract family/subfamily, and by portfolio  
**Routes:** `/savings`

### SL 77: PM - Filter by Savings Potential
**Brick:** 2  
**Description:** Filter contracts by savings potential (high, medium, low) to prioritize renegotiation opportunities  
**Implementation:** Savings-based filtering

### SL 78: PM - Economic Analysis Report
**Brick:** 2  
**Description:** Export comprehensive economic analysis report in PDF format with savings breakdown, charts, and recommendations  
**Routes:** `/savings/report`

### SL 79: PM - Auto-Update on Reference Change
**Brick:** 2  
**Description:** Automatic recalculation of savings when reference database is modified or updated  
**Implementation:** Callback on price reference updates

---

## 📊 PM - ENHANCED DASHBOARD - BRICK 2 (SL 80-83)

### SL 80: PM - Total Savings Dashboard Widget
**Brick:** 2  
**Description:** Dashboard widget showing total potential savings by site and by portfolio with visual charts  
**Implementation:** Dashboard component with charts

### SL 81: PM - Active Alerts Widget
**Brick:** 2  
**Description:** Dashboard widget showing number of active alerts by type (upcoming, at-risk, missing) with quick actions  
**Implementation:** Dashboard alerts summary

### SL 82: PM - Expiring Contracts Widget
**Brick:** 2  
**Description:** Dashboard widget showing contracts expiring within 30/60/90 days with customizable thresholds  
**Implementation:** Dashboard expiration calendar

### SL 83: PM - At-Risk Contracts Widget
**Brick:** 2  
**Description:** Dashboard widget highlighting at-risk contracts requiring immediate action with priority sorting  
**Implementation:** Dashboard priority list

---

## 🏢 SITE MANAGER FEATURES - BRICK 2 (SL 84-86)

### SL 84: SM - View Site Savings
**Brick:** 2  
**Description:** Site Manager can view potential savings for contracts within their assigned sites (read-only)  
**Routes:** `/my_savings`

### SL 85: SM - Receive Site Alerts
**Brick:** 2  
**Description:** Receive email alerts concerning their assigned sites with configurable notification preferences  
**Implementation:** Email notifications filtered by site

### SL 86: SM - View Site Alerts Dashboard
**Brick:** 2  
**Description:** View alerts dashboard filtered to their assigned sites only (read-only, cannot acknowledge)  
**Routes:** `/my_alerts`

---

## ⚙️ SYSTEM FEATURES - BRICK 2 (SL 87-92)

### SL 87: System - Background Job Processing
**Brick:** 2  
**Description:** Background job system for automated tasks: alert generation, price comparisons, email notifications, data processing  
**Implementation:** Sidekiq/Solid Queue setup

### SL 88: System - Scheduled Tasks
**Brick:** 2  
**Description:** Daily scheduled tasks for checking contract deadlines, generating alerts, updating savings calculations  
**Implementation:** Recurring jobs with solid_queue

### SL 89: System - Email Service Integration
**Brick:** 2  
**Description:** Email service integration for sending automated notifications, alerts, and reports to users  
**Implementation:** Action Mailer configuration

### SL 90: System - Audit Trail
**Brick:** 2  
**Description:** Complete audit trail logging all user actions, data changes, alert acknowledgments, for compliance and tracking  
**Routes:** `/audit_trail`

### SL 91: System - Performance Optimization
**Brick:** 2  
**Description:** Optimize database queries, implement caching, indexes, and pagination for large datasets  
**Implementation:** Database optimization, caching layer

### SL 92: System - API Rate Limiting
**Brick:** 2  
**Description:** Implement rate limiting for external API calls (Mistral OCR, OpenRouter LLM) to control costs and prevent abuse  
**Implementation:** Rate limiter for API calls

---

## Quick Reference Index

**Authentication (1-7):** Sign up, login, password reset, email verification, profile, sessions, RBAC  
**Admin (8-10, 57-60):** User management, impersonation, price references  
**Asset Structure (13-18):** Sites, buildings, levels, spaces, equipment, tree navigation  
**Equipment DB (19-23):** Imports, search, OmniClass linking  
**Contracts (24-34):** Upload, OCR, LLM extraction, validation, manual entry, lists, filters  
**Organizations (35-39):** Companies, contacts, agencies, search, linking  
**Exports (40-43):** PDF summaries, Excel exports  
**Dashboards (44-46, 80-83):** Portfolio overview, analytics, widgets  
**Site Manager (47-51, 84-86):** View sites, contracts, equipment, savings, alerts  
**Auto-Matching (61-65):** Equipment, families, organizations, validation, learning  
**Alerts (66-72):** Upcoming, at-risk, missing, acknowledge, notifications, dashboard  
**Savings (73-79):** Price comparison, calculations, views, reports, auto-update  
**System (52-56, 87-92):** Isolation, responsive, branding, security, search, jobs, audit

---

