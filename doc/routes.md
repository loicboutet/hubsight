# Routes Documentation - HubSight Application

## Overview
This document describes all routes needed for the HubSight real estate portfolio management platform. Routes are organized by user journey and follow DRY and KISS principles. Only application routes are included (no marketing/presentation website).

---

## 🔐 1. AUTHENTICATION & COMMON ROUTES

All users must authenticate to access the application.

| Route | Method | Purpose | Access |
|-------|--------|---------|--------|
| `/login` | GET | Display login form | Public |
| `/login` | POST | Authenticate user | Public |
| `/logout` | DELETE | Sign out user | Authenticated |
| `/password/new` | GET | Request password reset | Public |
| `/password/edit` | GET | Reset password form | Public |
| `/password` | PATCH | Update password | Public |
| `/dashboard` | GET | Redirect to role-specific dashboard | Authenticated |

---

## 👤 2. ADMIN USER JOURNEY

**Role**: Super administrator (5000.dev)
**Focus**: Manage portfolio managers and access client data

### 2.1 Portfolio Managers Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/admin/portfolio_managers` | GET | List all portfolio managers |
| `/admin/portfolio_managers/new` | GET | New portfolio manager form |
| `/admin/portfolio_managers` | POST | Create portfolio manager |
| `/admin/portfolio_managers/:id` | GET | Show portfolio manager details |
| `/admin/portfolio_managers/:id/edit` | GET | Edit portfolio manager form |
| `/admin/portfolio_managers/:id` | PATCH | Update portfolio manager |
| `/admin/portfolio_managers/:id` | DELETE | Delete portfolio manager |

### 2.2 Client Data Access

| Route | Method | Purpose |
|-------|--------|---------|
| `/admin/clients` | GET | List all client portfolios |
| `/admin/clients/:id/impersonate` | POST | Switch to client view (with permission) |
| `/admin/stop_impersonation` | POST | Return to admin view |

### 2.3 Price Reference Management (BRIQUE 2)

| Route | Method | Purpose |
|-------|--------|---------|
| `/admin/price_references` | GET | List price references |
| `/admin/price_references/new` | GET | New price reference form |
| `/admin/price_references` | POST | Create price reference |
| `/admin/price_references/:id/edit` | GET | Edit price reference form |
| `/admin/price_references/:id` | PATCH | Update price reference |
| `/admin/price_references/:id` | DELETE | Delete price reference |
| `/admin/price_references/import` | GET | Import Excel form |
| `/admin/price_references/import` | POST | Process Excel import |
| `/admin/price_references/export` | GET | Export to Excel |

---

## 👑 3. PORTFOLIO MANAGER USER JOURNEY

**Role**: Main user managing entire portfolio
**Focus**: Complete portfolio and contract management

### 3.1 Dashboard & Overview

| Route | Method | Purpose |
|-------|--------|---------|
| `/` | GET | Portfolio manager dashboard |
| `/analytics` | GET | Analytics overview (BRIQUE 2) |

### 3.2 Sites Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/sites` | GET | List all sites in portfolio |
| `/sites/new` | GET | New site form |
| `/sites` | POST | Create site |
| `/sites/:id` | GET | Show site details & hierarchy |
| `/sites/:id/edit` | GET | Edit site form |
| `/sites/:id` | PATCH | Update site |
| `/sites/:id` | DELETE | Delete site |

### 3.3 Buildings Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/sites/:site_id/buildings` | GET | List buildings of a site |
| `/sites/:site_id/buildings/new` | GET | New building form |
| `/sites/:site_id/buildings` | POST | Create building |
| `/buildings/:id` | GET | Show building details |
| `/buildings/:id/edit` | GET | Edit building form |
| `/buildings/:id` | PATCH | Update building |
| `/buildings/:id` | DELETE | Delete building |

### 3.4 Levels Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/buildings/:building_id/levels` | GET | List levels of a building |
| `/buildings/:building_id/levels/new` | GET | New level form |
| `/buildings/:building_id/levels` | POST | Create level |
| `/levels/:id/edit` | GET | Edit level form |
| `/levels/:id` | PATCH | Update level |
| `/levels/:id` | DELETE | Delete level |

### 3.5 Spaces Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/levels/:level_id/spaces` | GET | List spaces of a level |
| `/levels/:level_id/spaces/new` | GET | New space form |
| `/levels/:level_id/spaces` | POST | Create space |
| `/spaces/:id` | GET | Show space details |
| `/spaces/:id/edit` | GET | Edit space form |
| `/spaces/:id` | PATCH | Update space |
| `/spaces/:id` | DELETE | Delete space |

### 3.6 Equipment Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/equipment` | GET | List all equipment (with filters) |
| `/spaces/:space_id/equipment/new` | GET | New equipment form |
| `/spaces/:space_id/equipment` | POST | Create equipment |
| `/equipment/:id` | GET | Show equipment details |
| `/equipment/:id/edit` | GET | Edit equipment form |
| `/equipment/:id` | PATCH | Update equipment |
| `/equipment/:id` | DELETE | Delete equipment |
| `/equipment/search` | GET | Search equipment (autocomplete) |

### 3.7 Contract Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/contracts` | GET | List all contracts (with filters) |
| `/contracts/new` | GET | New contract form (manual entry) |
| `/contracts` | POST | Create contract |
| `/contracts/:id` | GET | Show contract details |
| `/contracts/:id/edit` | GET | Edit contract form |
| `/contracts/:id` | PATCH | Update contract |
| `/contracts/:id` | DELETE | Delete contract |
| `/contracts/:id/pdf` | GET | Generate contract PDF summary |

### 3.8 Contract Upload & Extraction

| Route | Method | Purpose |
|-------|--------|---------|
| `/contracts/upload` | GET | Upload contract PDF form |
| `/contracts/upload` | POST | Upload & extract contract data |
| `/contracts/:id/validate` | GET | Validate extracted data form |
| `/contracts/:id/validate` | PATCH | Confirm validated data |

### 3.9 Organizations Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/organizations` | GET | List organizations |
| `/organizations/new` | GET | New organization form |
| `/organizations` | POST | Create organization |
| `/organizations/:id` | GET | Show organization details |
| `/organizations/:id/edit` | GET | Edit organization form |
| `/organizations/:id` | PATCH | Update organization |
| `/organizations/:id` | DELETE | Delete organization |
| `/organizations/search` | GET | Search organizations (autocomplete) |

### 3.10 Contacts Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/organizations/:organization_id/contacts` | GET | List contacts of an organization |
| `/organizations/:organization_id/contacts/new` | GET | New contact form |
| `/organizations/:organization_id/contacts` | POST | Create contact |
| `/contacts/:id` | GET | Show contact details |
| `/contacts/:id/edit` | GET | Edit contact form |
| `/contacts/:id` | PATCH | Update contact |
| `/contacts/:id` | DELETE | Delete contact |
| `/contacts/search` | GET | Search contacts (autocomplete) |

### 3.11 Site Managers Management

| Route | Method | Purpose |
|-------|--------|---------|
| `/site_managers` | GET | List all site managers |
| `/site_managers/new` | GET | New site manager form |
| `/site_managers` | POST | Create site manager |
| `/site_managers/:id` | GET | Show site manager details |
| `/site_managers/:id/edit` | GET | Edit site manager form |
| `/site_managers/:id` | PATCH | Update site manager |
| `/site_managers/:id` | DELETE | Delete site manager |
| `/site_managers/:id/assign_sites` | GET | Assign sites form |
| `/site_managers/:id/assign_sites` | PATCH | Update site assignments |

### 3.12 Alerts Management (BRIQUE 2)

| Route | Method | Purpose |
|-------|--------|---------|
| `/alerts` | GET | Dashboard of all alerts |
| `/alerts/:id` | GET | Show alert details |
| `/alerts/:id/acknowledge` | PATCH | Mark alert as acknowledged |
| `/alerts/settings` | GET | Alert settings form |
| `/alerts/settings` | PATCH | Update alert preferences |

### 3.13 Economic Analysis (BRIQUE 2)

| Route | Method | Purpose |
|-------|--------|---------|
| `/savings` | GET | View potential savings overview |
| `/savings/report` | GET | Generate savings report PDF |
| `/contracts/:id/compare` | GET | Compare contract with reference prices |

---

## 🏢 4. SITE MANAGER USER JOURNEY

**Role**: Limited user managing assigned sites only
**Focus**: View contracts and equipment for assigned sites

### 4.1 Dashboard & Overview

| Route | Method | Purpose |
|-------|--------|---------|
| `/` | GET | Site manager dashboard (assigned sites) |

### 4.2 Site & Portfolio (Read-only)

| Route | Method | Purpose |
|-------|--------|---------|
| `/my_sites` | GET | List assigned sites |
| `/my_sites/:id` | GET | Show site details & hierarchy |
| `/my_sites/:id/equipment` | GET | List equipment for assigned site |

### 4.3 Contract Management (Limited)

| Route | Method | Purpose |
|-------|--------|---------|
| `/my_contracts` | GET | List contracts for assigned sites |
| `/my_contracts/:id` | GET | Show contract details (read-only) |
| `/my_contracts/upload` | GET | Upload contract form |
| `/my_contracts/upload` | POST | Upload contract for assigned site |
| `/my_contracts/:id/pdf` | GET | Generate contract PDF summary |

### 4.4 Alerts (Read-only, BRIQUE 2)

| Route | Method | Purpose |
|-------|--------|---------|
| `/my_alerts` | GET | View alerts for assigned sites |

### 4.5 Savings (Read-only, BRIQUE 2)

| Route | Method | Purpose |
|-------|--------|---------|
| `/my_savings` | GET | View potential savings for assigned sites |

---

## 📊 5. SHARED RESOURCES & UTILITIES

These routes are accessible based on user role permissions.

### 5.1 Reference Data (Read-only for all)

| Route | Method | Purpose |
|-------|--------|---------|
| `/equipment_types` | GET | List equipment type catalog (OmniClass) |
| `/equipment_types/search` | GET | Search equipment types (autocomplete) |
| `/contract_families` | GET | List contract families & subfamilies |
| `/contract_families/search` | GET | Search contract families (autocomplete) |

### 5.2 Imports (Portfolio Manager & Admin)

| Route | Method | Purpose |
|-------|--------|---------|
| `/imports/equipment_types` | POST | Import OmniClass Excel |
| `/imports/spaces` | POST | Import spaces structure Excel |
| `/imports/contract_families` | POST | Import contract families Excel |

### 5.3 Exports (Based on permissions)

| Route | Method | Purpose |
|-------|--------|---------|
| `/exports/contracts` | GET | Export contracts to Excel/CSV |
| `/exports/equipment` | GET | Export equipment to Excel/CSV |
| `/exports/sites` | GET | Export site structure to Excel/CSV |

---

## 🔍 6. SEARCH & FILTERING

Universal search endpoints used throughout the application.

| Route | Method | Purpose |
|-------|--------|---------|
| `/search` | GET | Global search across all entities |
| `/search/contracts` | GET | Search contracts with filters |
| `/search/equipment` | GET | Search equipment with filters |
| `/search/sites` | GET | Search sites with filters |
| `/search/organizations` | GET | Search organizations with filters |

---

## 📱 7. API ENDPOINTS (for AJAX/SPA features)

These routes support dynamic frontend interactions.

| Route | Method | Purpose |
|-------|--------|---------|
| `/api/sites/:id/hierarchy` | GET | Get full site hierarchy (JSON) |
| `/api/contracts/:id/linked_equipment` | GET | Get equipment linked to contract |
| `/api/equipment/:id/contracts` | GET | Get contracts linked to equipment |
| `/api/autocomplete/equipment_types` | GET | Autocomplete for equipment types |
| `/api/autocomplete/organizations` | GET | Autocomplete for organizations |
| `/api/autocomplete/contacts` | GET | Autocomplete for contacts |
| `/api/alerts/count` | GET | Get unacknowledged alerts count |

---

## 🎯 ROUTE ORGANIZATION PRINCIPLES

### 1. RESTful Convention
All routes follow standard REST conventions:
- `GET /resources` - Index/List
- `GET /resources/new` - New form
- `POST /resources` - Create
- `GET /resources/:id` - Show
- `GET /resources/:id/edit` - Edit form
- `PATCH /resources/:id` - Update
- `DELETE /resources/:id` - Delete

### 2. Nested Resources
Resources are nested when there's a strong parent-child relationship:
- Buildings belong to sites: `/sites/:site_id/buildings`
- Contacts belong to organizations: `/organizations/:organization_id/contacts`

### 3. Role-Based Namespacing
- `/admin/*` - Admin-only routes
- `/my_*` - Site manager scoped routes
- Root level - Portfolio manager routes

### 4. Action Routes
Special actions use descriptive names:
- `/:id/validate` - Validation workflows
- `/:id/acknowledge` - Acknowledgment actions
- `/:id/pdf` - PDF generation
- `/import` - Import workflows
- `/export` - Export workflows

### 5. Search & Autocomplete
- `/search` - Complex search interfaces
- `/search/:resource` - Resource-specific search
- `/api/autocomplete/:resource` - Autocomplete endpoints

---

## 📋 IMPLEMENTATION NOTES

### Authorization Strategy
Routes are protected by:
1. Authentication (all routes except login/password)
2. Role-based access (Admin, Portfolio Manager, Site Manager)
3. Scope-based access (Site Managers see only assigned sites)

### DRY Principles Applied
- Shared partials for common forms (site, building, equipment)
- Unified search infrastructure
- Common authorization policies
- Reusable autocomplete endpoints

### KISS Principles Applied
- Simple RESTful patterns
- Clear naming conventions
- Minimal route nesting (max 2 levels)
- Predictable URL structure

### Future Considerations
Routes excluded from scope but may be added later:
- External contractor portal routes
- Intervention request routes
- Insurance claims routes
- Investment planning routes
- Electronic signature workflows
- Mobile app API routes

---

## 🚀 ROUTE COUNT BY USER ROLE

| User Role | Accessible Routes | Key Features |
|-----------|------------------|--------------|
| **Admin** | ~30 routes | Portfolio manager management, price references, client access |
| **Portfolio Manager** | ~100 routes | Full CRUD on all resources, alerts, analytics, imports |
| **Site Manager** | ~15 routes | Read contracts/equipment, upload contracts for assigned sites |

**Total Application Routes**: ~120 routes

---

**Last Updated**: January 2025
**Version**: 1.0 (BRIQUE 1 & BRIQUE 2)
