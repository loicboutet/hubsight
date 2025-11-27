# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting seed process..."

# ============================================================================
# ORGANIZATIONS - Create organizations first
# ============================================================================

puts "\n🏢 Creating organizations..."

# Organization 1
org1 = Organization.find_or_initialize_by(name: 'Immobilière Centrale')
org1.assign_attributes(
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
  site.assign_attributes(site_data)
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
  site.assign_attributes(site_data)
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
  site.assign_attributes(site_data)
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
  site.assign_attributes(site_data)
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
