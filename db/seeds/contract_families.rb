# Contract Families and Subfamilies Seed Data
# Based on CONTRATS.XLSX, Sheet 2: "Famille achats"
# 7 purchase families with representative subfamilies

puts "Seeding Contract Families..."

# Clear existing data
ContractFamily.destroy_all

# ============================================================================
# FAMILY 1: MAINTENANCE (Maintenance préventive et corrective)
# ============================================================================

maintenance = ContractFamily.create!(
  code: 'MAIN',
  name: 'Maintenance',
  family_type: 'family',
  description: 'Maintenance préventive et corrective des équipements techniques',
  status: 'active',
  display_order: 1
)

ContractFamily.create!([
  {
    code: 'MAIN-ASC',
    name: 'Ascenseurs',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des ascenseurs et monte-charges',
    status: 'active',
    display_order: 1
  },
  {
    code: 'MAIN-CVC',
    name: 'CVC (Chauffage, Ventilation, Climatisation)',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des systèmes de chauffage, ventilation et climatisation',
    status: 'active',
    display_order: 2
  },
  {
    code: 'MAIN-PLO',
    name: 'Plomberie',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des installations de plomberie et sanitaires',
    status: 'active',
    display_order: 3
  },
  {
    code: 'MAIN-ELE',
    name: 'Électricité',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des installations électriques',
    status: 'active',
    display_order: 4
  },
  {
    code: 'MAIN-MEN',
    name: 'Menuiseries',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des portes, fenêtres et menuiseries',
    status: 'active',
    display_order: 5
  },
  {
    code: 'MAIN-FAC',
    name: 'Façades',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance et ravalement des façades',
    status: 'active',
    display_order: 6
  },
  {
    code: 'MAIN-TOI',
    name: 'Toitures',
    family_type: 'subfamily',
    parent_code: 'MAIN',
    description: 'Maintenance des toitures et étanchéité',
    status: 'active',
    display_order: 7
  }
])

# ============================================================================
# FAMILY 2: CLEANING AND HYGIENE (Nettoyage et hygiène)
# ============================================================================

cleaning = ContractFamily.create!(
  code: 'NETT',
  name: 'Nettoyage et Hygiène',
  family_type: 'family',
  description: 'Services de nettoyage et d\'hygiène des locaux',
  status: 'active',
  display_order: 2
)

ContractFamily.create!([
  {
    code: 'NETT-LOC',
    name: 'Nettoyage des locaux',
    family_type: 'subfamily',
    parent_code: 'NETT',
    description: 'Nettoyage quotidien et entretien des locaux',
    status: 'active',
    display_order: 1
  },
  {
    code: 'NETT-VER',
    name: 'Espaces verts',
    family_type: 'subfamily',
    parent_code: 'NETT',
    description: 'Entretien des espaces verts et jardins',
    status: 'active',
    display_order: 2
  },
  {
    code: 'NETT-DER',
    name: 'Dératisation et désinsectisation',
    family_type: 'subfamily',
    parent_code: 'NETT',
    description: 'Services de dératisation et désinsectisation',
    status: 'active',
    display_order: 3
  },
  {
    code: 'NETT-DEC',
    name: 'Gestion des déchets',
    family_type: 'subfamily',
    parent_code: 'NETT',
    description: 'Collecte et gestion des déchets',
    status: 'active',
    display_order: 4
  },
  {
    code: 'NETT-VIT',
    name: 'Nettoyage de vitres',
    family_type: 'subfamily',
    parent_code: 'NETT',
    description: 'Nettoyage des vitres et surfaces vitrées',
    status: 'active',
    display_order: 5
  }
])

# ============================================================================
# FAMILY 3: TECHNICAL AND BIOLOGICAL CONTROL (Contrôles techniques)
# ============================================================================

control = ContractFamily.create!(
  code: 'CTRL',
  name: 'Contrôles Techniques et Biologiques',
  family_type: 'family',
  description: 'Contrôles réglementaires et vérifications techniques',
  status: 'active',
  display_order: 3
)

ContractFamily.create!([
  {
    code: 'CTRL-REG',
    name: 'Contrôles réglementaires périodiques',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Vérifications périodiques obligatoires',
    status: 'active',
    display_order: 1
  },
  {
    code: 'CTRL-ELE',
    name: 'Vérifications électriques',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Contrôle des installations électriques',
    status: 'active',
    display_order: 2
  },
  {
    code: 'CTRL-LEV',
    name: 'Appareils de levage',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Vérifications des ascenseurs et appareils de levage',
    status: 'active',
    display_order: 3
  },
  {
    code: 'CTRL-INC',
    name: 'Sécurité incendie',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Contrôles des systèmes de sécurité incendie',
    status: 'active',
    display_order: 4
  },
  {
    code: 'CTRL-LEG',
    name: 'Analyse légionelles',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Tests et analyses de légionelles dans les réseaux d\'eau',
    status: 'active',
    display_order: 5
  },
  {
    code: 'CTRL-AIR',
    name: 'Qualité de l\'air intérieur',
    family_type: 'subfamily',
    parent_code: 'CTRL',
    description: 'Mesures et analyses de la qualité de l\'air',
    status: 'active',
    display_order: 6
  }
])

# ============================================================================
# FAMILY 4: UTILITIES (Fluides)
# ============================================================================

utilities = ContractFamily.create!(
  code: 'FLUI',
  name: 'Fluides',
  family_type: 'family',
  description: 'Fourniture de fluides et énergies',
  status: 'active',
  display_order: 4
)

ContractFamily.create!([
  {
    code: 'FLUI-ELE',
    name: 'Électricité',
    family_type: 'subfamily',
    parent_code: 'FLUI',
    description: 'Fourniture d\'électricité',
    status: 'active',
    display_order: 1
  },
  {
    code: 'FLUI-GAZ',
    name: 'Gaz naturel',
    family_type: 'subfamily',
    parent_code: 'FLUI',
    description: 'Fourniture de gaz naturel',
    status: 'active',
    display_order: 2
  },
  {
    code: 'FLUI-EAU',
    name: 'Eau potable',
    family_type: 'subfamily',
    parent_code: 'FLUI',
    description: 'Fourniture d\'eau potable',
    status: 'active',
    display_order: 3
  },
  {
    code: 'FLUI-FRO',
    name: 'Eau glacée',
    family_type: 'subfamily',
    parent_code: 'FLUI',
    description: 'Fourniture d\'eau glacée pour climatisation',
    status: 'active',
    display_order: 4
  },
  {
    code: 'FLUI-FIO',
    name: 'Fioul',
    family_type: 'subfamily',
    parent_code: 'FLUI',
    description: 'Fourniture de fioul domestique',
    status: 'active',
    display_order: 5
  }
])

# ============================================================================
# FAMILY 5: INSURANCE (Assurances)
# ============================================================================

insurance = ContractFamily.create!(
  code: 'ASSU',
  name: 'Assurances',
  family_type: 'family',
  description: 'Assurances et couvertures de risques',
  status: 'active',
  display_order: 5
)

ContractFamily.create!([
  {
    code: 'ASSU-MUL',
    name: 'Multirisque immeuble',
    family_type: 'subfamily',
    parent_code: 'ASSU',
    description: 'Assurance multirisque des bâtiments',
    status: 'active',
    display_order: 1
  },
  {
    code: 'ASSU-RCS',
    name: 'Responsabilité civile',
    family_type: 'subfamily',
    parent_code: 'ASSU',
    description: 'Assurance responsabilité civile',
    status: 'active',
    display_order: 2
  },
  {
    code: 'ASSU-DOM',
    name: 'Dommages aux biens',
    family_type: 'subfamily',
    parent_code: 'ASSU',
    description: 'Assurance dommages matériels',
    status: 'active',
    display_order: 3
  },
  {
    code: 'ASSU-PEX',
    name: 'Perte d\'exploitation',
    family_type: 'subfamily',
    parent_code: 'ASSU',
    description: 'Assurance perte d\'exploitation',
    status: 'active',
    display_order: 4
  }
])

# ============================================================================
# FAMILY 6: REAL ESTATE (Immobilier)
# ============================================================================

realestate = ContractFamily.create!(
  code: 'IMMO',
  name: 'Immobilier',
  family_type: 'family',
  description: 'Gestion immobilière et administration',
  status: 'active',
  display_order: 6
)

ContractFamily.create!([
  {
    code: 'IMMO-COP',
    name: 'Gestion de copropriété',
    family_type: 'subfamily',
    parent_code: 'IMMO',
    description: 'Syndic de copropriété',
    status: 'active',
    display_order: 1
  },
  {
    code: 'IMMO-LOC',
    name: 'Gestion locative',
    family_type: 'subfamily',
    parent_code: 'IMMO',
    description: 'Gestion des baux et locataires',
    status: 'active',
    display_order: 2
  },
  {
    code: 'IMMO-ADM',
    name: 'Administration de biens',
    family_type: 'subfamily',
    parent_code: 'IMMO',
    description: 'Administration et gestion patrimoniale',
    status: 'active',
    display_order: 3
  },
  {
    code: 'IMMO-TAX',
    name: 'Taxes foncières',
    family_type: 'subfamily',
    parent_code: 'IMMO',
    description: 'Gestion des taxes et impôts fonciers',
    status: 'active',
    display_order: 4
  }
])

# ============================================================================
# FAMILY 7: OTHER CONTRACTS (Autres contrats)
# ============================================================================

other = ContractFamily.create!(
  code: 'AUTR',
  name: 'Autres Contrats',
  family_type: 'family',
  description: 'Autres services et contrats divers',
  status: 'active',
  display_order: 7
)

ContractFamily.create!([
  {
    code: 'AUTR-SEC',
    name: 'Sécurité et gardiennage',
    family_type: 'subfamily',
    parent_code: 'AUTR',
    description: 'Services de sécurité et gardiennage',
    status: 'active',
    display_order: 1
  },
  {
    code: 'AUTR-TEL',
    name: 'Téléphonie',
    family_type: 'subfamily',
    parent_code: 'AUTR',
    description: 'Services de téléphonie fixe et mobile',
    status: 'active',
    display_order: 2
  },
  {
    code: 'AUTR-INT',
    name: 'Internet et réseaux',
    family_type: 'subfamily',
    parent_code: 'AUTR',
    description: 'Connexion internet et services réseaux',
    status: 'active',
    display_order: 3
  },
  {
    code: 'AUTR-PAR',
    name: 'Gestion de parking',
    family_type: 'subfamily',
    parent_code: 'AUTR',
    description: 'Exploitation et gestion des parkings',
    status: 'active',
    display_order: 4
  }
])

# ============================================================================
# Summary
# ============================================================================

families_count = ContractFamily.families_only.count
subfamilies_count = ContractFamily.subfamilies_only.count
total_count = ContractFamily.count

puts "✅ Contract Families seeded successfully!"
puts "   - #{families_count} families"
puts "   - #{subfamilies_count} subfamilies"
puts "   - #{total_count} total classifications"
puts ""
puts "Families:"
ContractFamily.families.each do |family|
  subfamily_count = family.subfamilies.count
  puts "   #{family.code}: #{family.name} (#{subfamily_count} subfamilies)"
end
