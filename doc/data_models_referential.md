# Complete Documentation - Real Estate Portfolio Structure Excel Files

---

## 📋 TABLE OF CONTENTS

1. [System Overview](#system-overview)
2. [Equipements.xlsx](#equipments)
3. [Espaces.xlsx](#spaces)
4. [Organisations.xlsx](#organizations)
5. [Administration.xlsx](#administration)
6. [Contrats.xlsx](#contracts)
7. [Object Relationships](#relationships)

---

## 🏗️ SYSTEM OVERVIEW {#system-overview}

**System**: Computerized Maintenance Management System (CMMS) / Computer-Aided Facility Management (CAFM)

**Data Architecture**:
```
SITE (Spaces)
  └─ BUILDING (Spaces)
      └─ LEVEL (Spaces)
          └─ SPACE (Spaces)
              └─ EQUIPMENT (Equipments)
                  └─ CONTRACT (Contracts)
                      └─ ORGANIZATION (Organizations)
```

---

## 🔧 1. EQUIPEMENTS.XLSX {#equipments}

**Purpose**: Central repository of all technical equipment in the portfolio

### Sheet 1: "Donnée équipement base" (Base Equipment Data)
**Objective**: List of mandatory fields to create an equipment

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Equipement | Text | List of data fields to collect |

**34 required fields** (examples):
- Equipment name
- Equipment BDD ID
- Equipment BDD type
- Purchase subdomain BDD Equipment
- Equipment manufacturer (Brand)
- Equipment model
- Serial number
- Manufacturing date
- Commissioning date
- Warranty date
- Location (Site/Building/Level/Space)
- Nominal power
- Nominal voltage
- etc.

**Created Object**: `BASE_EQUIPMENT`

---

### Sheet 2: "Donnée équipement secondaire" (Secondary Equipment Data)
**Objective**: Optional/complementary fields to enrich equipment record

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Equipement | Text | List of optional fields |

**31 optional fields** (examples):
- Equipment photos
- Supplier-distributor
- Does the equipment generate data: yes/no
- Which BMS is the equipment connected to?
- Communication protocol
- Technical documentation
- Maintenance plan
- Intervention history
- etc.

**Created Object**: `ENRICHED_EQUIPMENT`

---

### Sheet 3: "Liste Equipements" (Equipment List) ⭐
**Objective**: Catalog of 256 standardized equipment types with classification

| # | Column | Type | Unique Values | Description |
|---|---------|------|---------------|-------------|
| 1 | ID | Integer | 256 | Unique equipment type identifier |
| 2 | Trigramme Lot technique | Text | 9 | Technical lot short code (CEA, CVC, ELE, etc.) |
| 3 | Lot technique | Text | 8 | Full technical lot name |
| 4 | Sous famille achats | Text | 20 | Purchase category (JOINERY, ELEVATORS, etc.) |
| 5 | Fonction | Text | 50+ | Equipment function |
| 6 | Type d'Équipement | Text | 200+ | Precise equipment type |
| 7 | Trigramme équipement | Text | 200+ | Equipment short code |
| 8 | Numéro Omniclass | Text | 200+ | International BIM classification code |
| 9 | Titre OmniClass | Text | 200+ | OmniClass label |
| 10-19 | Nom de la caractéristique 1-10 | Text | Variable | Specific technical characteristics |

**Examples of technical lots** (9 trigrams):
- **CEA**: Architectural Trades (Corps d'État Architecturaux)
- **CVC**: HVAC (Heating, Ventilation, Air Conditioning)
- **ELE**: Electricity
- **PLO**: Plumbing
- **SEC**: Security/Emergency Systems
- **ASC**: Elevators
- **CTE**: Technical Control
- etc.

**Examples of purchase subfamilies** (20):
- EXTERIOR JOINERY
- ELEVATORS AND AUTOMATION
- HVAC
- ELECTRICITY
- PLUMBING
- EMERGENCY SYSTEMS
- etc.

**Created Object**: `EQUIPMENT_TYPE` (catalog)

**Link**: `EQUIPMENT.equipment_type_id → EQUIPMENT_TYPE.ID`

---

### Sheet 4: "Feuil1"
**Objective**: Unstructured raw data (61 rows × 32 columns without headers)

⚠️ To be restructured or ignored

---

## 🏢 2. ESPACES.XLSX {#spaces}

**Purpose**: Hierarchically structure the real estate portfolio

### Sheet 1: "Site" 🌍
**Objective**: Level 1 of hierarchy - The geographic site

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Site | Text | Data field name |
| 2 | Commentaires | Text | Field explanation |
| 3 | Exemple | Text | Value example |

**8 fields for a SITE**:
1. Site name
2. Complete address
3. Postal code
4. City
5. Department
6. Region
7. Total area (m²)
8. Site type (Offices, Industrial, Commercial, etc.)

**Created Object**: `SITE`

---

### Sheet 2: "Batiment" (Building) 🏛️
**Objective**: Level 2 - Buildings of a site

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Batiment | Text | Field name |
| 2 | Commentaires | Text | Explanation |
| 3 | Exemple | Text | Example |

**17 fields for a BUILDING**:
1. Building name
2. Cadastral reference
3. Construction year
4. Renovation year
5. Floor area (m²)
6. Number of levels
7. Height (m)
8. Structure type (Concrete, Metal, etc.)
9. ERP classification (category + type)
10. Reception capacity
11. PRM accessibility (People with Reduced Mobility)
12. Environmental certification (HQE, BREEAM, etc.)
13. Energy consumption (kWh/m²/year)
14. EPC (Energy Performance Certificate)
15. GHG (Greenhouse Gas)
16. etc.

**Created Object**: `BUILDING`

**Link**: `BUILDING.site_id → SITE.id`

---

### Sheet 3: "Niveau" (Level) 📐
**Objective**: Level 3 - Floors of a building

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Niveau | Text | Field name |
| 2 | Commentaires | Text | Explanation |
| 3 | Exemple | Text | Example |

**3 fields for a LEVEL**:
1. Level number/name (Ground floor, Floor 1, Basement 1, etc.)
2. Altitude relative to ground (m)
3. Level floor area (m²)

**Created Object**: `LEVEL`

**Link**: `LEVEL.building_id → BUILDING.id`

---

### Sheet 4: "Espace" (Space) 🚪
**Objective**: Level 4 - Spaces/rooms of a level

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Espace | Text | Field name |
| 2 | Commentaires | Text | Explanation |
| 3 | Exemple | Text | Example |

**23 fields for a SPACE**:
1. Space name/number
2. Space type (Office, Meeting room, Technical room, etc.)
3. Area (m²)
4. Ceiling height (m)
5. Reception capacity (people)
6. Primary use
7. Secondary use
8. PRM accessibility
9. Window presence (yes/no)
10. Floor covering type
11. Wall covering type
12. Ceiling type
13. Present equipment
14. Water points
15. Electrical outlets
16. Network connectivity
17. Natural lighting (%)
18. Ventilation (natural/mechanical)
19. Heating (yes/no)
20. Air conditioning (yes/no)
21. etc.

**Created Object**: `SPACE`

**Link**: `SPACE.level_id → LEVEL.id`

---

### Sheet 5: "Zone de regroupement d'espace" (Space Grouping Zone)
**Objective**: Logical groupings of spaces (by commercial use)

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | Zone/regroupement lot commercial | Text | Zone name |

**5 zones**:
- Administrative zone
- Technical zone
- Commercial zone
- Circulation zone
- Storage zone

**Created Object**: `GROUPING_ZONE`

**Link**: `SPACE.zone_id → GROUPING_ZONE.id`

---

### Sheet 6: "Catégorie ERP" (ERP Category)
**Objective**: French regulatory classification of Public Reception Establishments

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | Type | Text | Letter (J, L, M, etc.) |
| 2 | Description | Text | Category label |

**17 ERP categories** (examples):
- **J**: Reception facilities for elderly and disabled people
- **L**: Auditoriums, conference halls, meeting rooms, etc.
- **M**: Retail stores, shopping centers
- **N**: Restaurants and bars
- **O**: Hotels and guest houses
- **P**: Dance halls and gaming rooms
- **R**: Early childhood, education, training establishments
- **S**: Libraries, documentation centers
- **T**: Exhibition halls
- **U**: Healthcare facilities
- **V**: Places of worship
- **W**: Administrations, banks, offices
- **X**: Indoor sports facilities
- **Y**: Museums
- etc.

**Created Object**: `ERP_CATEGORY`

**Link**: `BUILDING.erp_category_id → ERP_CATEGORY.type`

---

### Sheet 7: "Structure AICN"
**Objective**: Specific AICN structure (Asset Information Classification Number)

⚠️ **Empty sheet** - To be completed

---

### Sheet 8: "OmniClass Table 13" 📊
**Objective**: International space classification reference (BIM)

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | TITLE | Text | Classification title |
| 2 | OmniClass Table 13 | Text | OmniClass code |
| 3-4 | Unnamed | Text | Additional data |

**966 space classifications** according to OmniClass Table 13 standard

**Examples**:
- 13-11 11 11: Outdoor Spaces
- 13-21 00 00: Building Spaces
- 13-21 11 00: Office Spaces
- 13-21 21 00: Conference Spaces
- 13-21 31 00: Educational Spaces
- etc.

**Created Object**: `OMNICLASS_SPACE` (reference)

**Link**: `SPACE.omniclass_code → OMNICLASS_SPACE.code`

---

## 🏢 3. ORGANISATIONS.XLSX {#organizations}

**Purpose**: Manage companies, agencies and contacts related to the portfolio

### Sheet 1: "Organisations"
**Objective**: List of companies/organizations

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Organisation | Text | List of data fields |

**12 fields for an ORGANIZATION**:
1. Organization name
2. Legal name
3. SIRET (French company ID)
4. Organization type (Supplier, Service provider, Tenant, etc.)
5. Headquarters address
6. Phone
7. Email
8. Website
9. Specialties/Trades
10. Relationship start date
11. Status (Active/Inactive)
12. Notes

**Created Object**: `ORGANIZATION`

---

### Sheet 2: "Contacts"
**Objective**: Individuals linked to organizations

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Contact | Text | Field name |
| 2 | Unnamed | Text | Description/value |

**11 fields for a CONTACT**:
1. Last name
2. First name
3. Position/Job title
4. Affiliated organization
5. Office phone
6. Mobile phone
7. Email
8. Secondary email
9. Availability
10. Languages spoken
11. Notes

**Created Object**: `CONTACT`

**Link**: `CONTACT.organization_id → ORGANIZATION.id`

---

### Sheet 3: "Agence" (Agency)
**Objective**: Establishments/agencies of an organization

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | ID Agence ou établissement | Text | Field name |

**11 fields for an AGENCY**:
1. Agency name
2. Parent organization
3. Address
4. Postal code
5. City
6. Region
7. Phone
8. Email
9. Geographic service area
10. Staff size
11. Certifications

**Created Object**: `AGENCY`

**Link**: `AGENCY.organization_id → ORGANIZATION.id`

---

## 👥 4. ADMINISTRATION.XLSX {#administration}

**Purpose**: Manage access rights and user profiles of the platform

### Sheet 1: "Fonctions" (Functions)
**Objective**: List of job functions

⚠️ **Empty sheet** - To be defined

---

### Sheet 2: "Profils utilisateurs" (User Profiles) 🔐
**Objective**: Rights matrix by profile

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | Fonctions | Text | Profile name |
| 2 | Ajouts/modifications de gestionnaire de portefeuille | Text | Right (YES/NO) |
| 3 | Ajouts/modification de sites | Text | Right (YES/NO) |
| 4 | Ajout/modification resp de site | Text | Right (YES/NO) |
| 5 | Ajout/modification de bâtiments | Text | Right (YES/NO) |
| 6 | Ajout/modification d'équipements | Text | Right (YES/NO) |
| 7 | Ajout/modification de contrats | Text | Right (YES/NO) |

**4 defined profiles**:

1. **Administrator** (Super-user)
   - Portfolio manager: YES
   - Sites: YES
   - Site manager: YES
   - Buildings: YES
   - Equipment: YES
   - Contracts: YES

2. **Portfolio Manager**
   - Portfolio manager: NO
   - Sites: YES
   - Site manager: YES
   - Buildings: YES
   - Equipment: YES
   - Contracts: YES

3. **Site Manager**
   - Portfolio manager: NO
   - Sites: NO
   - Site manager: NO
   - Buildings: YES
   - Equipment: YES
   - Contracts: VIEW ONLY

4. **Technician**
   - Portfolio manager: NO
   - Sites: NO
   - Site manager: NO
   - Buildings: VIEW ONLY
   - Equipment: YES
   - Contracts: VIEW ONLY

**Created Object**: `USER_PROFILE`

**Link**: `USER.profile_id → USER_PROFILE.id`

---

## 📄 5. CONTRATS.XLSX {#contracts}

**Purpose**: Repository of maintenance contracts, services and purchases

### Sheet 1: "Contrats" (Contracts)
**Objective**: Contract data structure

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | Unnamed | Text | Line number |
| 2 | Données | Text | Field name |
| 3 | Commentaires | Text | Explanation |
| 4 | Exemple | Text | Value example |

**72 fields for a CONTRACT**:

**Identification** (1-10):
1. Contract number
2. Contract title
3. Contract type
4. Purchase family
5. Purchase subfamily
6. Contract object
7. Detailed description
8. Status (Active, Terminated, In progress, etc.)
9. Contracting method (Tender, Direct agreement, etc.)
10. Public contract reference

**Stakeholders** (11-20):
11. Contractor organization (service provider)
12. Main contractor contact
13. Contractor agency
14. Client organization
15. Main client contact
16. Internal managing department
17. Contract monitoring manager
18. etc.

**Scope** (21-35):
21. Covered sites
22. Covered buildings
23. Covered equipment
24. Type of concerned equipment
25. Number of equipment
26. Geographic areas
27. etc.

**Financial aspects** (36-50):
36. Annual amount excl. tax
37. Annual amount incl. tax
38. Billing method (Fixed price, Time & materials, Mixed)
39. Billing frequency
40. Price revision conditions
41. Revision index
42. Late payment penalties
43. Financial guarantee
44. etc.

**Temporality** (51-60):
51. Signature date
52. Execution start date
53. End date
54. Initial duration (months)
55. Renewal duration (months)
56. Number of possible renewals
57. Automatic renewal (YES/NO)
58. Termination notice period (days)
59. Next deadline date
60. etc.

**Services & SLA** (61-72):
61. Nature of services
62. Intervention frequency
63. Intervention delay (hours)
64. Resolution delay (hours)
65. Working days / Intervention hours
66. 24/7 on-call (YES/NO)
67. Guaranteed service level (%)
68. Performance indicators (KPI)
69. Spare parts included (YES/NO)
70. Supplies included (YES/NO)
71. Mandatory intervention report (YES/NO)
72. Appendix documents

**Created Object**: `CONTRACT`

**Multiple links**:
- `CONTRACT.organization_id → ORGANIZATION.id`
- `CONTRACT.site_id → SITE.id` (can be multiple)
- `CONTRACT.building_id → BUILDING.id` (can be multiple)
- `CONTRACT.equipment_id → EQUIPMENT.id` (can be multiple)
- `CONTRACT.equipment_type_id → EQUIPMENT_TYPE.id`

---

### Sheet 2: "Famille achats" (Purchase Families)
**Objective**: Contract taxonomy by purchase family

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1-7 | Family name | Text | List of subfamilies |

**7 purchase families**:

1. **MAINTENANCE** (preventive and corrective maintenance)
   - Elevators
   - HVAC (Heating, Ventilation, Air Conditioning)
   - Plumbing
   - Electricity
   - Joinery
   - Facades
   - Roofing
   - etc.

2. **CLEANING AND HYGIENE**
   - Premises cleaning
   - Landscaping
   - Pest control
   - Waste management
   - Window cleaning
   - etc.

3. **TECHNICAL AND BIOLOGICAL CONTROL**
   - Periodic regulatory inspections
   - Electrical testing
   - Lifting equipment testing
   - Fire safety inspections
   - Legionella testing
   - Indoor air quality analysis
   - etc.

4. **UTILITIES**
   - Electricity
   - Gas
   - Drinking water
   - Chilled water
   - Fuel oil
   - etc.

5. **INSURANCE**
   - Multi-risk building insurance
   - Liability insurance
   - Property damage
   - Business interruption
   - etc.

6. **REAL ESTATE**
   - Condominium management
   - Rental management
   - Property administration
   - Property taxes
   - etc.

7. **OTHER CONTRACTS**
   - Security/Guarding
   - Telephony
   - Internet
   - Parking management
   - etc.

**Created Object**: `PURCHASE_FAMILY` + `PURCHASE_SUBFAMILY`

**Link**: `CONTRACT.purchase_family_id → PURCHASE_FAMILY.id`

---

### Sheet 3: "LISTE CONTRAT TYPE" (Contract Type List) ⭐
**Objective**: Catalog of 339 pre-configured contract types

| # | Column | Type | Description |
|---|---------|------|-------------|
| 1 | Unnamed | Integer | Line number |
| 2 | SITE | Text | Applicable site type |
| 3 | PRESTATION | Text | Nature of service |
| 4 | TYPE D'EQUIPEMENTS | Text | Concerned equipment |
| 5-18 | Additional columns | Text | Contract type characteristics |

**339 pre-established contract templates** covering:
- All site types (Offices, Industrial, Commercial, Residential, etc.)
- All services (Maintenance, Cleaning, Inspections, etc.)
- All technical equipment

**Examples**:
- Preventive elevator maintenance (175-point contract)
- HVAC maintenance with 24/7 on-call
- Mandatory annual electrical inspection
- Office cleaning 3x/week
- Automatic door maintenance
- Annual fire extinguisher inspection
- etc.

**Created Object**: `CONTRACT_TYPE` (template)

**Usage**: Basis for quickly creating a new contract

**Link**: `CONTRACT.contract_type_id → CONTRACT_TYPE.id` (optional)

---

## 🔗 OBJECT RELATIONSHIPS {#relationships}

### Space Hierarchy (1-to-many cascade)
```
SITE (1)
  └─ has multiple ─> BUILDING (N)
                      └─ has multiple ─> LEVEL (N)
                                          └─ has multiple ─> SPACE (N)
                                                              └─ contains multiple ─> EQUIPMENT (N)
```

### Contract Relationships
```
CONTRACT (1)
  ├─ is managed by ─> ORGANIZATION (1) [service provider]
  ├─ has a contact ─> CONTACT (1) [contact person]
  ├─ covers ─> SITE (N) [geographic scope]
  ├─ covers ─> BUILDING (N) [building scope]
  ├─ covers ─> EQUIPMENT (N) [technical scope]
  └─ is of type ─> CONTRACT_TYPE (1) [optional template]
```

### Organization Relationships
```
ORGANIZATION (1)
  ├─ has multiple ─> AGENCY (N)
  ├─ has multiple ─> CONTACT (N)
  └─ has multiple ─> CONTRACT (N) [as service provider]
```

### Equipment Relationships
```
EQUIPMENT (1)
  ├─ is of type ─> EQUIPMENT_TYPE (1) [catalog]
  ├─ is located in ─> SPACE (1)
  ├─ belongs to technical lot ─> TECHNICAL_LOT (1)
  ├─ belongs to subfamily ─> PURCHASE_SUBFAMILY (1)
  ├─ is classified by ─> OMNICLASS (1) [optional]
  └─ is covered by ─> CONTRACT (N) [maintenance]
```

### Administration Relationships
```
USER (1)
  ├─ has a profile ─> USER_PROFILE (1)
  ├─ manages ─> SITE (N) [according to rights]
  ├─ manages ─> BUILDING (N) [according to rights]
  └─ manages ─> CONTRACT (N) [according to rights]
```

---

## 📊 COMPLETE DATA MODEL

### Main Entities

1. **SITE**
   - Primary key: `id`
   - Attributes: name, address, area, type, etc.

2. **BUILDING**
   - Primary key: `id`
   - Foreign key: `site_id → SITE.id`
   - Attributes: name, construction_year, area, nb_levels, erp_category, etc.

3. **LEVEL**
   - Primary key: `id`
   - Foreign key: `building_id → BUILDING.id`
   - Attributes: number, altitude, area, etc.

4. **SPACE**
   - Primary key: `id`
   - Foreign key: `level_id → LEVEL.id`
   - Foreign key: `zone_id → GROUPING_ZONE.id`
   - Foreign key: `omniclass_code → OMNICLASS_SPACE.code`
   - Attributes: name, type, area, capacity, usage, etc.

5. **EQUIPMENT**
   - Primary key: `id`
   - Foreign key: `space_id → SPACE.id`
   - Foreign key: `equipment_type_id → EQUIPMENT_TYPE.id`
   - Attributes: name, manufacturer, model, serial_number, commissioning_date, etc.

6. **EQUIPMENT_TYPE** (catalog)
   - Primary key: `id`
   - Attributes: lot_trigram, technical_lot, subfamily, function, omniclass, etc.

7. **CONTRACT**
   - Primary key: `id`
   - Foreign key: `organization_id → ORGANIZATION.id`
   - Foreign key: `contact_id → CONTACT.id`
   - Foreign key: `contract_type_id → CONTRACT_TYPE.id` (optional)
   - Attributes: number, title, type, amount, start_date, end_date, etc.

8. **ORGANIZATION**
   - Primary key: `id`
   - Attributes: name, siret, type, address, etc.

9. **CONTACT**
   - Primary key: `id`
   - Foreign key: `organization_id → ORGANIZATION.id`
   - Attributes: last_name, first_name, position, phone, email, etc.

10. **AGENCY**
    - Primary key: `id`
    - Foreign key: `organization_id → ORGANIZATION.id`
    - Attributes: name, address, service_area, etc.

11. **USER**
    - Primary key: `id`
    - Foreign key: `profile_id → USER_PROFILE.id`
    - Attributes: last_name, first_name, email, login, etc.

12. **USER_PROFILE**
    - Primary key: `id`
    - Attributes: name, manager_right, site_right, building_right, etc.

### Junction Tables (many-to-many)

1. **CONTRACT_SITE**
   - `contract_id → CONTRACT.id`
   - `site_id → SITE.id`

2. **CONTRACT_BUILDING**
   - `contract_id → CONTRACT.id`
   - `building_id → BUILDING.id`

3. **CONTRACT_EQUIPMENT**
   - `contract_id → CONTRACT.id`
   - `equipment_id → EQUIPMENT.id`

### Reference Tables (lookup tables)

1. **PURCHASE_FAMILY** (7 families)
2. **PURCHASE_SUBFAMILY** (20+ subfamilies)
3. **TECHNICAL_LOT** (9 lots)
4. **ERP_CATEGORY** (17 categories)
5. **GROUPING_ZONE** (5 zones)
6. **OMNICLASS_SPACE** (966 classifications)
7. **CONTRACT_TYPE** (339 templates)

---

## 🎯 PRACTICAL USE CASES

### Scenario 1: Create a new site
1. Create `SITE` with its attributes
2. Create N `BUILDING` linked to the site
3. For each building, create N `LEVEL`
4. For each level, create N `SPACE`
5. For each space, create N `EQUIPMENT`
6. Link equipment to `EQUIPMENT_TYPE` from catalog

### Scenario 2: Add a maintenance contract
1. Select `ORGANIZATION` (or create if new provider)
2. Select `CONTACT` (or create)
3. Choose appropriate `CONTRACT_TYPE` (optional)
4. Create `CONTRACT` with all fields
5. Link to concerned `SITE`, `BUILDING`, or `EQUIPMENT`
6. Define SLA and conditions

### Scenario 3: Manage user rights
1. Create `USER_PROFILE` if necessary
2. Create `USER`
3. Assign profile with rights matrix
4. User sees only authorized sites/buildings

---

**END OF DOCUMENTATION**

*Analyzed files*:
- ✅ Equipements.xlsx
- ✅ Espaces.xlsx
- ✅ Organisations.xlsx
- ✅ Administration.xlsx
- ✅ Contrats.xlsx