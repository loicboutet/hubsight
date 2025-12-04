# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Load equipment types
require_relative 'seeds/equipment_types'

# Load OmniClass space classifications
require_relative 'seeds/omniclass_spaces'

# Load contract families
require_relative 'seeds/contract_families'

puts "🌱 Starting seed process..."

# ============================================================================
# ORGANIZATIONS - Create organizations first
# ============================================================================

puts "\n🏢 Creating organizations..."

# Organization 1
org1 = Organization.find_or_initialize_by(name: 'Immobilière Centrale')
org1.assign_attributes(
  organization_type: 'owner',
  status: 'active'
)
if org1.new_record?
  org1.save!
  puts "  ✓ Created organization: #{org1.name}"
else
  org1.save!
  puts "  ✓ Updated organization: #{org1.name}"
end

# Organization 2
org2 = Organization.find_or_initialize_by(name: 'Patrimoine & Gestion')
org2.assign_attributes(
  organization_type: 'owner',
  status: 'active'
)
if org2.new_record?
  org2.save!
  puts "  ✓ Created organization: #{org2.name}"
else
  org2.save!
  puts "  ✓ Updated organization: #{org2.name}"
end

# ============================================================================
# USERS - Test users for each role
# ============================================================================

puts "\n👤 Creating test users..."

# Strong password for all users (meets requirements: 8+ chars, uppercase, lowercase, digit, special char)
strong_password = 'Password123!'

# Admin User
admin = User.find_or_initialize_by(email: 'admin@hubsight.com')
admin.assign_attributes(
  role: 'admin',
  first_name: 'Admin',
  last_name: 'Hubsight',
  phone: '+33 1 23 45 67 89',
  status: 'active',
  department: 'Administration',
  password: strong_password,
  password_confirmation: strong_password
)
admin.skip_confirmation!
if admin.new_record?
  admin.save!
  puts "  ✓ Created admin: admin@hubsight.com"
else
  admin.save!
  puts "  ✓ Updated admin: admin@hubsight.com"
end

# Portfolio Manager 1 - Organization 1
pm1 = User.find_or_initialize_by(email: 'portfolio@hubsight.com')
pm1.assign_attributes(
  role: 'portfolio_manager',
  first_name: 'Jean',
  last_name: 'Dupont',
  phone: '+33 6 12 34 56 78',
  organization_id: org1.id,
  status: 'active',
  department: 'Gestion Immobilière',
  password: strong_password,
  password_confirmation: strong_password
)
pm1.skip_confirmation!
if pm1.new_record?
  pm1.save!
  puts "  ✓ Created portfolio manager: portfolio@hubsight.com (Organization 1)"
else
  pm1.save!
  puts "  ✓ Updated portfolio manager: portfolio@hubsight.com (Organization 1)"
end

# Portfolio Manager 2 - Organization 2
pm2 = User.find_or_initialize_by(email: 'portfolio2@hubsight.com')
pm2.assign_attributes(
  role: 'portfolio_manager',
  first_name: 'Marie',
  last_name: 'Martin',
  phone: '+33 6 98 76 54 32',
  organization_id: org2.id,
  status: 'active',
  department: 'Gestion de Patrimoine',
  password: strong_password,
  password_confirmation: strong_password
)
pm2.skip_confirmation!
if pm2.new_record?
  pm2.save!
  puts "  ✓ Created portfolio manager: portfolio2@hubsight.com (Organization 2)"
else
  pm2.save!
  puts "  ✓ Updated portfolio manager: portfolio2@hubsight.com (Organization 2)"
end

# Site Manager 1 - Organization 1
sm1 = User.find_or_initialize_by(email: 'sitemanager@hubsight.com')
sm1.assign_attributes(
  role: 'site_manager',
  first_name: 'Pierre',
  last_name: 'Bernard',
  phone: '+33 6 11 22 33 44',
  organization_id: org1.id,
  status: 'active',
  department: 'Gestion de Site',
  password: strong_password,
  password_confirmation: strong_password
)
sm1.skip_confirmation!
if sm1.new_record?
  sm1.save!
  puts "  ✓ Created site manager: sitemanager@hubsight.com (Organization 1)"
else
  sm1.save!
  puts "  ✓ Updated site manager: sitemanager@hubsight.com (Organization 1)"
end

# Site Manager 2 - Organization 1
sm2 = User.find_or_initialize_by(email: 'sitemanager2@hubsight.com')
sm2.assign_attributes(
  role: 'site_manager',
  first_name: 'Sophie',
  last_name: 'Leroy',
  phone: '+33 6 55 66 77 88',
  organization_id: org1.id,
  status: 'active',
  department: 'Gestion de Site',
  password: strong_password,
  password_confirmation: strong_password
)
sm2.skip_confirmation!
if sm2.new_record?
  sm2.save!
  puts "  ✓ Created site manager: sitemanager2@hubsight.com (Organization 1)"
else
  sm2.save!
  puts "  ✓ Updated site manager: sitemanager2@hubsight.com (Organization 1)"
end

# Site Manager 3 - Organization 2
sm3 = User.find_or_initialize_by(email: 'sitemanager3@hubsight.com')
sm3.assign_attributes(
  role: 'site_manager',
  first_name: 'Luc',
  last_name: 'Moreau',
  phone: '+33 6 99 88 77 66',
  organization_id: org2.id,
  status: 'active',
  department: 'Gestion de Site',
  password: strong_password,
  password_confirmation: strong_password
)
sm3.skip_confirmation!
if sm3.new_record?
  sm3.save!
  puts "  ✓ Created site manager: sitemanager3@hubsight.com (Organization 2)"
else
  sm3.save!
  puts "  ✓ Updated site manager: sitemanager3@hubsight.com (Organization 2)"
end

# Technician 1 - Organization 1
tech1 = User.find_or_initialize_by(email: 'technician@hubsight.com')
tech1.assign_attributes(
  role: 'technician',
  first_name: 'Thomas',
  last_name: 'Petit',
  phone: '+33 6 44 55 66 77',
  organization_id: org1.id,
  status: 'active',
  department: 'Maintenance',
  password: strong_password,
  password_confirmation: strong_password
)
tech1.skip_confirmation!
if tech1.new_record?
  tech1.save!
  puts "  ✓ Created technician: technician@hubsight.com (Organization 1)"
else
  tech1.save!
  puts "  ✓ Updated technician: technician@hubsight.com (Organization 1)"
end

# Inactive User Example
inactive = User.find_or_initialize_by(email: 'inactive@hubsight.com')
inactive.assign_attributes(
  role: 'site_manager',
  first_name: 'Inactive',
  last_name: 'User',
  phone: '+33 6 00 00 00 00',
  organization_id: org1.id,
  status: 'inactive',
  department: 'Test',
  password: strong_password,
  password_confirmation: strong_password
)
inactive.skip_confirmation!
if inactive.new_record?
  inactive.save!
  puts "  ✓ Created inactive user: inactive@hubsight.com (for testing)"
else
  inactive.save!
  puts "  ✓ Updated inactive user: inactive@hubsight.com (for testing)"
end

# ============================================================================
# SITES - Sample sites for portfolio managers
# ============================================================================

puts "\n🏢 Creating sample sites..."

# Sites for Portfolio Manager 1 (Organization 1)
sites_pm1 = [
  {
    name: "Tour Montparnasse",
    code: "TMP-001",
    site_type: "bureaux",
    address: "33 Avenue du Maine",
    city: "Paris",
    postal_code: "75015",
    department: "75",
    region: "ile-de-france",
    total_area: 120000,
    estimated_area: 125000,
    site_manager: "Marie Dubois",
    contact_email: "marie.dubois@montparnasse.fr",
    contact_phone: "+33142229595",
    description: "Gratte-ciel emblématique du quartier Montparnasse",
    status: "active"
  },
  {
    name: "Campus La Défense",
    code: "CLD-002",
    site_type: "bureaux",
    address: "15 Esplanade du Général de Gaulle",
    city: "La Défense",
    postal_code: "92400",
    department: "92",
    region: "ile-de-france",
    total_area: 85500,
    site_manager: "Jean Martin",
    contact_email: "j.martin@ladefense.fr",
    contact_phone: "+33141256789",
    description: "Campus d'entreprise moderne dans le quartier d'affaires",
    status: "active"
  },
  {
    name: "Centre Commercial Odysseum",
    code: "CCO-003",
    site_type: "commercial",
    address: "2 Place de Lisbonne",
    city: "Montpellier",
    postal_code: "34000",
    department: "34",
    region: "occitanie",
    total_area: 65000,
    estimated_area: 68000,
    site_manager: "Sophie Bernard",
    contact_email: "s.bernard@odysseum.fr",
    contact_phone: "+33467135000",
    gps_coordinates: "43.6055° N, 3.9197° E",
    climate_zone: "H3 - Zone méditerranéenne",
    description: "Grand centre commercial avec zones commerciales et loisirs",
    status: "active"
  },
  {
    name: "Site Industriel Lyon Nord",
    code: "SIL-004",
    site_type: "industriel",
    address: "Zone Industrielle des Marais",
    city: "Lyon",
    postal_code: "69009",
    department: "69",
    region: "auvergne-rhone-alpes",
    total_area: 45000,
    site_manager: "Luc Moreau",
    contact_email: "l.moreau@industrie-lyon.fr",
    contact_phone: "+33478451234",
    description: "Site de production industrielle",
    status: "active"
  },
  {
    name: "Résidence Le Parc",
    code: "RLP-005",
    site_type: "residentiel",
    address: "89 Avenue Victor Hugo",
    city: "Nice",
    postal_code: "06000",
    department: "06",
    region: "provence-alpes-cote-azur",
    total_area: 12500,
    site_manager: "Claire Rousseau",
    contact_email: "c.rousseau@residenceleparc.fr",
    contact_phone: "+33493871234",
    description: "Résidence de standing en centre-ville",
    status: "active"
  }
]

sites_pm1.each do |site_data|
  site = pm1.sites.find_or_initialize_by(name: site_data[:name])
  site.assign_attributes(site_data.merge(organization_id: org1.id))
  if site.new_record?
    site.save!
    puts "  ✓ Created site: #{site.name} (#{site.city})"
  else
    site.save!
    puts "  ✓ Updated site: #{site.name} (#{site.city})"
  end
end

# Sites for Portfolio Manager 2 (Organization 2)
sites_pm2 = [
  {
    name: "Parc d'Activités Roissy",
    code: "PAR-006",
    site_type: "logistique",
    address: "Avenue de la Commune de Paris",
    city: "Roissy",
    postal_code: "95700",
    department: "95",
    region: "ile-de-france",
    total_area: 95000,
    site_manager: "Pierre Leroy",
    contact_email: "p.leroy@roissy-park.fr",
    contact_phone: "+33134291234",
    description: "Parc logistique près de l'aéroport CDG",
    status: "active"
  },
  {
    name: "Immeuble Haussmann",
    code: "IHA-007",
    site_type: "bureaux",
    address: "45 Boulevard Haussmann",
    city: "Paris",
    postal_code: "75009",
    department: "75",
    region: "ile-de-france",
    total_area: 8200,
    site_manager: "Anne Petit",
    contact_email: "a.petit@haussmann.fr",
    contact_phone: "+33142651234",
    description: "Immeuble haussmannien rénové",
    status: "active"
  },
  {
    name: "Centre Médical Pasteur",
    code: "CMP-008",
    site_type: "sante",
    address: "12 Rue Louis Pasteur",
    city: "Marseille",
    postal_code: "13001",
    department: "13",
    region: "provence-alpes-cote-azur",
    total_area: 15600,
    site_manager: "Dr. Laurent Blanc",
    contact_email: "l.blanc@pasteur-medical.fr",
    contact_phone: "+33491541234",
    description: "Centre médical pluridisciplinaire",
    status: "active"
  },
  {
    name: "Campus Universitaire Grenoble",
    code: "CUG-009",
    site_type: "enseignement",
    address: "621 Avenue Centrale",
    city: "Grenoble",
    postal_code: "38400",
    department: "38",
    region: "auvergne-rhone-alpes",
    total_area: 42000,
    site_manager: "François Dubois",
    contact_email: "f.dubois@univ-grenoble.fr",
    contact_phone: "+33476631234",
    description: "Campus universitaire",
    status: "active"
  },
  {
    name: "Zone Commerciale Atlantis",
    code: "ZCA-010",
    site_type: "commercial",
    address: "Avenue des Thébaudières",
    city: "Nantes",
    postal_code: "44800",
    department: "44",
    region: "pays-de-la-loire",
    total_area: 52000,
    site_manager: "Isabelle Martin",
    contact_email: "i.martin@atlantis.fr",
    contact_phone: "+33240471234",
    description: "Zone commerciale périphérique",
    status: "active"
  }
]

sites_pm2.each do |site_data|
  site = pm2.sites.find_or_initialize_by(name: site_data[:name])
  site.assign_attributes(site_data.merge(organization_id: org2.id))
  if site.new_record?
    site.save!
    puts "  ✓ Created site: #{site.name} (#{site.city})"
  else
    site.save!
    puts "  ✓ Updated site: #{site.name} (#{site.city})"
  end
end

# Additional sites for Portfolio Manager 1 to demonstrate pagination
additional_sites_pm1 = [
  {
    name: "Centre d'Affaires Champs-Élysées",
    code: "CAC-011",
    site_type: "bureaux",
    address: "103 Avenue des Champs-Élysées",
    city: "Paris",
    postal_code: "75008",
    department: "75",
    region: "ile-de-france",
    total_area: 15000,
    site_manager: "Philippe Durand",
    contact_email: "p.durand@champs-elysees.fr",
    contact_phone: "+33144131234",
    description: "Centre d'affaires prestigieux sur les Champs-Élysées",
    status: "active"
  },
  {
    name: "Plateforme Logistique Bordeaux",
    code: "PLB-012",
    site_type: "logistique",
    address: "Zone Logistique Atlantique",
    city: "Bordeaux",
    postal_code: "33300",
    department: "33",
    region: "nouvelle-aquitaine",
    total_area: 78000,
    site_manager: "Sylvie Mercier",
    contact_email: "s.mercier@logistique-bdx.fr",
    contact_phone: "+33556341234",
    description: "Plateforme logistique moderne avec accès autoroutier",
    status: "active"
  },
  {
    name: "Campus Tech Sophia Antipolis",
    code: "CTS-013",
    site_type: "bureaux",
    address: "Route des Lucioles",
    city: "Sophia Antipolis",
    postal_code: "06560",
    department: "06",
    region: "provence-alpes-cote-azur",
    total_area: 32000,
    site_manager: "Marc Fontaine",
    contact_email: "m.fontaine@sophia-tech.fr",
    contact_phone: "+33493951234",
    description: "Campus technologique dans la technopole",
    status: "active"
  },
  {
    name: "Usine Agroalimentaire Toulouse",
    code: "UAT-014",
    site_type: "industriel",
    address: "ZI Montredon",
    city: "Toulouse",
    postal_code: "31100",
    department: "31",
    region: "occitanie",
    total_area: 55000,
    site_manager: "Christine Lambert",
    contact_email: "c.lambert@agro-toulouse.fr",
    contact_phone: "+33561341234",
    description: "Site de production agroalimentaire certifié",
    status: "active"
  },
  {
    name: "Centre Commercial Part-Dieu",
    code: "CPD-015",
    site_type: "commercial",
    address: "17 Rue du Docteur Bouchut",
    city: "Lyon",
    postal_code: "69003",
    department: "69",
    region: "auvergne-rhone-alpes",
    total_area: 95000,
    site_manager: "Éric Bonnet",
    contact_email: "e.bonnet@partdieu.fr",
    contact_phone: "+33472601234",
    description: "Centre commercial majeur de Lyon",
    status: "active"
  },
  {
    name: "Résidence Étudiants Strasbourg",
    code: "RES-016",
    site_type: "residentiel",
    address: "15 Rue de la Fonderie",
    city: "Strasbourg",
    postal_code: "67000",
    department: "67",
    region: "grand-est",
    total_area: 18000,
    site_manager: "Nathalie Weber",
    contact_email: "n.weber@residence-stras.fr",
    contact_phone: "+33388351234",
    description: "Résidence moderne pour étudiants",
    status: "active"
  },
  {
    name: "Hôpital Saint-Antoine",
    code: "HSA-017",
    site_type: "sante",
    address: "184 Rue du Faubourg Saint-Antoine",
    city: "Paris",
    postal_code: "75012",
    department: "75",
    region: "ile-de-france",
    total_area: 42000,
    site_manager: "Dr. Isabelle Roussel",
    contact_email: "i.roussel@hopital-sa.fr",
    contact_phone: "+33149282000",
    description: "Établissement hospitalier universitaire",
    status: "active"
  },
  {
    name: "Lycée International Lille",
    code: "LIL-018",
    site_type: "enseignement",
    address: "Avenue de l'Université",
    city: "Lille",
    postal_code: "59000",
    department: "59",
    region: "hauts-de-france",
    total_area: 25000,
    site_manager: "François Delmas",
    contact_email: "f.delmas@lycee-lille.fr",
    contact_phone: "+33320121234",
    description: "Lycée international avec sections européennes",
    status: "active"
  }
]

additional_sites_pm1.each do |site_data|
  site = pm1.sites.find_or_initialize_by(name: site_data[:name])
  site.assign_attributes(site_data.merge(organization_id: org1.id))
  if site.new_record?
    site.save!
    puts "  ✓ Created site: #{site.name} (#{site.city})"
  else
    site.save!
    puts "  ✓ Updated site: #{site.name} (#{site.city})"
  end
end

# Additional sites for Portfolio Manager 2 to demonstrate pagination
additional_sites_pm2 = [
  {
    name: "Tour de Bureaux Euralille",
    code: "TBE-019",
    site_type: "bureaux",
    address: "Parvis de Rotterdam",
    city: "Lille",
    postal_code: "59777",
    department: "59",
    region: "hauts-de-france",
    total_area: 35000,
    site_manager: "Gérard Lefevre",
    contact_email: "g.lefevre@euralille.fr",
    contact_phone: "+33320141234",
    description: "Tour moderne dans le quartier d'affaires",
    status: "active"
  },
  {
    name: "Entrepôt Frigorifique Rungis",
    code: "EFR-020",
    site_type: "logistique",
    address: "Marché International de Rungis",
    city: "Rungis",
    postal_code: "94150",
    department: "94",
    region: "ile-de-france",
    total_area: 62000,
    site_manager: "André Moreau",
    contact_email: "a.moreau@rungis-frigo.fr",
    contact_phone: "+33146871234",
    description: "Entrepôt frigorifique du marché de Rungis",
    status: "active"
  },
  {
    name: "Clinique Saint-Martin",
    code: "CSM-021",
    site_type: "sante",
    address: "Avenue Foch",
    city: "Toulouse",
    postal_code: "31400",
    department: "31",
    region: "occitanie",
    total_area: 28000,
    site_manager: "Dr. Catherine Blanc",
    contact_email: "c.blanc@clinique-sm.fr",
    contact_phone: "+33561231234",
    description: "Clinique privée pluridisciplinaire",
    status: "active"
  },
  {
    name: "Centre Aquatique Nantes",
    code: "CAN-022",
    site_type: "autre",
    address: "Boulevard des Tribunes",
    city: "Nantes",
    postal_code: "44300",
    department: "44",
    region: "pays-de-la-loire",
    total_area: 12000,
    site_manager: "Julie Fournier",
    contact_email: "j.fournier@aquatique-nantes.fr",
    contact_phone: "+33240201234",
    description: "Centre aquatique municipal avec piscine olympique",
    status: "active"
  },
  {
    name: "Galerie Marchande Beaugrenelle",
    code: "GMB-023",
    site_type: "commercial",
    address: "12 Rue Linois",
    city: "Paris",
    postal_code: "75015",
    department: "75",
    region: "ile-de-france",
    total_area: 48000,
    site_manager: "Stéphane Girard",
    contact_email: "s.girard@beaugrenelle.fr",
    contact_phone: "+33145791234",
    description: "Centre commercial en bord de Seine",
    status: "active"
  },
  {
    name: "Technopole Rennes Atalante",
    code: "TRA-024",
    site_type: "bureaux",
    address: "Rue de la Rigourdière",
    city: "Rennes",
    postal_code: "35510",
    department: "35",
    region: "bretagne",
    total_area: 38000,
    site_manager: "Olivier Legrand",
    contact_email: "o.legrand@atalante.fr",
    contact_phone: "+33299121234",
    description: "Technopole bretonne innovation et recherche",
    status: "active"
  },
  {
    name: "Site Industriel Mulhouse",
    code: "SIM-025",
    site_type: "industriel",
    address: "Zone Industrielle Nord",
    city: "Mulhouse",
    postal_code: "68100",
    department: "68",
    region: "grand-est",
    total_area: 71000,
    site_manager: "Bernard Schmitt",
    contact_email: "b.schmitt@industrie-mul.fr",
    contact_phone: "+33389451234",
    description: "Site de production industrielle diversifiée",
    status: "active"
  }
]

additional_sites_pm2.each do |site_data|
  site = pm2.sites.find_or_initialize_by(name: site_data[:name])
  site.assign_attributes(site_data.merge(organization_id: org2.id))
  if site.new_record?
    site.save!
    puts "  ✓ Created site: #{site.name} (#{site.city})"
  else
    site.save!
    puts "  ✓ Updated site: #{site.name} (#{site.city})"
  end
end

puts "\n📊 Total sites created: #{Site.count}"
puts "   - Portfolio Manager 1: #{pm1.sites.count} sites"
puts "   - Portfolio Manager 2: #{pm2.sites.count} sites"

# ============================================================================
# SITE ASSIGNMENTS - Assign sites to site managers
# ============================================================================

puts "\n🔗 Creating site assignments..."

# Get sites for Organization 1
org1_sites = Site.where(organization_id: org1.id).order(:name).to_a

# Assign first 5 sites to Site Manager 1 (Organization 1)
if org1_sites.length >= 5
  org1_sites[0..4].each do |site|
    assignment = SiteAssignment.find_or_initialize_by(user: sm1, site: site)
    assignment.assigned_by_name = pm1.full_name
    if assignment.new_record?
      assignment.save!
      puts "  ✓ Assigned #{site.name} to #{sm1.full_name}"
    end
  end
end

# Assign sites 6-10 to Site Manager 2 (Organization 1)
if org1_sites.length >= 10
  org1_sites[5..9].each do |site|
    assignment = SiteAssignment.find_or_initialize_by(user: sm2, site: site)
    assignment.assigned_by_name = pm1.full_name
    if assignment.new_record?
      assignment.save!
      puts "  ✓ Assigned #{site.name} to #{sm2.full_name}"
    end
  end
end

# Get sites for Organization 2
org2_sites = Site.where(organization_id: org2.id).order(:name).to_a

# Assign first 4 sites to Site Manager 3 (Organization 2)
if org2_sites.length >= 4
  org2_sites[0..3].each do |site|
    assignment = SiteAssignment.find_or_initialize_by(user: sm3, site: site)
    assignment.assigned_by_name = pm2.full_name
    if assignment.new_record?
      assignment.save!
      puts "  ✓ Assigned #{site.name} to #{sm3.full_name}"
    end
  end
end

puts "\n📊 Total site assignments created: #{SiteAssignment.count}"
puts "   - #{sm1.full_name}: #{sm1.assigned_sites.count} sites"
puts "   - #{sm2.full_name}: #{sm2.assigned_sites.count} sites"
puts "   - #{sm3.full_name}: #{sm3.assigned_sites.count} sites"

# ============================================================================
# SERVICE PROVIDER ORGANIZATIONS - For contract testing (Tasks 35-39)
# ============================================================================

puts "\n🏭 Creating service provider organizations..."

service_providers = [
  {
    name: "ENGIE Solutions",
    legal_name: "ENGIE Solutions SAS",
    siret: "48933669601234",
    organization_type: "supplier",
    headquarters_address: "1 Place Samuel de Champlain, 92400 Courbevoie",
    phone: "+33 1 44 22 00 00",
    email: "contact@engie-solutions.com",
    website: "www.engie-solutions.com",
    status: "active"
  },
  {
    name: "Veolia Facility Management",
    legal_name: "Veolia Facility Management France SAS",
    siret: "55200844302156",
    organization_type: "supplier",
    headquarters_address: "30 Rue Madeleine Vionnet, 93300 Aubervilliers",
    phone: "+33 1 85 57 00 00",
    email: "contact@veolia-fm.fr",
    website: "www.veolia.fr",
    status: "active"
  },
  {
    name: "Dalkia",
    legal_name: "Dalkia France SAS",
    siret: "39568026100789",
    organization_type: "supplier",
    headquarters_address: "5 Place des Frères Montgolfier, 78280 Guyancourt",
    phone: "+33 1 39 23 80 00",
    email: "contact@dalkia.fr",
    website: "www.dalkia.fr",
    status: "active"
  },
  {
    name: "ISS Facility Services",
    legal_name: "ISS Facility Services France SAS",
    siret: "41976451200345",
    organization_type: "supplier",
    headquarters_address: "83 Avenue Aristide Briand, 94110 Arcueil",
    phone: "+33 1 41 24 29 00",
    email: "contact.france@fr.issworld.com",
    website: "www.fr.issworld.com",
    status: "active"
  },
  {
    name: "Onet Technologies",
    legal_name: "Onet Technologies SAS",
    siret: "54207882500567",
    organization_type: "supplier",
    headquarters_address: "13 Avenue de l'Opéra, 75001 Paris",
    phone: "+33 1 53 29 50 00",
    email: "contact@onet.fr",
    website: "www.onet.fr",
    status: "active"
  },
  {
    name: "Elior Services",
    legal_name: "Elior Services Care SAS",
    siret: "40816800300234",
    organization_type: "supplier",
    headquarters_address: "61-69 Rue de Bercy, 75012 Paris",
    phone: "+33 1 71 06 70 00",
    email: "contact@eliorgroup.com",
    website: "www.eliorgroup.com",
    status: "active"
  },
  {
    name: "Sodexo Facilities Management",
    legal_name: "Sodexo Pass France SAS",
    siret: "30194021900456",
    organization_type: "supplier",
    headquarters_address: "255 Quai de la Bataille de Stalingrad, 92130 Issy-les-Moulineaux",
    phone: "+33 1 30 85 75 00",
    email: "contact@sodexo.com",
    website: "www.sodexo.fr",
    status: "active"
  },
  {
    name: "Cofely Services",
    legal_name: "Cofely Services SAS",
    siret: "45123456700123",
    organization_type: "supplier",
    headquarters_address: "12 Avenue du Général de Gaulle, 92400 Courbevoie",
    phone: "+33 1 49 00 40 00",
    email: "contact@cofely-services.fr",
    website: "www.gdfsuez-cofelyservices.fr",
    status: "active"
  },
  {
    name: "Spie Facilities",
    legal_name: "Spie Facilities SAS",
    siret: "37890123400567",
    organization_type: "supplier",
    headquarters_address: "10 Avenue de l'Entreprise, 95863 Cergy-Pontoise",
    phone: "+33 1 34 41 81 00",
    email: "contact@spie.com",
    website: "www.spie.com",
    status: "active"
  },
  {
    name: "Bouygues Energies & Services",
    legal_name: "Bouygues Energies & Services SAS",
    siret: "52456789000234",
    organization_type: "supplier",
    headquarters_address: "3 Boulevard Gallieni, 92130 Issy-les-Moulineaux",
    phone: "+33 1 30 60 33 00",
    email: "contact@bouygues-es.fr",
    website: "www.bouygues-es.fr",
    status: "active"
  },
  {
    name: "Suez",
    legal_name: "Suez France SAS",
    siret: "90123456700890",
    organization_type: "supplier",
    headquarters_address: "Tour CB21, 16 Place de l'Iris, 92400 Courbevoie",
    phone: "+33 1 58 81 20 00",
    email: "contact@suez.com",
    website: "www.suez.fr",
    status: "active"
  },
  {
    name: "Vinci Facilities",
    legal_name: "Vinci Facilities IDF SAS",
    siret: "34567890100456",
    organization_type: "supplier",
    headquarters_address: "1 Cours Ferdinand de Lesseps, 92500 Rueil-Malmaison",
    phone: "+33 1 47 16 35 00",
    email: "contact@vinci-facilities.com",
    website: "www.vinci-facilities.com",
    status: "active"
  },
  {
    name: "Eiffage Energie Systèmes",
    legal_name: "Eiffage Energie Systèmes SAS",
    siret: "56723489000123",
    organization_type: "supplier",
    headquarters_address: "9 Place de l'Europe, 78140 Vélizy-Villacoublay",
    phone: "+33 1 34 65 89 00",
    email: "contact@eiffage-energie.com",
    website: "www.eiffage-energie.com",
    status: "active"
  },
  {
    name: "Securitas France",
    legal_name: "Securitas France SARL",
    siret: "78945612300789",
    organization_type: "supplier",
    headquarters_address: "2-4 Rue Diderot, 92150 Suresnes",
    phone: "+33 1 55 62 44 00",
    email: "contact@securitas.fr",
    website: "www.securitas.fr",
    status: "active"
  },
  {
    name: "Kone France",
    legal_name: "Kone SAS",
    siret: "61234578900234",
    organization_type: "supplier",
    headquarters_address: "3 Avenue du Canada, 91974 Courtabœuf",
    phone: "+33 1 60 13 33 00",
    email: "contact.france@kone.com",
    website: "www.kone.fr",
    status: "active"
  }
]

service_providers.each do |provider_data|
  provider = Organization.find_or_initialize_by(name: provider_data[:name])
  provider.assign_attributes(provider_data)
  
  if provider.new_record?
    provider.save!
    puts "  ✓ Created organization: #{provider.name}"
  else
    provider.save!
    puts "  ✓ Updated organization: #{provider.name}"
  end
end

puts "\n📊 Total service provider organizations: #{Organization.count}"

# ============================================================================
# CONTACTS - Key contacts for each organization
# ============================================================================

puts "\n👥 Creating contacts for organizations..."

contacts_data = [
  # ENGIE Solutions
  { org_name: "ENGIE Solutions", first_name: "Pierre", last_name: "Dubois", position: "Directeur Technique", department: "Direction Technique", phone: "+33 1 44 22 10 01", mobile: "+33 6 12 34 56 78", email: "pierre.dubois@engie-solutions.com", status: "active" },
  { org_name: "ENGIE Solutions", first_name: "Marie", last_name: "Laurent", position: "Responsable Contrats", department: "Commercial", phone: "+33 1 44 22 10 02", mobile: "+33 6 23 45 67 89", email: "marie.laurent@engie-solutions.com", status: "active" },
  { org_name: "ENGIE Solutions", first_name: "Jean", last_name: "Martin", position: "Chef de Projet", department: "Projets", phone: "+33 1 44 22 10 03", mobile: "+33 6 34 56 78 90", email: "jean.martin@engie-solutions.com", status: "active" },
  
  # Veolia
  { org_name: "Veolia Facility Management", first_name: "Sophie", last_name: "Bernard", position: "Directrice Régionale", department: "Direction", phone: "+33 1 85 57 01 01", mobile: "+33 6 45 67 89 01", email: "sophie.bernard@veolia-fm.fr", status: "active" },
  { org_name: "Veolia Facility Management", first_name: "Luc", last_name: "Moreau", position: "Responsable Maintenance", department: "Maintenance", phone: "+33 1 85 57 01 02", mobile: "+33 6 56 78 90 12", email: "luc.moreau@veolia-fm.fr", status: "active" },
  
  # Dalkia
  { org_name: "Dalkia", first_name: "Claire", last_name: "Rousseau", position: "Directrice Commerciale", department: "Commercial", phone: "+33 1 39 23 80 01", mobile: "+33 6 67 89 01 23", email: "claire.rousseau@dalkia.fr", status: "active" },
  { org_name: "Dalkia", first_name: "Marc", last_name: "Fontaine", position: "Chef de Secteur", department: "Exploitation", phone: "+33 1 39 23 80 02", mobile: "+33 6 78 90 12 34", email: "marc.fontaine@dalkia.fr", status: "active" },
  
  # ISS
  { org_name: "ISS Facility Services", first_name: "Isabelle", last_name: "Leroy", position: "Account Manager", department: "Clientèle", phone: "+33 1 41 24 29 01", mobile: "+33 6 89 01 23 45", email: "isabelle.leroy@fr.issworld.com", status: "active" },
  { org_name: "ISS Facility Services", first_name: "François", last_name: "Petit", position: "Responsable Nettoyage", department: "Nettoyage", phone: "+33 1 41 24 29 02", mobile: "+33 6 90 12 34 56", email: "francois.petit@fr.issworld.com", status: "active" },
  
  # Onet
  { org_name: "Onet Technologies", first_name: "Nathalie", last_name: "Mercier", position: "Directrice d'Agence", department: "Direction", phone: "+33 1 53 29 50 01", mobile: "+33 6 01 23 45 67", email: "nathalie.mercier@onet.fr", status: "active" },
  { org_name: "Onet Technologies", first_name: "Gérard", last_name: "Blanc", position: "Responsable Technique", department: "Technique", phone: "+33 1 53 29 50 02", mobile: "+33 6 12 34 56 89", email: "gerard.blanc@onet.fr", status: "active" },
  
  # Elior
  { org_name: "Elior Services", first_name: "Catherine", last_name: "Durand", position: "Directrice de Site", department: "Sites", phone: "+33 1 71 06 70 01", mobile: "+33 6 23 45 67 90", email: "catherine.durand@eliorgroup.com", status: "active" },
  
  # Sodexo
  { org_name: "Sodexo Facilities Management", first_name: "Philippe", last_name: "Girard", position: "Responsable Sécurité", department: "Sécurité", phone: "+33 1 30 85 75 01", mobile: "+33 6 34 56 78 01", email: "philippe.girard@sodexo.com", status: "active" },
  { org_name: "Sodexo Facilities Management", first_name: "Sylvie", last_name: "Lambert", position: "Responsable Qualité", department: "Qualité", phone: "+33 1 30 85 75 02", mobile: "+33 6 45 67 89 12", email: "sylvie.lambert@sodexo.com", status: "active" },
  
  # Cofely
  { org_name: "Cofely Services", first_name: "André", last_name: "Bonnet", position: "Directeur Technique", department: "Technique", phone: "+33 1 49 00 40 01", mobile: "+33 6 56 78 90 23", email: "andre.bonnet@cofely-services.fr", status: "active" },
  { org_name: "Cofely Services", first_name: "Christine", last_name: "Fournier", position: "Ingénieur CVC", department: "CVC", phone: "+33 1 49 00 40 02", mobile: "+33 6 67 89 01 34", email: "christine.fournier@cofely-services.fr", status: "active" },
  
  # Spie
  { org_name: "Spie Facilities", first_name: "Éric", last_name: "Roussel", position: "Chef de Projet", department: "Projets", phone: "+33 1 34 41 81 01", mobile: "+33 6 78 90 12 45", email: "eric.roussel@spie.com", status: "active" },
  
  # Bouygues
  { org_name: "Bouygues Energies & Services", first_name: "Olivier", last_name: "Weber", position: "Directeur Commercial", department: "Commercial", phone: "+33 1 30 60 33 01", mobile: "+33 6 89 01 23 56", email: "olivier.weber@bouygues-es.fr", status: "active" },
  { org_name: "Bouygues Energies & Services", first_name: "Julie", last_name: "Legrand", position: "Ingénieur Electricité", department: "Electricité", phone: "+33 1 30 60 33 02", mobile: "+33 6 90 12 34 67", email: "julie.legrand@bouygues-es.fr", status: "active" },
  
  # Suez
  { org_name: "Suez", first_name: "Bernard", last_name: "Schmitt", position: "Responsable Fluides", department: "Fluides", phone: "+33 1 58 81 20 01", mobile: "+33 6 01 23 45 78", email: "bernard.schmitt@suez.com", status: "active" },
  
  # Vinci
  { org_name: "Vinci Facilities", first_name: "Stéphane", last_name: "Lefebvre", position: "Directeur d'Exploitation", department: "Exploitation", phone: "+33 1 47 16 35 01", mobile: "+33 6 12 34 56 90", email: "stephane.lefebvre@vinci-facilities.com", status: "active" },
  { org_name: "Vinci Facilities", first_name: "Anne", last_name: "Delmas", position: "Responsable Contrats", department: "Contrats", phone: "+33 1 47 16 35 02", mobile: "+33 6 23 45 67 01", email: "anne.delmas@vinci-facilities.com", status: "active" },
  
  # Eiffage
  { org_name: "Eiffage Energie Systèmes", first_name: "François", last_name: "Morel", position: "Chef d'Agence", department: "Agence", phone: "+33 1 34 65 89 01", mobile: "+33 6 34 56 78 12", email: "francois.morel@eiffage-energie.com", status: "active" },
  
  # Securitas
  { org_name: "Securitas France", first_name: "Laurent", last_name: "Garcia", position: "Responsable Sûreté", department: "Sûreté", phone: "+33 1 55 62 44 01", mobile: "+33 6 45 67 89 23", email: "laurent.garcia@securitas.fr", status: "active" },
  { org_name: "Securitas France", first_name: "Martine", last_name: "Roux", position: "Chef d'Équipe", department: "Opérations", phone: "+33 1 55 62 44 02", mobile: "+33 6 56 78 90 34", email: "martine.roux@securitas.fr", status: "active" },
  
  # Kone
  { org_name: "Kone France", first_name: "Thierry", last_name: "Benoit", position: "Responsable Maintenance", department: "Maintenance", phone: "+33 1 60 13 33 01", mobile: "+33 6 67 89 01 45", email: "thierry.benoit@kone.com", status: "active" },
  { org_name: "Kone France", first_name: "Valérie", last_name: "Simon", position: "Technicienne Senior", department: "Technique", phone: "+33 1 60 13 33 02", mobile: "+33 6 78 90 12 56", email: "valerie.simon@kone.com", status: "active" }
]

contacts_data.each do |contact_data|
  org_name = contact_data.delete(:org_name)
  org = Organization.find_by(name: org_name)
  
  next unless org
  
  contact = Contact.find_or_initialize_by(
    organization_id: org.id,
    email: contact_data[:email]
  )
  contact.assign_attributes(contact_data)
  
  if contact.new_record?
    contact.save!
    puts "  ✓ Created contact: #{contact.first_name} #{contact.last_name} (#{org_name})"
  else
    contact.save!
  end
end

puts "\n📊 Total contacts created: #{Contact.count}"

# ============================================================================
# AGENCIES - Branches and establishments for organizations
# ============================================================================

puts "\n🏪 Creating agencies for organizations..."

agencies_data = [
  # ENGIE Solutions
  { org_name: "ENGIE Solutions", name: "Siège Social Paris", code: "ENGIE-HQ", agency_type: "headquarters", address: "1 Place Samuel de Champlain", postal_code: "92400", city: "Courbevoie", phone: "+33 1 44 22 00 00", status: "active" },
  { org_name: "ENGIE Solutions", name: "Agence Île-de-France", code: "ENGIE-IDF", agency_type: "regional", address: "15 Rue Jean Jaurès", postal_code: "93170", city: "Bagnolet", phone: "+33 1 44 22 50 00", status: "active" },
  
  # Veolia
  { org_name: "Veolia Facility Management", name: "Direction Générale", code: "VFM-DG", agency_type: "headquarters", address: "30 Rue Madeleine Vionnet", postal_code: "93300", city: "Aubervilliers", phone: "+33 1 85 57 00 00", status: "active" },
  { org_name: "Veolia Facility Management", name: "Agence Paris Nord", code: "VFM-PN", agency_type: "branch", address: "5 Avenue du Parc", postal_code: "95380", city: "Louvres", phone: "+33 1 85 57 10 00", status: "active" },
  
  # Dalkia
  { org_name: "Dalkia", name: "Siège Guyancourt", code: "DALKIA-HQ", agency_type: "headquarters", address: "5 Place des Frères Montgolfier", postal_code: "78280", city: "Guyancourt", phone: "+33 1 39 23 80 00", status: "active" },
  { org_name: "Dalkia", name: "Agence Lyon", code: "DALKIA-LYO", agency_type: "regional", address: "45 Rue de la République", postal_code: "69002", city: "Lyon", phone: "+33 4 72 10 20 00", status: "active" },
  
  # ISS
  { org_name: "ISS Facility Services", name: "Siège Arcueil", code: "ISS-HQ", agency_type: "headquarters", address: "83 Avenue Aristide Briand", postal_code: "94110", city: "Arcueil", phone: "+33 1 41 24 29 00", status: "active" },
  
  # Onet
  { org_name: "Onet Technologies", name: "Direction Paris", code: "ONET-PAR", agency_type: "headquarters", address: "13 Avenue de l'Opéra", postal_code: "75001", city: "Paris", phone: "+33 1 53 29 50 00", status: "active" },
  { org_name: "Onet Technologies", name: "Centre de Services Marseille", code: "ONET-MAR", agency_type: "service_center", address: "78 Boulevard de la Libération", postal_code: "13001", city: "Marseille", phone: "+33 4 91 10 20 00", status: "active" },
  
  # Elior
  { org_name: "Elior Services", name: "Siège Paris", code: "ELIOR-HQ", agency_type: "headquarters", address: "61-69 Rue de Bercy", postal_code: "75012", city: "Paris", phone: "+33 1 71 06 70 00", status: "active" },
  
  # Sodexo
  { org_name: "Sodexo Facilities Management", name: "Direction Générale", code: "SODEXO-DG", agency_type: "headquarters", address: "255 Quai de la Bataille de Stalingrad", postal_code: "92130", city: "Issy-les-Moulineaux", phone: "+33 1 30 85 75 00", status: "active" },
  { org_name: "Sodexo Facilities Management", name: "Agence Toulouse", code: "SODEXO-TOU", agency_type: "branch", address: "12 Allée Jean Jaurès", postal_code: "31000", city: "Toulouse", phone: "+33 5 61 10 20 00", status: "active" },
  
  # Cofely
  { org_name: "Cofely Services", name: "Siège Social", code: "COFELY-HQ", agency_type: "headquarters", address: "12 Avenue du Général de Gaulle", postal_code: "92400", city: "Courbevoie", phone: "+33 1 49 00 40 00", status: "active" },
  
  # Spie
  { org_name: "Spie Facilities", name: "Direction Cergy", code: "SPIE-CER", agency_type: "headquarters", address: "10 Avenue de l'Entreprise", postal_code: "95863", city: "Cergy-Pontoise", phone: "+33 1 34 41 81 00", status: "active" },
  { org_name: "Spie Facilities", name: "Agence Lille", code: "SPIE-LIL", agency_type: "regional", address: "50 Rue de Tournai", postal_code: "59000", city: "Lille", phone: "+33 3 20 10 20 00", status: "active" },
  
  # Bouygues
  { org_name: "Bouygues Energies & Services", name: "Siège Issy", code: "BYGES-HQ", agency_type: "headquarters", address: "3 Boulevard Gallieni", postal_code: "92130", city: "Issy-les-Moulineaux", phone: "+33 1 30 60 33 00", status: "active" },
  
  # Suez
  { org_name: "Suez", name: "Tour CB21", code: "SUEZ-HQ", agency_type: "headquarters", address: "16 Place de l'Iris", postal_code: "92400", city: "Courbevoie", phone: "+33 1 58 81 20 00", status: "active" },
  
  # Vinci
  { org_name: "Vinci Facilities", name: "Direction IDF", code: "VINCI-IDF", agency_type: "headquarters", address: "1 Cours Ferdinand de Lesseps", postal_code: "92500", city: "Rueil-Malmaison", phone: "+33 1 47 16 35 00", status: "active" },
  { org_name: "Vinci Facilities", name: "Agence Bordeaux", code: "VINCI-BDX", agency_type: "branch", address: "23 Cours de la Somme", postal_code: "33800", city: "Bordeaux", phone: "+33 5 56 10 20 00", status: "active" },
  
  # Eiffage
  { org_name: "Eiffage Energie Systèmes", name: "Siège Vélizy", code: "EIFFAGE-HQ", agency_type: "headquarters", address: "9 Place de l'Europe", postal_code: "78140", city: "Vélizy-Villacoublay", phone: "+33 1 34 65 89 00", status: "active" },
  
  # Securitas
  { org_name: "Securitas France", name: "Direction Suresnes", code: "SECU-HQ", agency_type: "headquarters", address: "2-4 Rue Diderot", postal_code: "92150", city: "Suresnes", phone: "+33 1 55 62 44 00", status: "active" },
  
  # Kone
  { org_name: "Kone France", name: "Siège Courtabœuf", code: "KONE-HQ", agency_type: "headquarters", address: "3 Avenue du Canada", postal_code: "91974", city: "Courtabœuf", phone: "+33 1 60 13 33 00", status: "active" }
]

agencies_data.each do |agency_data|
  org_name = agency_data.delete(:org_name)
  org = Organization.find_by(name: org_name)
  
  next unless org
  
  agency = Agency.find_or_initialize_by(
    organization_id: org.id,
    code: agency_data[:code]
  )
  agency.assign_attributes(agency_data)
  
  if agency.new_record?
    agency.save!
    puts "  ✓ Created agency: #{agency.name} (#{org_name})"
  else
    agency.save!
  end
end

puts "\n📊 Total agencies created: #{Agency.count}"

# ============================================================================
# AGENCIES FOR ORGANIZATION 1 - Portfolio Manager's organization agencies
# ============================================================================

puts "\n🏢 Creating 30 agencies for Organization 1 (Immobilière Centrale)..."

org1_agencies_data = [
  # Headquarters
  { name: "Siège Social Immobilière Centrale", code: "IMC-HQ-001", agency_type: "headquarters", 
    address: "45 Avenue Montaigne", postal_code: "75008", city: "Paris", 
    region: "Île-de-France", phone: "+33 1 44 13 22 22", 
    email: "siege@immobiliere-centrale.fr", status: "active",
    manager_name: "Jean-Pierre Durand", manager_contact: "+33 6 12 34 56 78" },
  
  # Regional Offices - 5 agencies
  { name: "Agence Régionale Île-de-France Nord", code: "IMC-IDF-N", agency_type: "regional_office",
    address: "15 Boulevard Poissonnière", postal_code: "75002", city: "Paris",
    region: "Île-de-France", phone: "+33 1 42 36 70 00", email: "idf-nord@immobiliere-centrale.fr",
    status: "active", manager_name: "Marie Dubois", manager_contact: "+33 6 23 45 67 89" },
    
  { name: "Agence Régionale Île-de-France Sud", code: "IMC-IDF-S", agency_type: "regional_office",
    address: "22 Rue de Tolbiac", postal_code: "75013", city: "Paris",
    region: "Île-de-France", phone: "+33 1 45 83 12 34", email: "idf-sud@immobiliere-centrale.fr",
    status: "active", manager_name: "Sophie Martin", manager_contact: "+33 6 34 56 78 90" },
  
  { name: "Agence Régionale Auvergne-Rhône-Alpes", code: "IMC-ARA", agency_type: "regional_office",
    address: "78 Cours Gambetta", postal_code: "69003", city: "Lyon",
    region: "Auvergne-Rhône-Alpes", phone: "+33 4 72 34 56 78", email: "lyon@immobiliere-centrale.fr",
    status: "active", manager_name: "Luc Moreau", manager_contact: "+33 6 45 67 89 01" },
  
  { name: "Agence Régionale Provence-Alpes-Côte d'Azur", code: "IMC-PACA", agency_type: "regional_office",
    address: "12 La Canebière", postal_code: "13001", city: "Marseille",
    region: "Provence-Alpes-Côte d'Azur", phone: "+33 4 91 54 32 10", email: "marseille@immobiliere-centrale.fr",
    status: "active", manager_name: "Claire Bernard", manager_contact: "+33 6 56 78 90 12" },
  
  { name: "Agence Régionale Nouvelle-Aquitaine", code: "IMC-NAQ", agency_type: "regional_office",
    address: "34 Cours de l'Intendance", postal_code: "33000", city: "Bordeaux",
    region: "Nouvelle-Aquitaine", phone: "+33 5 56 48 12 34", email: "bordeaux@immobiliere-centrale.fr",
    status: "active", manager_name: "Marc Fontaine", manager_contact: "+33 6 67 89 01 23" },
  
  # Local Branches - 20 agencies
  { name: "Agence Locale La Défense", code: "IMC-DEF", agency_type: "branch",
    address: "25 Esplanade du Général de Gaulle", postal_code: "92400", city: "La Défense",
    region: "Île-de-France", phone: "+33 1 47 73 12 34", email: "ladefense@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Versailles", code: "IMC-VER", agency_type: "branch",
    address: "18 Rue de la Paroisse", postal_code: "78000", city: "Versailles",
    region: "Île-de-France", phone: "+33 1 39 50 12 34", email: "versailles@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Saint-Germain-en-Laye", code: "IMC-SGE", agency_type: "branch",
    address: "5 Rue au Pain", postal_code: "78100", city: "Saint-Germain-en-Laye",
    region: "Île-de-France", phone: "+33 1 34 51 12 34", email: "st-germain@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Neuilly-sur-Seine", code: "IMC-NEU", agency_type: "branch",
    address: "42 Avenue Charles de Gaulle", postal_code: "92200", city: "Neuilly-sur-Seine",
    region: "Île-de-France", phone: "+33 1 46 24 12 34", email: "neuilly@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Montreuil", code: "IMC-MTR", agency_type: "branch",
    address: "8 Rue de Paris", postal_code: "93100", city: "Montreuil",
    region: "Île-de-France", phone: "+33 1 48 58 12 34", email: "montreuil@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Lille", code: "IMC-LIL", agency_type: "branch",
    address: "56 Rue Nationale", postal_code: "59000", city: "Lille",
    region: "Hauts-de-France", phone: "+33 3 20 55 12 34", email: "lille@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Toulouse", code: "IMC-TLS", agency_type: "branch",
    address: "28 Rue d'Alsace-Lorraine", postal_code: "31000", city: "Toulouse",
    region: "Occitanie", phone: "+33 5 61 23 12 34", email: "toulouse@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Nice", code: "IMC-NCE", agency_type: "branch",
    address: "15 Avenue Jean Médecin", postal_code: "06000", city: "Nice",
    region: "Provence-Alpes-Côte d'Azur", phone: "+33 4 93 87 12 34", email: "nice@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Nantes", code: "IMC-NTE", agency_type: "branch",
    address: "7 Place Graslin", postal_code: "44000", city: "Nantes",
    region: "Pays de la Loire", phone: "+33 2 40 47 12 34", email: "nantes@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Strasbourg", code: "IMC-STR", agency_type: "branch",
    address: "22 Place Kléber", postal_code: "67000", city: "Strasbourg",
    region: "Grand Est", phone: "+33 3 88 32 12 34", email: "strasbourg@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Montpellier", code: "IMC-MTP", agency_type: "branch",
    address: "12 Rue de la Loge", postal_code: "34000", city: "Montpellier",
    region: "Occitanie", phone: "+33 4 67 60 12 34", email: "montpellier@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Rennes", code: "IMC-RNS", agency_type: "branch",
    address: "18 Rue Le Bastard", postal_code: "35000", city: "Rennes",
    region: "Bretagne", phone: "+33 2 99 79 12 34", email: "rennes@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Grenoble", code: "IMC-GRE", agency_type: "branch",
    address: "5 Place Victor Hugo", postal_code: "38000", city: "Grenoble",
    region: "Auvergne-Rhône-Alpes", phone: "+33 4 76 46 12 34", email: "grenoble@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Dijon", code: "IMC-DIJ", agency_type: "branch",
    address: "9 Rue de la Liberté", postal_code: "21000", city: "Dijon",
    region: "Bourgogne-Franche-Comté", phone: "+33 3 80 30 12 34", email: "dijon@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Reims", code: "IMC-RMS", agency_type: "branch",
    address: "14 Place Drouet d'Erlon", postal_code: "51100", city: "Reims",
    region: "Grand Est", phone: "+33 3 26 47 12 34", email: "reims@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Le Havre", code: "IMC-LEH", agency_type: "branch",
    address: "6 Place de l'Hôtel de Ville", postal_code: "76600", city: "Le Havre",
    region: "Normandie", phone: "+33 2 35 19 12 34", email: "lehavre@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Toulon", code: "IMC-TLN", agency_type: "branch",
    address: "8 Avenue Colbert", postal_code: "83000", city: "Toulon",
    region: "Provence-Alpes-Côte d'Azur", phone: "+33 4 94 03 12 34", email: "toulon@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Angers", code: "IMC-ANG", agency_type: "branch",
    address: "11 Rue Lenepveu", postal_code: "49100", city: "Angers",
    region: "Pays de la Loire", phone: "+33 2 41 87 12 34", email: "angers@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Brest", code: "IMC-BRS", agency_type: "branch",
    address: "3 Rue de Siam", postal_code: "29200", city: "Brest",
    region: "Bretagne", phone: "+33 2 98 44 12 34", email: "brest@immobiliere-centrale.fr",
    status: "active" },
  
  { name: "Agence Locale Aix-en-Provence", code: "IMC-AIX", agency_type: "branch",
    address: "17 Cours Mirabeau", postal_code: "13100", city: "Aix-en-Provence",
    region: "Provence-Alpes-Côte d'Azur", phone: "+33 4 42 26 12 34", email: "aix@immobiliere-centrale.fr",
    status: "active" },
  
  # Service Centers - 4 agencies
  { name: "Centre de Services Paris Est", code: "IMC-SVC-PE", agency_type: "service_center",
    address: "45 Avenue du Général Leclerc", postal_code: "93500", city: "Pantin",
    region: "Île-de-France", phone: "+33 1 48 10 12 34", email: "services-est@immobiliere-centrale.fr",
    status: "active", specialties: "Gestion technique, Maintenance" },
  
  { name: "Centre de Services Lyon Métropole", code: "IMC-SVC-LY", agency_type: "service_center",
    address: "88 Rue de la Villette", postal_code: "69003", city: "Lyon",
    region: "Auvergne-Rhône-Alpes", phone: "+33 4 78 95 12 34", email: "services-lyon@immobiliere-centrale.fr",
    status: "active", specialties: "Support technique, Travaux" },
  
  { name: "Centre de Services Marseille Provence", code: "IMC-SVC-MR", agency_type: "service_center",
    address: "56 Boulevard de la Libération", postal_code: "13004", city: "Marseille",
    region: "Provence-Alpes-Côte d'Azur", phone: "+33 4 91 49 12 34", email: "services-marseille@immobiliere-centrale.fr",
    status: "active", specialties: "Gestion locative, Administration" },
  
  { name: "Centre de Services Bordeaux Aquitaine", code: "IMC-SVC-BX", agency_type: "service_center",
    address: "23 Quai des Chartrons", postal_code: "33300", city: "Bordeaux",
    region: "Nouvelle-Aquitaine", phone: "+33 5 56 52 12 34", email: "services-bordeaux@immobiliere-centrale.fr",
    status: "active", specialties: "Gestion de patrimoine, Contentieux" }
]

org1_agencies_data.each do |agency_data|
  agency = Agency.find_or_initialize_by(
    organization_id: org1.id,
    code: agency_data[:code]
  )
  agency.assign_attributes(agency_data)
  
  if agency.new_record?
    agency.save!
    puts "  ✓ Created agency: #{agency.name} (#{agency.city})"
  else
    agency.save!
    puts "  ✓ Updated agency: #{agency.name} (#{agency.city})"
  end
end

puts "\n📊 Total agencies for Organization 1: #{Agency.where(organization_id: org1.id).count}"
puts "   - Headquarters: #{Agency.where(organization_id: org1.id, agency_type: 'headquarters').count}"
puts "   - Regional Offices: #{Agency.where(organization_id: org1.id, agency_type: 'regional_office').count}"
puts "   - Local Branches: #{Agency.where(organization_id: org1.id, agency_type: 'branch').count}"
puts "   - Service Centers: #{Agency.where(organization_id: org1.id, agency_type: 'service_center').count}"

# ============================================================================
# CONTRACTS - Sample contracts for testing key indicators (Item 45)
# ============================================================================

puts "\n📄 Creating sample contracts..."

# Delete existing contracts to ensure fresh data with correct dates
puts "  Deleting existing contracts..."
Contract.delete_all
puts "  ✓ Deleted all existing contracts"

# Contract families
contract_families = [
  'Maintenance CVC',
  'Maintenance Ascenseurs',
  'Nettoyage',
  'Sécurité',
  'Électricité',
  'Contrôles Techniques',
  'Assurances'
]

# Statuses with distribution
statuses = ['active', 'active', 'active', 'active', 'active', 'pending', 'expired', 'suspended']

# Get sites for contracts
org1_sites_for_contracts = Site.where(organization_id: org1.id).limit(5).to_a
org2_sites_for_contracts = Site.where(organization_id: org2.id).limit(3).to_a

# Create contracts for Organization 1
puts "  Creating contracts for Organization 1..."
30.times do |i|
  site = org1_sites_for_contracts.sample
  family = contract_families.sample
  
  # Calculate dates with better distribution
  start_date = Date.today - rand(365..730).days
  
  # Distribute contracts across different alert windows for better visibility
  if i < 10
    # 0-30 days window (ALERTE - urgent red alerts)
    end_date = Date.today + rand(1..30).days
    status = 'active'  # Ensure these are active for alerts
  elsif i < 20
    # 31-90 days window (ATTENTION - orange warnings)
    end_date = Date.today + rand(31..90).days
    status = 'active'  # Ensure these are active for alerts
  elsif i < 25
    # 91-180 days window (safe zone)
    end_date = Date.today + rand(91..180).days
    status = 'active'
  else
    # Past expiry or far future
    if i % 2 == 0
      end_date = Date.today - rand(1..60).days  # Expired
      status = 'expired'
    else
      end_date = Date.today + rand(181..365).days  # Far future
      status = 'active'
    end
  end
  
  contract = Contract.new(
    organization_id: org1.id,
    contract_number: "CTR-2024-#{sprintf('%03d', i + 1)}",
    site_id: site.id,
    title: "Contrat #{family} - #{site.name}",
    contract_type: "Contrat de maintenance",
    contractor_organization_name: "Prestataire Maintenance",
    contract_object: "Maintenance et entretien des équipements",
    contract_family: family,
    status: status,
    annual_amount: rand(5000..150000),
    start_date: start_date,
    end_date: end_date,
    execution_start_date: start_date,
    initial_duration_months: ((end_date - start_date) / 30).to_i
  )
  contract.save!
  puts "    ✓ Created contract: #{contract.contract_number} (#{contract.contract_family}, expires: #{end_date.strftime('%d/%m/%Y')}, status: #{status})"
end

# Create contracts for Organization 2
puts "  Creating contracts for Organization 2..."
15.times do |i|
  site = org2_sites_for_contracts.sample
  family = contract_families.sample
  
  start_date = Date.today - rand(365..730).days
  
  # Distribute for better alert visibility
  if i < 5
    # 0-30 days window (ALERTE - urgent)
    end_date = Date.today + rand(1..30).days
    status = 'active'
  elsif i < 10
    # 31-90 days window (ATTENTION - warning)
    end_date = Date.today + rand(31..90).days
    status = 'active'
  elsif i < 12
    # 91-180 days window (safe zone)
    end_date = Date.today + rand(91..180).days
    status = 'active'
  else
    # Past expiry or far future
    if i % 2 == 0
      end_date = Date.today - rand(1..60).days  # Expired
      status = 'expired'
    else
      end_date = Date.today + rand(181..365).days  # Far future
      status = 'active'
    end
  end
  
  contract = Contract.new(
    organization_id: org2.id,
    contract_number: "CTR-2025-#{sprintf('%03d', i + 1)}",
    site_id: site.id,
    title: "Contrat #{family} - #{site.name}",
    contract_type: "Contrat de maintenance",
    contractor_organization_name: "Prestataire Maintenance",
    contract_object: "Maintenance et entretien des équipements",
    contract_family: family,
    status: status,
    annual_amount: rand(5000..120000),
    start_date: start_date,
    end_date: end_date,
    execution_start_date: start_date,
    initial_duration_months: ((end_date - start_date) / 30).to_i
  )
  contract.save!
  puts "    ✓ Created contract: #{contract.contract_number} (#{contract.contract_family}, expires: #{end_date.strftime('%d/%m/%Y')}, status: #{status})"
end

puts "\n📊 Total contracts created: #{Contract.count}"
puts "   - Organization 1: #{Contract.where(organization_id: org1.id).count} contracts"
puts "   - Organization 2: #{Contract.where(organization_id: org2.id).count} contracts"

# ============================================================================
# BUILDINGS, LEVELS, SPACES & EQUIPMENT - Full hierarchy for testing
# ============================================================================

puts "\n🏗️  Creating buildings, levels, spaces and equipment hierarchy..."

# Get first site from Organization 1 for detailed seed data
site_org1 = Site.where(organization_id: org1.id).first

if site_org1
  puts "\n  Creating full hierarchy for: #{site_org1.name}"
  
  # Building 1
  building1 = Building.find_or_initialize_by(
    site: site_org1,
    name: "Bâtiment A",
    code: "BAT-A"
  )
  building1.assign_attributes(
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2010,
    area: 5000,
    number_of_levels: 5,
    status: 'active',
    created_by_name: pm1.full_name,
    description: "Bâtiment principal"
  )
  if building1.new_record?
    building1.save!
    puts "    ✓ Created building: #{building1.name}"
  else
    building1.save!
  end
  
  # Level 1 - Ground Floor
  level1 = Level.find_or_initialize_by(
    building: building1,
    name: "Rez-de-chaussée"
  )
  level1.assign_attributes(
    organization_id: org1.id,
    level_number: 0,
    altitude: 0,
    area: 1000,
    created_by_name: pm1.full_name
  )
  if level1.new_record?
    level1.save!
    puts "      ✓ Created level: #{level1.name}"
  else
    level1.save!
  end
  
  # Space 1 - Office
  space1 = Space.find_or_initialize_by(
    level: level1,
    name: "Bureau 101"
  )
  space1.assign_attributes(
    organization_id: org1.id,
    space_type: "Bureau",
    area: 25.5,
    capacity: 4,
    created_by_name: pm1.full_name
  )
  if space1.new_record?
    space1.save!
    puts "        ✓ Created space: #{space1.name}"
  else
    space1.save!
  end
  
  # Equipment 1 - Air Conditioner
  equipment1 = Equipment.find_or_initialize_by(
    space: space1,
    name: "Climatiseur Daikin AC-500"
  )
  # Find the equipment type
  climatiseur_type = EquipmentType.find_by(code: 'CVC-007') # Climatiseur split system
  equipment1.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building1.id,
    level_id: level1.id,
    equipment_type_id: climatiseur_type&.id,
    manufacturer: "Daikin",
    model: "AC-500",
    serial_number: "SN123456789",
    nominal_power: 3.5,
    nominal_voltage: 230,
    current: 16,
    frequency: 50,
    weight: 45,
    dimensions: "80 x 60 x 120 cm",
    manufacturing_date: Date.new(2024, 1, 15),
    commissioning_date: Date.new(2024, 3, 1),
    warranty_end_date: Date.new(2027, 3, 1),
    next_maintenance_date: Date.new(2025, 3, 15),
    supplier: "SARL TechnoClim",
    purchase_price: 2500.00,
    order_number: "CMD-2024-123",
    invoice_number: "FAC-2024-456",
    status: "active",
    criticality: "high",
    notes: "Équipement essentiel pour le confort thermique du bureau. Maintenance préventive programmée tous les 6 mois.",
    created_by_name: pm1.full_name
  )
  if equipment1.new_record?
    equipment1.save!
    puts "          ✓ Created equipment: #{equipment1.name}"
  else
    equipment1.save!
  end
  
  # Equipment 2 - LED Lighting
  equipment2 = Equipment.find_or_initialize_by(
    space: space1,
    name: "Éclairage LED Philips X300"
  )
  # Find the equipment type
  led_type = EquipmentType.find_by(code: 'ELE-005') # Luminaire LED encastré
  equipment2.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building1.id,
    level_id: level1.id,
    equipment_type_id: led_type&.id,
    manufacturer: "Philips",
    model: "X300",
    serial_number: "SN987654321",
    nominal_power: 50,
    nominal_voltage: 230,
    commissioning_date: Date.new(2024, 3, 1),
    warranty_end_date: Date.new(2029, 3, 1),
    status: "active",
    criticality: "medium",
    created_by_name: pm1.full_name
  )
  if equipment2.new_record?
    equipment2.save!
    puts "          ✓ Created equipment: #{equipment2.name}"
  else
    equipment2.save!
  end
  
  # Space 2 - Meeting Room
  space2 = Space.find_or_initialize_by(
    level: level1,
    name: "Salle de réunion A"
  )
  space2.assign_attributes(
    organization_id: org1.id,
    space_type: "Salle de réunion",
    area: 35.0,
    capacity: 12,
    created_by_name: pm1.full_name
  )
  if space2.new_record?
    space2.save!
    puts "        ✓ Created space: #{space2.name}"
  else
    space2.save!
  end
  
  # Equipment 3 - Projector
  equipment3 = Equipment.find_or_initialize_by(
    space: space2,
    name: "Vidéoprojecteur Epson EB-2250U"
  )
  equipment3.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building1.id,
    level_id: level1.id,
    manufacturer: "Epson",
    model: "EB-2250U",
    serial_number: "SN456789123",
    commissioning_date: Date.new(2023, 9, 15),
    warranty_end_date: Date.new(2026, 9, 15),
    status: "active",
    criticality: "medium",
    created_by_name: pm1.full_name
  )
  if equipment3.new_record?
    equipment3.save!
    puts "          ✓ Created equipment: #{equipment3.name}"
  else
    equipment3.save!
  end
  
  # Space 3 - Technical Room
  space3 = Space.find_or_initialize_by(
    level: level1,
    name: "Local technique"
  )
  space3.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 15.0,
    created_by_name: pm1.full_name
  )
  if space3.new_record?
    space3.save!
    puts "        ✓ Created space: #{space3.name}"
  else
    space3.save!
  end
  
  # Equipment 4 - Boiler
  equipment4 = Equipment.find_or_initialize_by(
    space: space3,
    name: "Chaudière à gaz Viessmann V200"
  )
  # Find the equipment type
  chaudiere_type = EquipmentType.find_by(code: 'CVC-001') # Chaudière gaz murale
  equipment4.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building1.id,
    level_id: level1.id,
    equipment_type_id: chaudiere_type&.id,
    manufacturer: "Viessmann",
    model: "Vitodens 200-W",
    serial_number: "SN789123456",
    nominal_power: 35,
    commissioning_date: Date.new(2020, 11, 10),
    warranty_end_date: Date.new(2025, 11, 10),
    next_maintenance_date: Date.new(2025, 10, 1),
    status: "active",
    criticality: "critical",
    notes: "Chaudière principale pour le chauffage du bâtiment. Entretien annuel obligatoire.",
    created_by_name: pm1.full_name
  )
  if equipment4.new_record?
    equipment4.save!
    puts "          ✓ Created equipment: #{equipment4.name}"
  else
    equipment4.save!
  end
  
  # Level 2 - First Floor
  level2 = Level.find_or_initialize_by(
    building: building1,
    name: "1er étage"
  )
  level2.assign_attributes(
    organization_id: org1.id,
    level_number: 1,
    altitude: 3.5,
    area: 1000,
    created_by_name: pm1.full_name
  )
  if level2.new_record?
    level2.save!
    puts "      ✓ Created level: #{level2.name}"
  else
    level2.save!
  end
  
  # Space 4 - Open Space
  space4 = Space.find_or_initialize_by(
    level: level2,
    name: "Open Space 201"
  )
  space4.assign_attributes(
    organization_id: org1.id,
    space_type: "Bureau",
    area: 150.0,
    capacity: 30,
    created_by_name: pm1.full_name
  )
  if space4.new_record?
    space4.save!
    puts "        ✓ Created space: #{space4.name}"
  else
    space4.save!
  end
  
  # Equipment 5 - VRV System
  equipment5 = Equipment.find_or_initialize_by(
    space: space4,
    name: "Système VRV Mitsubishi Electric"
  )
  # Find the equipment type
  vrv_type = EquipmentType.find_by(code: 'CVC-008') # Climatiseur VRV/VRF
  equipment5.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building1.id,
    level_id: level2.id,
    equipment_type_id: vrv_type&.id,
    manufacturer: "Mitsubishi Electric",
    model: "VRF City Multi",
    serial_number: "SN654321789",
    nominal_power: 28,
    commissioning_date: Date.new(2022, 5, 20),
    warranty_end_date: Date.new(2027, 5, 20),
    next_maintenance_date: Date.new(2025, 5, 1),
    status: "active",
    criticality: "high",
    created_by_name: pm1.full_name
  )
  if equipment5.new_record?
    equipment5.save!
    puts "          ✓ Created equipment: #{equipment5.name}"
  else
    equipment5.save!
  end
  
  # Building 2
  building2 = Building.find_or_initialize_by(
    site: site_org1,
    name: "Bâtiment B",
    code: "BAT-B"
  )
  building2.assign_attributes(
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2015,
    area: 3000,
    number_of_levels: 3,
    status: 'active',
    created_by_name: pm1.full_name,
    description: "Bâtiment annexe"
  )
  if building2.new_record?
    building2.save!
    puts "    ✓ Created building: #{building2.name}"
  else
    building2.save!
  end
  
  # Level in Building 2
  level3 = Level.find_or_initialize_by(
    building: building2,
    name: "Rez-de-chaussée"
  )
  level3.assign_attributes(
    organization_id: org1.id,
    level_number: 0,
    area: 1000,
    created_by_name: pm1.full_name
  )
  if level3.new_record?
    level3.save!
    puts "      ✓ Created level: #{level3.name}"
  else
    level3.save!
  end
  
  # Space in Building 2
  space5 = Space.find_or_initialize_by(
    level: level3,
    name: "Accueil et réception"
  )
  space5.assign_attributes(
    organization_id: org1.id,
    space_type: "Accueil",
    area: 50.0,
    created_by_name: pm1.full_name
  )
  if space5.new_record?
    space5.save!
    puts "        ✓ Created space: #{space5.name}"
  else
    space5.save!
  end
  
  # Equipment in Building 2
  equipment6 = Equipment.find_or_initialize_by(
    space: space5,
    name: "Système de contrôle d'accès Salto"
  )
  # Find the equipment type
  access_control_type = EquipmentType.find_by(code: 'SEC-008') # Centrale de contrôle d'accès
  equipment6.assign_attributes(
    organization_id: org1.id,
    site_id: site_org1.id,
    building_id: building2.id,
    level_id: level3.id,
    equipment_type_id: access_control_type&.id,
    manufacturer: "Salto",
    model: "KS Series",
    serial_number: "SN321654987",
    commissioning_date: Date.new(2023, 2, 10),
    warranty_end_date: Date.new(2028, 2, 10),
    status: "active",
    criticality: "high",
    created_by_name: pm1.full_name
  )
  if equipment6.new_record?
    equipment6.save!
    puts "          ✓ Created equipment: #{equipment6.name}"
  else
    equipment6.save!
  end
end


puts "\n📊 Hierarchy Summary (Initial):"
puts "   - Buildings: #{Building.count}"
puts "   - Levels: #{Level.count}"
puts "   - Spaces: #{Space.count}"
puts "   - Equipment: #{Equipment.count}"

# ============================================================================
# ADDITIONAL EQUIPMENT FOR SITE MANAGER'S ASSIGNED SITES
# ============================================================================

puts "\n🔧 Creating additional equipment for Site Manager 1's assigned sites..."

# Get the first 5 sites for Site Manager 1 (already assigned in site assignments section)
sm1_sites = Site.where(organization_id: org1.id).order(:name).limit(5).to_a

# SITE 2: Campus La Défense
if sm1_sites.length > 1
  site2 = sm1_sites[1]
  puts "\n  Building hierarchy for: #{site2.name}"
  
  # Building
  building2_1 = Building.find_or_initialize_by(site: site2, code: "CLD-A")
  building2_1.assign_attributes(
    name: "Tour Nord",
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2018,
    area: 8500,
    number_of_levels: 10,
    status: 'active',
    created_by_name: pm1.full_name
  )
  building2_1.save! if building2_1.changed?
  puts "    ✓ Building: #{building2_1.name}"
  
  # Level 0
  level2_1 = Level.find_or_initialize_by(building: building2_1, level_number: 0)
  level2_1.assign_attributes(
    name: "Rez-de-chaussée",
    organization_id: org1.id,
    area: 850,
    created_by_name: pm1.full_name
  )
  level2_1.save! if level2_1.changed?
  
  # Lobby Space
  space2_1 = Space.find_or_initialize_by(level: level2_1, name: "Hall d'accueil")
  space2_1.assign_attributes(
    organization_id: org1.id,
    space_type: "Accueil",
    area: 120,
    created_by_name: pm1.full_name
  )
  space2_1.save! if space2_1.changed?
  
  # Equipment 1: Access Control System
  eq2_1 = Equipment.find_or_initialize_by(space: space2_1, name: "Système contrôle d'accès Honeywell")
  access_control_type = EquipmentType.find_by(code: 'SEC-008')
  eq2_1.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    equipment_type_id: access_control_type&.id,
    manufacturer: "Honeywell", model: "Pro-Watch", serial_number: "HW-CLD-001",
    commissioning_date: Date.new(2023, 6, 1),
    warranty_end_date: Date.new(2026, 6, 1),
    next_maintenance_date: Date.new(2025, 4, 15),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq2_1.save! if eq2_1.changed?
  puts "      ✓ Equipment: #{eq2_1.name}"
  
  # Equipment 2: CCTV System
  eq2_2 = Equipment.find_or_initialize_by(space: space2_1, name: "Système vidéosurveillance Hikvision")
  eq2_2.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    manufacturer: "Hikvision", model: "DS-7732NI-K4", serial_number: "HK-CLD-001",
    commissioning_date: Date.new(2023, 6, 1),
    warranty_end_date: Date.new(2026, 6, 1),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq2_2.save! if eq2_2.changed?
  puts "      ✓ Equipment: #{eq2_2.name}"
  
  # Technical Room Space
  space2_2 = Space.find_or_initialize_by(level: level2_1, name: "Local technique principal")
  space2_2.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 45,
    created_by_name: pm1.full_name
  )
  space2_2.save! if space2_2.changed?
  
  # Equipment 3: Main Electrical Panel
  eq2_3 = Equipment.find_or_initialize_by(space: space2_2, name: "Tableau électrique général TGBT")
  electrical_panel_type = EquipmentType.find_by(code: 'ELE-001')
  eq2_3.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    equipment_type_id: electrical_panel_type&.id,
    manufacturer: "Schneider Electric", model: "Prisma Plus", serial_number: "SE-CLD-TGBT",
    nominal_power: 630, nominal_voltage: 400,
    commissioning_date: Date.new(2018, 3, 1),
    next_maintenance_date: Date.new(2025, 3, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq2_3.save! if eq2_3.changed?
  puts "      ✓ Equipment: #{eq2_3.name}"
  
  # Equipment 4: UPS System
  eq2_4 = Equipment.find_or_initialize_by(space: space2_2, name: "Onduleur APC Smart-UPS")
  ups_type = EquipmentType.find_by(code: 'ELE-007')
  eq2_4.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    equipment_type_id: ups_type&.id,
    manufacturer: "APC", model: "Smart-UPS SRT 10kVA", serial_number: "APC-CLD-001",
    nominal_power: 10, nominal_voltage: 230,
    commissioning_date: Date.new(2020, 9, 15),
    warranty_end_date: Date.new(2025, 9, 15),
    next_maintenance_date: Date.new(2025, 6, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq2_4.save! if eq2_4.changed?
  puts "      ✓ Equipment: #{eq2_4.name}"
  
  # Level 3
  level2_2 = Level.find_or_initialize_by(building: building2_1, level_number: 3)
  level2_2.assign_attributes(
    name: "3ème étage",
    organization_id: org1.id,
    altitude: 10.5,
    area: 850,
    created_by_name: pm1.full_name
  )
  level2_2.save! if level2_2.changed?
  
  # Open Space
  space2_3 = Space.find_or_initialize_by(level: level2_2, name: "Open Space 301")
  space2_3.assign_attributes(
    organization_id: org1.id,
    space_type: "Bureau",
    area: 200,
    capacity: 40,
    created_by_name: pm1.full_name
  )
  space2_3.save! if space2_3.changed?
  
  # Equipment 5: VRV System
  eq2_5 = Equipment.find_or_initialize_by(space: space2_3, name: "Climatisation VRV Daikin")
  vrv_type = EquipmentType.find_by(code: 'CVC-008')
  eq2_5.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_2.id,
    equipment_type_id: vrv_type&.id,
    manufacturer: "Daikin", model: "VRV IV", serial_number: "DKN-CLD-VRV3",
    nominal_power: 32,
    commissioning_date: Date.new(2019, 4, 1),
    warranty_end_date: Date.new(2024, 4, 1),
    next_maintenance_date: Date.new(2025, 2, 15),
    status: "active", criticality: "high",
    notes: "Maintenance trimestrielle requise",
    created_by_name: pm1.full_name
  )
  eq2_5.save! if eq2_5.changed?
  puts "      ✓ Equipment: #{eq2_5.name}"
  
  # Equipment 6: Fire Detection Panel
  eq2_6 = Equipment.find_or_initialize_by(space: space2_3, name: "Centrale détection incendie")
  fire_detection_type = EquipmentType.find_by(code: 'SEC-001')
  eq2_6.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_2.id,
    equipment_type_id: fire_detection_type&.id,
    manufacturer: "Siemens", model: "Cerberus Pro", serial_number: "SI-CLD-FD3",
    commissioning_date: Date.new(2018, 3, 1),
    next_maintenance_date: Date.new(2025, 1, 15),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq2_6.save! if eq2_6.changed?
  puts "      ✓ Equipment: #{eq2_6.name}"
  
  # Create elevator shaft space
  space2_4 = Space.find_or_initialize_by(level: level2_1, name: "Cage ascenseurs")
  space2_4.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 10,
    created_by_name: pm1.full_name
  )
  space2_4.save! if space2_4.changed?
  
  # Elevator Equipment
  eq2_7 = Equipment.find_or_initialize_by(space: space2_4, name: "Ascenseur 1 - Otis")
  elevator_type = EquipmentType.find_by(code: 'TRA-001')
  eq2_7.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    equipment_type_id: elevator_type&.id,
    manufacturer: "Otis", model: "Gen2", serial_number: "OTIS-CLD-01",
    commissioning_date: Date.new(2018, 3, 1),
    warranty_end_date: Date.new(2028, 3, 1),
    next_maintenance_date: Date.new(2025, 1, 10),
    status: "active", criticality: "high",
    notes: "Charge: 630kg, 8 personnes, Vitesse: 1.6m/s",
    created_by_name: pm1.full_name
  )
  eq2_7.save! if eq2_7.changed?
  puts "      ✓ Equipment: #{eq2_7.name}"
  
  # Equipment 8: Elevator 2
  eq2_8 = Equipment.find_or_initialize_by(space: space2_4, name: "Ascenseur 2 - Otis")
  eq2_8.assign_attributes(
    organization_id: org1.id, site_id: site2.id, building_id: building2_1.id, level_id: level2_1.id,
    equipment_type_id: elevator_type&.id,
    manufacturer: "Otis", model: "Gen2", serial_number: "OTIS-CLD-02",
    commissioning_date: Date.new(2018, 3, 1),
    warranty_end_date: Date.new(2028, 3, 1),
    next_maintenance_date: Date.new(2025, 1, 10),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq2_8.save! if eq2_8.changed?
  puts "      ✓ Equipment: #{eq2_8.name}"
end

# SITE 3: Centre Commercial Odysseum
if sm1_sites.length > 2
  site3 = sm1_sites[2]
  puts "\n  Building hierarchy for: #{site3.name}"
  
  # Building
  building3_1 = Building.find_or_initialize_by(site: site3, code: "CCO-MAIN")
  building3_1.assign_attributes(
    name: "Galerie Principale",
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2012,
    area: 32000,
    number_of_levels: 2,
    status: 'active',
    created_by_name: pm1.full_name
  )
  building3_1.save! if building3_1.changed?
  puts "    ✓ Building: #{building3_1.name}"
  
  # Level 0
  level3_1 = Level.find_or_initialize_by(building: building3_1, level_number: 0)
  level3_1.assign_attributes(
    name: "Niveau galerie",
    organization_id: org1.id,
    area: 16000,
    created_by_name: pm1.full_name
  )
  level3_1.save! if level3_1.changed?
  
  # Central Mall Area
  space3_1 = Space.find_or_initialize_by(level: level3_1, name: "Allée centrale")
  space3_1.assign_attributes(
    organization_id: org1.id,
    space_type: "Circulation",
    area: 2000,
    created_by_name: pm1.full_name
  )
  space3_1.save! if space3_1.changed?
  
  # Equipment 1: Main HVAC System
  eq3_1 = Equipment.find_or_initialize_by(space: space3_1, name: "CTA principale galerie")
  cta_type = EquipmentType.find_by(code: 'CVC-009')
  eq3_1.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_1.id,
    equipment_type_id: cta_type&.id,
    manufacturer: "Carrier", model: "AquaForce 30XA", serial_number: "CAR-CCO-CTA1",
    nominal_power: 450,
    commissioning_date: Date.new(2012, 6, 1),
    warranty_end_date: Date.new(2017, 6, 1),
    next_maintenance_date: Date.new(2024, 12, 15),
    status: "maintenance", criticality: "critical",
    notes: "Révision complète en cours",
    created_by_name: pm1.full_name
  )
  eq3_1.save! if eq3_1.changed?
  puts "      ✓ Equipment: #{eq3_1.name}"
  
  # Equipment 2: LED Lighting System
  eq3_2 = Equipment.find_or_initialize_by(space: space3_1, name: "Système éclairage LED central")
  led_type = EquipmentType.find_by(code: 'ELE-005')
  eq3_2.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_1.id,
    equipment_type_id: led_type&.id,
    manufacturer: "Philips", model: "CoralCare LED", serial_number: "PH-CCO-LED1",
    nominal_power: 85,
    commissioning_date: Date.new(2021, 3, 1),
    warranty_end_date: Date.new(2031, 3, 1),
    status: "active", criticality: "medium",
    created_by_name: pm1.full_name
  )
  eq3_2.save! if eq3_2.changed?
  puts "      ✓ Equipment: #{eq3_2.name}"
  
  # Technical Room
  space3_2 = Space.find_or_initialize_by(level: level3_1, name: "Local technique climatisation")
  space3_2.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 80,
    created_by_name: pm1.full_name
  )
  space3_2.save! if space3_2.changed?
  
  # Equipment 3: Chiller
  eq3_3 = Equipment.find_or_initialize_by(space: space3_2, name: "Groupe froid Carrier")
  chiller_type = EquipmentType.find_by(code: 'CVC-010')
  eq3_3.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_1.id,
    equipment_type_id: chiller_type&.id,
    manufacturer: "Carrier", model: "30RB", serial_number: "CAR-CCO-CH1",
    nominal_power: 380,
    commissioning_date: Date.new(2012, 6, 1),
    next_maintenance_date: Date.new(2025, 3, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq3_3.save! if eq3_3.changed?
  puts "      ✓ Equipment: #{eq3_3.name}"
  
  # Equipment 4: Generator
  eq3_4 = Equipment.find_or_initialize_by(space: space3_2, name: "Groupe électrogène Caterpillar")
  generator_type = EquipmentType.find_by(code: 'ELE-006')
  eq3_4.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_1.id,
    equipment_type_id: generator_type&.id,
    manufacturer: "Caterpillar", model: "C18", serial_number: "CAT-CCO-GE1",
    nominal_power: 500,
    commissioning_date: Date.new(2012, 6, 1),
    next_maintenance_date: Date.new(2025, 2, 1),
    status: "active", criticality: "high",
    notes: "Test mensuel obligatoire",
    created_by_name: pm1.full_name
  )
  eq3_4.save! if eq3_4.changed?
  puts "      ✓ Equipment: #{eq3_4.name}"
  
  # Parking Level
  level3_2 = Level.find_or_initialize_by(building: building3_1, level_number: -1)
  level3_2.assign_attributes(
    name: "Parking -1",
    organization_id: org1.id,
    altitude: -3,
    area: 16000,
    created_by_name: pm1.full_name
  )
  level3_2.save! if level3_2.changed?
  
  # Parking Space
  space3_3 = Space.find_or_initialize_by(level: level3_2, name: "Zone parking A")
  space3_3.assign_attributes(
    organization_id: org1.id,
    space_type: "Parking",
    area: 4000,
    capacity: 200,
    created_by_name: pm1.full_name
  )
  space3_3.save! if space3_3.changed?
  
  # Equipment 5: Parking Ventilation
  eq3_5 = Equipment.find_or_initialize_by(space: space3_3, name: "Ventilation parking - Extracteur 1")
  ventilation_type = EquipmentType.find_by(code: 'CVC-011')
  eq3_5.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_2.id,
    equipment_type_id: ventilation_type&.id,
    manufacturer: "Soler & Palau", model: "CJTHT", serial_number: "SP-CCO-V1",
    nominal_power: 15,
    commissioning_date: Date.new(2012, 6, 1),
    next_maintenance_date: Date.new(2025, 4, 1),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq3_5.save! if eq3_5.changed?
  puts "      ✓ Equipment: #{eq3_5.name}"
  
  # Equipment 6: Fire Sprinkler System
  eq3_6 = Equipment.find_or_initialize_by(space: space3_3, name: "Système sprinkler parking")
  sprinkler_type = EquipmentType.find_by(code: 'SEC-002')
  eq3_6.assign_attributes(
    organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_2.id,
    equipment_type_id: sprinkler_type&.id,
    manufacturer: "Viking", model: "VK500", serial_number: "VIK-CCO-SP1",
    commissioning_date: Date.new(2012, 6, 1),
    next_maintenance_date: Date.new(2025, 6, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq3_6.save! if eq3_6.changed?
  puts "      ✓ Equipment: #{eq3_6.name}"
  
  # Create space for escalators
  space3_4 = Space.find_or_initialize_by(level: level3_1, name: "Zone escalators")
  space3_4.assign_attributes(
    organization_id: org1.id,
    space_type: "Circulation",
    area: 30,
    created_by_name: pm1.full_name
  )
  space3_4.save! if space3_4.changed?
  
  # Equipment 7-10: Escalators
  4.times do |i|
    eq_esc = Equipment.find_or_initialize_by(space: space3_4, name: "Escalator #{i+1}")
    escalator_type = EquipmentType.find_by(code: 'TRA-002')
    eq_esc.assign_attributes(
      organization_id: org1.id, site_id: site3.id, building_id: building3_1.id, level_id: level3_1.id,
      equipment_type_id: escalator_type&.id,
      manufacturer: "Schindler", model: "9300 AE", serial_number: "SCH-CCO-ESC#{i+1}",
      commissioning_date: Date.new(2012, 6, 1),
      next_maintenance_date: Date.new(2025, 2, 15),
      status: "active", criticality: "high",
      created_by_name: pm1.full_name
    )
    eq_esc.save! if eq_esc.changed?
  end
  puts "      ✓ Equipment: 4 Escalators"
end

# SITE 4: Site Industriel Lyon Nord
if sm1_sites.length > 3
  site4 = sm1_sites[3]
  puts "\n  Building hierarchy for: #{site4.name}"
  
  # Building
  building4_1 = Building.find_or_initialize_by(site: site4, code: "SIL-PROD")
  building4_1.assign_attributes(
    name: "Atelier de production",
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2005,
    area: 22500,
    number_of_levels: 1,
    status: 'active',
    created_by_name: pm1.full_name
  )
  building4_1.save! if building4_1.changed?
  puts "    ✓ Building: #{building4_1.name}"
  
  # Level 0 - Production Floor
  level4_1 = Level.find_or_initialize_by(building: building4_1, level_number: 0)
  level4_1.assign_attributes(
    name: "Niveau production",
    organization_id: org1.id,
    area: 22500,
    created_by_name: pm1.full_name
  )
  level4_1.save! if level4_1.changed?
  
  # Production Zone
  space4_1 = Space.find_or_initialize_by(level: level4_1, name: "Zone production A")
  space4_1.assign_attributes(
    organization_id: org1.id,
    space_type: "Production",
    area: 8000,
    created_by_name: pm1.full_name
  )
  space4_1.save! if space4_1.changed?
  
  # Equipment 1: Compressed Air System
  eq4_1 = Equipment.find_or_initialize_by(space: space4_1, name: "Compresseur air Atlas Copco")
  compressor_type = EquipmentType.find_by(code: 'IND-001')
  eq4_1.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    equipment_type_id: compressor_type&.id,
    manufacturer: "Atlas Copco", model: "GA 75", serial_number: "AC-SIL-C1",
    nominal_power: 75,
    commissioning_date: Date.new(2015, 9, 1),
    warranty_end_date: Date.new(2020, 9, 1),
    next_maintenance_date: Date.new(2024, 12, 20),
    status: "maintenance", criticality: "critical",
    notes: "Révision 8000h en cours",
    created_by_name: pm1.full_name
  )
  eq4_1.save! if eq4_1.changed?
  puts "      ✓ Equipment: #{eq4_1.name}"
  
  # Equipment 2: Bridge Crane
  eq4_2 = Equipment.find_or_initialize_by(space: space4_1, name: "Pont roulant 10T")
  eq4_2.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    manufacturer: "Konecranes", model: "CXT", serial_number: "KC-SIL-PR1",
    commissioning_date: Date.new(2010, 12, 1),
    next_maintenance_date: Date.new(2025, 1, 15),
    status: "active", criticality: "high",
    notes: "Capacité 10 tonnes, portée 15m",
    created_by_name: pm1.full_name
  )
  eq4_2.save! if eq4_2.changed?
  puts "      ✓ Equipment: #{eq4_2.name}"
  
  # Equipment 3: Industrial Ventilation
  eq4_3 = Equipment.find_or_initialize_by(space: space4_1, name: "Ventilation industrielle zone A")
  eq4_3.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    manufacturer: "Soler & Palau", model: "CJHTD", serial_number: "SP-SIL-V1",
    nominal_power: 45,
    commissioning_date: Date.new(2015, 3, 1),
    next_maintenance_date: Date.new(2025, 3, 15),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq4_3.save! if eq4_3.changed?
  puts "      ✓ Equipment: #{eq4_3.name}"
  
  # Technical Space
  space4_2 = Space.find_or_initialize_by(level: level4_1, name: "Local transformateur")
  space4_2.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 50,
    created_by_name: pm1.full_name
  )
  space4_2.save! if space4_2.changed?
  
  # Equipment 4: Transformer
  eq4_4 = Equipment.find_or_initialize_by(space: space4_2, name: "Transformateur HT/BT 1000kVA")
  transformer_type = EquipmentType.find_by(code: 'ELE-002')
  eq4_4.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    equipment_type_id: transformer_type&.id,
    manufacturer: "Schneider Electric", model: "Trihal", serial_number: "SE-SIL-TR1",
    nominal_power: 1000, nominal_voltage: 20000,
    commissioning_date: Date.new(2005, 11, 1),
    next_maintenance_date: Date.new(2025, 11, 1),
    status: "active", criticality: "critical",
    notes: "Transformateur principal 20kV/400V",
    created_by_name: pm1.full_name
  )
  eq4_4.save! if eq4_4.changed?
  puts "      ✓ Equipment: #{eq4_4.name}"
  
  # Equipment 5: Fire Safety System
  eq4_5 = Equipment.find_or_initialize_by(space: space4_1, name: "Système détection incendie zone production")
  fire_det_type = EquipmentType.find_by(code: 'SEC-001')
  eq4_5.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    equipment_type_id: fire_det_type&.id,
    manufacturer: "Siemens", model: "Cerberus Fit", serial_number: "SI-SIL-FD1",
    commissioning_date: Date.new(2015, 3, 1),
    next_maintenance_date: Date.new(2025, 2, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq4_5.save! if eq4_5.changed?
  puts "      ✓ Equipment: #{eq4_5.name}"
  
  # Create loading dock space for door
  space4_3 = Space.find_or_initialize_by(level: level4_1, name: "Quai de chargement")
  space4_3.assign_attributes(
    organization_id: org1.id,
    space_type: "Logistique",
    area: 100,
    created_by_name: pm1.full_name
  )
  space4_3.save! if space4_3.changed?
  
  # Equipment 6: Industrial Overhead Door
  eq4_6 = Equipment.find_or_initialize_by(space: space4_3, name: "Porte sectionnelle industrielle")
  eq4_6.assign_attributes(
    organization_id: org1.id, site_id: site4.id, building_id: building4_1.id, level_id: level4_1.id,
    manufacturer: "Hörmann", model: "SPU F42", serial_number: "HOR-SIL-PD1",
    commissioning_date: Date.new(2010, 5, 1),
    next_maintenance_date: Date.new(2025, 5, 1),
    status: "active", criticality: "medium",
    notes: "Porte motorisée 5m x 4m",
    created_by_name: pm1.full_name
  )
  eq4_6.save! if eq4_6.changed?
  puts "      ✓ Equipment: #{eq4_6.name}"
end

# SITE 5: Résidence Le Parc
if sm1_sites.length > 4
  site5 = sm1_sites[4]
  puts "\n  Building hierarchy for: #{site5.name}"
  
  # Building
  building5_1 = Building.find_or_initialize_by(site: site5, code: "RLP-MAIN")
  building5_1.assign_attributes(
    name: "Bâtiment Résidentiel",
    organization_id: org1.id,
    user_id: pm1.id,
    construction_year: 2019,
    area: 6250,
    number_of_levels: 8,
    status: 'active',
    created_by_name: pm1.full_name
  )
  building5_1.save! if building5_1.changed?
  puts "    ✓ Building: #{building5_1.name}"
  
  # Level 0 - Ground Floor
  level5_1 = Level.find_or_initialize_by(building: building5_1, level_number: 0)
  level5_1.assign_attributes(
    name: "Rez-de-chaussée",
    organization_id: org1.id,
    area: 780,
    created_by_name: pm1.full_name
  )
  level5_1.save! if level5_1.changed?
  
  # Entrance Hall
  space5_1 = Space.find_or_initialize_by(level: level5_1, name: "Hall d'entrée")
  space5_1.assign_attributes(
    organization_id: org1.id,
    space_type: "Accueil",
    area: 80,
    created_by_name: pm1.full_name
  )
  space5_1.save! if space5_1.changed?
  
  # Equipment 1: Intercom System
  eq5_1 = Equipment.find_or_initialize_by(space: space5_1, name: "Interphone vidéo Aiphone")
  eq5_1.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    manufacturer: "Aiphone", model: "GT Series", serial_number: "AIP-RLP-001",
    commissioning_date: Date.new(2019, 11, 1),
    warranty_end_date: Date.new(2024, 11, 1),
    next_maintenance_date: Date.new(2025, 11, 1),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq5_1.save! if eq5_1.changed?
  puts "      ✓ Equipment: #{eq5_1.name}"
  
  # Equipment 2: Access Control
  eq5_2 = Equipment.find_or_initialize_by(space: space5_1, name: "Contrôle d'accès résidentiel")
  access_ctrl_type = EquipmentType.find_by(code: 'SEC-008')
  eq5_2.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    equipment_type_id: access_ctrl_type&.id,
    manufacturer: "Came", model: "BPT Perla", serial_number: "CAME-RLP-001",
    commissioning_date: Date.new(2019, 11, 1),
    warranty_end_date: Date.new(2024, 11, 1),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq5_2.save! if eq5_2.changed?
  puts "      ✓ Equipment: #{eq5_2.name}"
  
  # Technical Room
  space5_2 = Space.find_or_initialize_by(level: level5_1, name: "Local technique")
  space5_2.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 25,
    created_by_name: pm1.full_name
  )
  space5_2.save! if space5_2.changed?
  
  # Equipment 3: Heating System
  eq5_3 = Equipment.find_or_initialize_by(space: space5_2, name: "Chaudière collective Frisquet")
  boiler_type = EquipmentType.find_by(code: 'CVC-001')
  eq5_3.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    equipment_type_id: boiler_type&.id,
    manufacturer: "Frisquet", model: "Hydromotrix", serial_number: "FRQ-RLP-001",
    nominal_power: 120,
    commissioning_date: Date.new(2019, 10, 1),
    warranty_end_date: Date.new(2024, 10, 1),
    next_maintenance_date: Date.new(2025, 10, 1),
    status: "active", criticality: "critical",
    notes: "Chaudière gaz collective pour chauffage central",
    created_by_name: pm1.full_name
  )
  eq5_3.save! if eq5_3.changed?
  puts "      ✓ Equipment: #{eq5_3.name}"
  
  # Equipment 4: Domestic Hot Water System
  eq5_4 = Equipment.find_or_initialize_by(space: space5_2, name: "Ballon eau chaude sanitaire")
  eq5_4.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    manufacturer: "Atlantic", model: "Chauffeo Plus", serial_number: "ATL-RLP-001",
    commissioning_date: Date.new(2019, 10, 1),
    warranty_end_date: Date.new(2026, 10, 1),
    next_maintenance_date: Date.new(2025, 4, 1),
    status: "active", criticality: "high",
    notes: "Capacité 300L, résidence 45 logements",
    created_by_name: pm1.full_name
  )
  eq5_4.save! if eq5_4.changed?
  puts "      ✓ Equipment: #{eq5_4.name}"
  
  # Equipment 5: Ventilation System
  eq5_5 = Equipment.find_or_initialize_by(space: space5_2, name: "VMC double flux collective")
  ventilation_type = EquipmentType.find_by(code: 'CVC-011')
  eq5_5.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    equipment_type_id: ventilation_type&.id,
    manufacturer: "France Air", model: "Températion", serial_number: "FA-RLP-VMC1",
    nominal_power: 8,
    commissioning_date: Date.new(2019, 10, 1),
    warranty_end_date: Date.new(2024, 10, 1),
    next_maintenance_date: Date.new(2025, 3, 1),
    status: "active", criticality: "high",
    created_by_name: pm1.full_name
  )
  eq5_5.save! if eq5_5.changed?
  puts "      ✓ Equipment: #{eq5_5.name}"
  
  # Create elevator shaft space
  space5_4 = Space.find_or_initialize_by(level: level5_1, name: "Cage ascenseur")
  space5_4.assign_attributes(
    organization_id: org1.id,
    space_type: "Local technique",
    area: 5,
    created_by_name: pm1.full_name
  )
  space5_4.save! if space5_4.changed?
  
  # Elevator
  eq5_6 = Equipment.find_or_initialize_by(space: space5_4, name: "Ascenseur résidentiel Schindler")
  elevator_type = EquipmentType.find_by(code: 'TRA-001')
  eq5_6.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_1.id,
    equipment_type_id: elevator_type&.id,
    manufacturer: "Schindler", model: "3300", serial_number: "SCH-RLP-01",
    commissioning_date: Date.new(2019, 10, 1),
    warranty_end_date: Date.new(2029, 10, 1),
    next_maintenance_date: Date.new(2025, 2, 1),
    status: "active", criticality: "critical",
    notes: "Capacité 630kg, 8 personnes, dessert 8 niveaux",
    created_by_name: pm1.full_name
  )
  eq5_6.save! if eq5_6.changed?
  puts "      ✓ Equipment: #{eq5_6.name}"
  
  # Level -1 - Parking
  level5_2 = Level.find_or_initialize_by(building: building5_1, level_number: -1)
  level5_2.assign_attributes(
    name: "Parking sous-sol",
    organization_id: org1.id,
    altitude: -3,
    area: 1250,
    created_by_name: pm1.full_name
  )
  level5_2.save! if level5_2.changed?
  
  # Parking Space
  space5_3 = Space.find_or_initialize_by(level: level5_2, name: "Parking résidents")
  space5_3.assign_attributes(
    organization_id: org1.id,
    space_type: "Parking",
    area: 1000,
    capacity: 50,
    created_by_name: pm1.full_name
  )
  space5_3.save! if space5_3.changed?
  
  # Equipment 7: Parking Ventilation
  eq5_7 = Equipment.find_or_initialize_by(space: space5_3, name: "Extraction parking résidentiel")
  eq5_7.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_2.id,
    manufacturer: "Soler & Palau", model: "TD-500", serial_number: "SP-RLP-V1",
    nominal_power: 3,
    commissioning_date: Date.new(2019, 10, 1),
    next_maintenance_date: Date.new(2025, 10, 1),
    status: "active", criticality: "medium",
    created_by_name: pm1.full_name
  )
  eq5_7.save! if eq5_7.changed?
  puts "      ✓ Equipment: #{eq5_7.name}"
  
  # Equipment 8: Fire Safety in Parking
  eq5_8 = Equipment.find_or_initialize_by(space: space5_3, name: "Détection incendie parking")
  fire_type = EquipmentType.find_by(code: 'SEC-001')
  eq5_8.assign_attributes(
    organization_id: org1.id, site_id: site5.id, building_id: building5_1.id, level_id: level5_2.id,
    equipment_type_id: fire_type&.id,
    manufacturer: "Honeywell", model: "Morley-IAS", serial_number: "HON-RLP-FD1",
    commissioning_date: Date.new(2019, 10, 1),
    next_maintenance_date: Date.new(2025, 4, 1),
    status: "active", criticality: "critical",
    created_by_name: pm1.full_name
  )
  eq5_8.save! if eq5_8.changed?
  puts "      ✓ Equipment: #{eq5_8.name}"
end

puts "\n📊 Final Equipment Summary:"
puts "   - Total Buildings: #{Building.count}"
puts "   - Total Levels: #{Level.count}"
puts "   - Total Spaces: #{Space.count}"
puts "   - Total Equipment: #{Equipment.count}"
puts "   - Equipment for Site Manager 1's sites: #{Equipment.where(site_id: sm1_sites.pluck(:id)).count}"

# ============================================================================
# PRICE REFERENCES - Sample price reference data for comparisons
# ============================================================================

puts "\n💰 Creating price references..."

price_references_data = [
  # Maintenance CVC
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance CVC', equipment_type: 'Climatisation', service_type: 'Service Annuel', 
    technical_characteristics: 'Puissance: 10kW, Couverture: 200m², Fréquence: Trimestrielle', 
    reference_price: 1200.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Basé sur une étude de marché réalisée au T1 2025. Inclut les conditions standard de contrat de maintenance.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance CVC', equipment_type: 'Chaudière Gaz', service_type: 'Entretien Annuel', 
    technical_characteristics: 'Puissance: 35kW, Type: Murale, Combustible: Gaz naturel', 
    reference_price: 850.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Prix incluant ramonage et certificat de conformité.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance CVC', equipment_type: 'Système VRV', service_type: 'Maintenance Complète', 
    technical_characteristics: 'Puissance: 28kW, Type: Multi-split, Unités: 8 intérieures', 
    reference_price: 2800.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Maintenance trimestrielle avec nettoyage filtres et contrôle fluides.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance CVC', equipment_type: 'Centrale de Traitement d\'Air', service_type: 'Service Bi-Annuel', 
    technical_characteristics: 'Débit: 5000 m³/h, Filtration F7', 
    reference_price: 1650.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'La Défense',
    notes: 'Inclut remplacement des filtres.', status: 'active' },
  
  # Maintenance Ascenseurs
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance Ascenseurs', equipment_type: 'Ascenseur Passagers', service_type: 'Inspection Trimestrielle', 
    technical_characteristics: 'Capacité: 8 personnes, Vitesse: 1m/s, Arrêts: 5', 
    reference_price: 850.00, unit: 'per_quarter', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Conforme aux normes EN 81-20. Dépannage d\'urgence 24/7 inclus.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance Ascenseurs', equipment_type: 'Ascenseur Passagers', service_type: 'Maintenance Standard', 
    technical_characteristics: 'Capacité: 6 personnes, Vitesse: 0.63m/s, Arrêts: 4', 
    reference_price: 2400.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Interventions mensuelles, pièces détachées incluses.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance Ascenseurs', equipment_type: 'Monte-Charge', service_type: 'Service Annuel', 
    technical_characteristics: 'Charge utile: 500kg, Course: 12m', 
    reference_price: 1800.00, unit: 'per_year', currency: 'EUR', location: 'Provence-Alpes', city: 'Marseille',
    notes: 'Visite technique bi-annuelle.', status: 'active' },
  
  # Contrôle Technique - Sécurité Incendie
  { contract_family: 'Contrôle Technique', contract_sub_family: 'Sécurité Incendie', equipment_type: 'Extincteurs', service_type: 'Inspection Annuelle', 
    technical_characteristics: 'Type: Poudre ABC, Capacité: 6kg, Quantité: jusqu\'à 20 unités', 
    reference_price: 450.00, unit: 'per_year', currency: 'EUR', location: 'Provence-Alpes', city: 'Marseille',
    notes: 'Vérification réglementaire annuelle et remplacement si nécessaire.', status: 'active' },
  
  { contract_family: 'Contrôle Technique', contract_sub_family: 'Sécurité Incendie', equipment_type: 'Système de Détection Incendie', service_type: 'Maintenance Semestrielle', 
    technical_characteristics: 'Type: Adressable, Détecteurs: 50, Centrales: 2', 
    reference_price: 1200.00, unit: 'per_semester', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Test fonctionnel complet avec rapport.', status: 'active' },
  
  { contract_family: 'Contrôle Technique', contract_sub_family: 'Sécurité Incendie', equipment_type: 'Portes Coupe-Feu', service_type: 'Vérification Annuelle', 
    technical_characteristics: 'Nombre: 15 portes, Type: EI 60/90', 
    reference_price: 650.00, unit: 'per_year', currency: 'EUR', location: 'Auvergne-Rhône-Alpes', city: 'Lyon',
    notes: 'Vérification des mécanismes de fermeture et joints.', status: 'active' },
  
  # Nettoyage
  { contract_family: 'Nettoyage', contract_sub_family: 'Nettoyage Bureaux', equipment_type: 'Bureaux Standards', service_type: 'Nettoyage Quotidien', 
    technical_characteristics: 'Surface: 1000m², Fréquence: 5j/7', 
    reference_price: 2800.00, unit: 'per_month', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Produits écologiques inclus.', status: 'active' },
  
  { contract_family: 'Nettoyage', contract_sub_family: 'Nettoyage Vitres', equipment_type: 'Façades Vitrées', service_type: 'Nettoyage Trimestriel', 
    technical_characteristics: 'Surface: 500m² de vitrage', 
    reference_price: 1500.00, unit: 'per_quarter', currency: 'EUR', location: 'Île-de-France', city: 'La Défense',
    notes: 'Intervention par cordistes certifiés.', status: 'active' },
  
  # Électricité
  { contract_family: 'Maintenance', contract_sub_family: 'Électricité', equipment_type: 'Tableau Électrique', service_type: 'Vérification Annuelle', 
    technical_characteristics: 'Type: TGBT 400A, Protection différentielle', 
    reference_price: 850.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Thermographie infrarouge incluse.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Électricité', equipment_type: 'Groupe Électrogène', service_type: 'Maintenance Semestrielle', 
    technical_characteristics: 'Puissance: 100kVA, Type: Diesel', 
    reference_price: 1600.00, unit: 'per_semester', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Test de charge et vidange inclus.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Électricité', equipment_type: 'Onduleur', service_type: 'Maintenance Annuelle', 
    technical_characteristics: 'Puissance: 10kVA, Type: Online', 
    reference_price: 950.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Vérification batteries et capacités.', status: 'active' },
  
  # Sécurité
  { contract_family: 'Sécurité', contract_sub_family: 'Vidéosurveillance', equipment_type: 'Système CCTV', service_type: 'Maintenance Trimestrielle', 
    technical_characteristics: 'Caméras: 20, Enregistreur: 16 voies, Stockage: 30j', 
    reference_price: 800.00, unit: 'per_quarter', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Nettoyage optiques et vérification enregistrements.', status: 'active' },
  
  { contract_family: 'Sécurité', contract_sub_family: 'Contrôle d\'Accès', equipment_type: 'Badges et Lecteurs', service_type: 'Maintenance Semestrielle', 
    technical_characteristics: 'Lecteurs: 15, Centrale: 1, Utilisateurs: 200', 
    reference_price: 650.00, unit: 'per_semester', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Mise à jour logicielle incluse.', status: 'active' },
  
  { contract_family: 'Sécurité', contract_sub_family: 'Alarme Intrusion', equipment_type: 'Centrale d\'Alarme', service_type: 'Vérification Annuelle', 
    technical_characteristics: 'Zones: 32, Détecteurs: 40, Transmetteur GSM', 
    reference_price: 450.00, unit: 'per_year', currency: 'EUR', location: 'Provence-Alpes', city: 'Nice',
    notes: 'Test complet avec télésurveillance.', status: 'active' },
  
  # Assurances
  { contract_family: 'Assurance', contract_sub_family: 'Assurance Dommages', equipment_type: 'Immeuble de Bureaux', service_type: 'Couverture Annuelle', 
    technical_characteristics: 'Surface: 5000m², Valeur: 5M€', 
    reference_price: 12000.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'Tous risques construction - Franchise 5000€.', status: 'active' },
  
  { contract_family: 'Assurance', contract_sub_family: 'Responsabilité Civile', equipment_type: 'Copropriété', service_type: 'Couverture Annuelle', 
    technical_characteristics: 'Lots: 50, Usage: Résidentiel', 
    reference_price: 3500.00, unit: 'per_year', currency: 'EUR', location: 'Île-de-France', city: 'Paris',
    notes: 'RC syndic et copropriété.', status: 'active' },
  
  # Regional variations
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance CVC', equipment_type: 'Climatisation', service_type: 'Service Annuel', 
    technical_characteristics: 'Puissance: 10kW, Couverture: 200m², Fréquence: Trimestrielle', 
    reference_price: 950.00, unit: 'per_year', currency: 'EUR', location: 'Occitanie', city: 'Toulouse',
    notes: 'Prix adapté au marché régional.', status: 'active' },
  
  { contract_family: 'Maintenance', contract_sub_family: 'Maintenance Ascenseurs', equipment_type: 'Ascenseur Passagers', service_type: 'Maintenance Standard', 
    technical_characteristics: 'Capacité: 6 personnes, Vitesse: 0.63m/s, Arrêts: 4', 
    reference_price: 2100.00, unit: 'per_year', currency: 'EUR', location: 'Auvergne-Rhône-Alpes', city: 'Lyon',
    notes: 'Tarif régional Lyon.', status: 'active' },
  
  { contract_family: 'Nettoyage', contract_sub_family: 'Nettoyage Bureaux', equipment_type: 'Bureaux Standards', service_type: 'Nettoyage Quotidien', 
    technical_characteristics: 'Surface: 1000m², Fréquence: 5j/7', 
    reference_price: 2200.00, unit: 'per_month', currency: 'EUR', location: 'Nouvelle-Aquitaine', city: 'Bordeaux',
    notes: 'Prix province, produits écologiques.', status: 'active' },
  
  { contract_family: 'Contrôle Technique', contract_sub_family: 'Sécurité Incendie', equipment_type: 'Extincteurs', service_type: 'Inspection Annuelle', 
    technical_characteristics: 'Type: Poudre ABC, Capacité: 6kg, Quantité: jusqu\'à 20 unités', 
    reference_price: 380.00, unit: 'per_year', currency: 'EUR', location: 'Bretagne', city: 'Rennes',
    notes: 'Tarif adapté marché breton.', status: 'active' }
]

price_references_data.each do |pr_data|
  pr = PriceReference.find_or_initialize_by(
    contract_family: pr_data[:contract_family],
    contract_sub_family: pr_data[:contract_sub_family],
    equipment_type: pr_data[:equipment_type],
    service_type: pr_data[:service_type],
    location: pr_data[:location]
  )
  pr.assign_attributes(pr_data)
  
  if pr.new_record?
    pr.save!
    puts "  ✓ Created price reference: #{pr.contract_family} - #{pr.equipment_type} (#{pr.location})"
  else
    pr.save!
  end
end

puts "\n📊 Total price references created: #{PriceReference.count}"
puts "   - Contract families: #{PriceReference.distinct.count(:contract_family)}"
puts "   - Locations: #{PriceReference.where.not(location: nil).distinct.count(:location)}"

# ============================================================================
# ACTIVE SESSIONS - User connection data for analytics
# ============================================================================

puts "\n🔗 Creating active sessions for analytics..."

# Delete existing sessions to ensure fresh data
puts "  Deleting existing active sessions..."
ActiveSession.delete_all
puts "  ✓ Deleted all existing active sessions"

# Get users for both organizations
org1_users = User.where(organization_id: org1.id, status: 'active').to_a
org2_users = User.where(organization_id: org2.id, status: 'active').to_a

# Helper method to create sessions
def create_session_for_user(user, created_at, last_activity_at = nil)
  session = ActiveSession.new(
    user: user,
    session_id: SecureRandom.hex(32),
    created_at: created_at,
    last_activity_at: last_activity_at || created_at
  )
  session.save!
  session
end

# Create sessions for Organization 1 users
puts "  Creating sessions for Organization 1 users..."

# Sessions this week (last 7 days)
15.times do |i|
  user = org1_users.sample
  days_ago = rand(0..6)
  hours_ago = rand(0..23)
  created_at = Time.current - days_ago.days - hours_ago.hours
  last_activity = created_at + rand(5..120).minutes
  
  create_session_for_user(user, created_at, last_activity)
end

# Sessions this month but not this week (7-30 days ago)
20.times do |i|
  user = org1_users.sample
  days_ago = rand(7..29)
  hours_ago = rand(0..23)
  created_at = Time.current - days_ago.days - hours_ago.hours
  last_activity = created_at + rand(5..120).minutes
  
  create_session_for_user(user, created_at, last_activity)
end

# Some older sessions (for historical data)
10.times do |i|
  user = org1_users.sample
  days_ago = rand(31..60)
  created_at = Time.current - days_ago.days
  
  create_session_for_user(user, created_at)
end

puts "  ✓ Created #{ActiveSession.joins(:user).where(users: { organization_id: org1.id }).count} sessions for Organization 1"

# Create sessions for Organization 2 users
puts "  Creating sessions for Organization 2 users..."

# Sessions this week (last 7 days)
10.times do |i|
  user = org2_users.sample
  days_ago = rand(0..6)
  hours_ago = rand(0..23)
  created_at = Time.current - days_ago.days - hours_ago.hours
  last_activity = created_at + rand(5..120).minutes
  
  create_session_for_user(user, created_at, last_activity)
end

# Sessions this month but not this week (7-30 days ago)
12.times do |i|
  user = org2_users.sample
  days_ago = rand(7..29)
  hours_ago = rand(0..23)
  created_at = Time.current - days_ago.days - hours_ago.hours
  last_activity = created_at + rand(5..120).minutes
  
  create_session_for_user(user, created_at, last_activity)
end

puts "  ✓ Created #{ActiveSession.joins(:user).where(users: { organization_id: org2.id }).count} sessions for Organization 2"

puts "\n📊 Total active sessions created: #{ActiveSession.count}"
puts "   - Organization 1 (this week): #{ActiveSession.joins(:user).where(users: { organization_id: org1.id }).where('active_sessions.created_at >= ?', 7.days.ago).count}"
puts "   - Organization 1 (this month): #{ActiveSession.joins(:user).where(users: { organization_id: org1.id }).where('active_sessions.created_at >= ?', 30.days.ago).count}"
puts "   - Organization 2 (this week): #{ActiveSession.joins(:user).where(users: { organization_id: org2.id }).where('active_sessions.created_at >= ?', 7.days.ago).count}"
puts "   - Organization 2 (this month): #{ActiveSession.joins(:user).where(users: { organization_id: org2.id }).where('active_sessions.created_at >= ?', 30.days.ago).count}"

puts "\n✅ Seed completed successfully!"
puts "\n📝 Test Users Created:"
puts "=" * 80
puts "  ADMIN:"
puts "    Email: admin@hubsight.com"
puts "    Password: Password123!"
puts "    Role: admin"
puts ""
puts "  PORTFOLIO MANAGERS:"
puts "    Email: portfolio@hubsight.com"
puts "    Password: Password123!"
puts "    Role: portfolio_manager (Organization 1)"
puts ""
puts "    Email: portfolio2@hubsight.com"
puts "    Password: Password123!"
puts "    Role: portfolio_manager (Organization 2)"
puts ""
puts "  SITE MANAGERS:"
puts "    Email: sitemanager@hubsight.com"
puts "    Password: Password123!"
puts "    Role: site_manager (Organization 1)"
puts ""
puts "    Email: sitemanager2@hubsight.com"
puts "    Password: Password123!"
puts "    Role: site_manager (Organization 1)"
puts ""
puts "    Email: sitemanager3@hubsight.com"
puts "    Password: Password123!"
puts "    Role: site_manager (Organization 2)"
puts ""
puts "  TECHNICIAN:"
puts "    Email: technician@hubsight.com"
puts "    Password: Password123!"
puts "    Role: technician (Organization 1)"
puts ""
puts "  INACTIVE USER (for testing):"
puts "    Email: inactive@hubsight.com"
puts "    Password: Password123!"
puts "    Role: site_manager (inactive status)"
puts "=" * 80
puts "\n🔐 All users have the same password: Password123!"
puts "🌐 Login at: http://localhost:3000/login"
puts "\n📧 Email Preview (letter_opener): Check your browser for email previews"
puts ""
