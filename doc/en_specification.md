2.1 General Project Description
The project consists of developing a web platform for contractual management and monitoring
oriented towards real estate and technical management. The solution allows centralization of
maintenance contracts, upkeep, technical and biological control, subcontracting, supply,
insurance, and real estate (property deeds, leases, condominium regulations) in a
data structure organized by real estate portfolio (sites, buildings, equipment).
The objective is to drastically simplify data entry through automatic extraction
of information from contractual documents (OCR + AI), then enable management
of contractual deadlines with an alert system and visualization of potential
savings through comparison with a price reference database.
The project will be developed in two successive modules allowing for progressive
production deployment and user testing between each step.

2.2 BRICK 1 - Basic Contract Management (€5000)
Features by User Type
👤 Admin (5000.dev)
● I can create and configure "Portfolio Manager" accounts
● I can access client data (with formalized contractual authorization)

👑 Portfolio Manager
● I can create and manage "Site Manager" profiles for my organization
● I can assign sites to site managers
● I can create and manage my asset structure (sites, buildings, equipment)
● I can upload PDF contracts and validate automatic data extraction
● I can manually create/modify contracts if no document exists or if
extraction is incomplete
● I can manually enter and associate the correspondence between equipment and
OmniClass classification codes provided:
● I can manually enter and associate the correspondence between services and
Contract Family / Contract Sub-Family
● I can manually enter and associate the correspondence between the
signing organization and the organizations (third parties) present in the database
● I can view my contracts in list form with filters (site, family,
service provider, status)
● I can visualize my sites, buildings, and equipment in a structured
tree view
● I can view and manage organizations and their contacts
● I can generate and export summary sheets with essential information per contract
in PDF format

🏢 Site Manager
● I can view contracts related to my assigned site(s)
● I can upload contracts for my scope
● I can view the list of equipment for my site
● I can generate and export contract summary sheets for my site in
PDF format

System Features Brick 1
Asset Structure:
● Hierarchical structure: Portfolio > Sites > Buildings > Equipment
● Import of OmniClass Table 23 classification (equipment) via Excel file provided
by the Client
● Import of space structure via Excel file provided by the Client
● Import of contract families and sub-families via Excel file provided by the Client
● Search and autocomplete system in the equipment database to facilitate
manual entry
● Search and autocomplete system in the contract family and purchase sub-family
database to facilitate manual entry
● Search and autocomplete system in the Organizations and contacts
databases to facilitate manual entry
● Linking between equipment, Organizations (third parties), contracts, contract family and sub-family

Contract Extraction and Management:
● Upload of PDF documents (multi-page)
● Text extraction via Mistral OCR
● Automatic data structuring via LLM (OpenRouter): contract number,
dates, contract type, service provider, durations, renewal type, equipment list,
concerned site, essential information, amounts (according to file provided
by the client)
● Manual validation interface for extracted data
● Manual contract creation if document is absent or non-extractable
● Manual linking of equipment to OmniClass codes via search system
● Manual linking of contract family and purchase sub-family databases via search
system
● Manual linking of Organizations and contacts databases via search
system
● Automatic calculation of contract last renewal date, contract expiry
date, termination deadline, last contract amount update date, and VAT inclusive amounts (according to file provided by the client)

Visualization:
● Contract list with multiple filters
● Tree navigation of the portfolio
● Generation of PDF summary sheets per contract (emergency number, references,
equipment, according to files provided by the client)
● Dashboard with portfolio overview and key indicators

Security:
● Secure authentication with management of three user profiles
● Complete data isolation between clients
● Hosting in France, HTTPS connection

External Services and Hosting:
● Mistral OCR for text extraction (external API, approximate usage cost
€0.10/contract, charged to the Client)
● OpenRouter for LLM processing (usage cost included)
● Responsive web interface (Web App)
● Clean design with Client's graphic charter (logo and colors provided)
● Secure hosting France: €50/month (separate contract, direct billing to
Client)

2.3 BRICK 2 - Automatic Matching & Price Comparison (€5000)
Features by User Type
👤 Admin (5000.dev)
● I can manage the price reference database via administration interface
● I can create/modify price references by equipment type and service
● I can import Excel files of price references

👑 Portfolio Manager
● I can see potential savings automatically calculated per contract
● I can view the comparison between current price and reference price
● I can filter my contracts by savings potential
● I can view the contractual alerts dashboard
● I can manually validate alerts (mark as "acknowledged")
● I can export an economic analysis report in PDF format
● I can configure my email notifications

🏢 Site Manager
● I can view the potential savings for my site
● I can receive alerts concerning my site

System Features Brick 2
Automatic Database Matching Contract Family and Sub-Family / Equipment / Organizations:
● Automatic matching system between extracted equipment and Equipment Database
via LLM
● Search and autocomplete system in the Contract Family and Sub-Family
database to facilitate manual entry
● Search and autocomplete system in the Organizations and contacts
databases to facilitate manual entry
● Suggestions with confidence score
● Validation/correction interface for suggestions
● Progressive learning from user corrections

Complete Alert System: (According to file provided by the client)
● "Upcoming" alerts: X days before termination deadline (configurable delay)
● "At risk" alerts: deadline passed without action
● "Missing contracts" alerts: mandatory contracts not referenced for a
site type
● Manual validation of alerts by user with history
● Automatic email notifications for critical alerts (configurable)

Price Reference Database and Economic Comparison:
● Administration interface for the reference database with creation of references by contract family and
sub-family and by equipment
● Structure by contract family and sub-family type and by equipment
technical characteristics, service type, location (according to file provided by the
client)
● Excel import/export of the reference database
● Automatic comparison between contractual price and reference price
● Calculation of potential savings in absolute value and percentage
● Automatic update when reference database is modified
● Display of savings on each contract with consolidated view by site and contract family
and sub-family
● Export economic analysis report in PDF format

Enhanced Dashboard:
● Total potential savings by site / by portfolio
● Number of active alerts by type
● Contracts expiring within 30/60/90 days
● At-risk contracts requiring immediate action

2.4 Elements Explicitly Excluded from the Scope of the 2 Modules
The following elements are explicitly excluded from the contractual scope and may be
subject to future development modules:
● "External Service Provider" profile with platform access
● Intervention request management
● Claims and insurance declarations management
● Action plans with task tracking
● Investment plans and equipment expected lifespan
● Contract validation workflow and electronic signature
● Native mobile application (iOS/Android)
● API connections with third-party software (accounting, asset management)
● Alerts on service providers' financial health
● Site-based limitation system with pricing tiers

This feature list constitutes the contractual scope of the developments to be
completed.
