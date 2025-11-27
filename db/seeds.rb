# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Starting seed process..."

# ============================================================================
# USERS - Test users for each role
# ============================================================================

puts "\n👤 Creating test users..."

# Admin User
admin = User.find_or_initialize_by(email: 'admin@hubsight.com')
admin.assign_attributes(
  role: 'admin',
  first_name: 'Admin',
  last_name: 'Hubsight',
  phone: '+33 1 23 45 67 89',
  status: 'active',
  department: 'Administration',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if admin.new_record?
  admin.save!
  puts "  ✓ Created admin: admin@hubsight.com / pw54321"
else
  admin.save!
  puts "  ✓ Updated admin: admin@hubsight.com / pw54321"
end

# Portfolio Manager 1 - Organization 1
pm1 = User.find_or_initialize_by(email: 'portfolio@hubsight.com')
pm1.assign_attributes(
  role: 'portfolio_manager',
  first_name: 'Jean',
  last_name: 'Dupont',
  phone: '+33 6 12 34 56 78',
  organization_id: 1,
  status: 'active',
  department: 'Gestion Immobilière',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if pm1.new_record?
  pm1.save!
  puts "  ✓ Created portfolio manager: portfolio@hubsight.com / pw54321 (Organization 1)"
else
  pm1.save!
  puts "  ✓ Updated portfolio manager: portfolio@hubsight.com / pw54321 (Organization 1)"
end

# Portfolio Manager 2 - Organization 2
pm2 = User.find_or_initialize_by(email: 'portfolio2@hubsight.com')
pm2.assign_attributes(
  role: 'portfolio_manager',
  first_name: 'Marie',
  last_name: 'Martin',
  phone: '+33 6 98 76 54 32',
  organization_id: 2,
  status: 'active',
  department: 'Gestion de Patrimoine',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if pm2.new_record?
  pm2.save!
  puts "  ✓ Created portfolio manager: portfolio2@hubsight.com / pw54321 (Organization 2)"
else
  pm2.save!
  puts "  ✓ Updated portfolio manager: portfolio2@hubsight.com / pw54321 (Organization 2)"
end

# Site Manager 1 - Organization 1
sm1 = User.find_or_initialize_by(email: 'sitemanager@hubsight.com')
sm1.assign_attributes(
  role: 'site_manager',
  first_name: 'Pierre',
  last_name: 'Bernard',
  phone: '+33 6 11 22 33 44',
  organization_id: 1,
  status: 'active',
  department: 'Gestion de Site',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if sm1.new_record?
  sm1.save!
  puts "  ✓ Created site manager: sitemanager@hubsight.com / pw54321 (Organization 1)"
else
  sm1.save!
  puts "  ✓ Updated site manager: sitemanager@hubsight.com / pw54321 (Organization 1)"
end

# Site Manager 2 - Organization 1
sm2 = User.find_or_initialize_by(email: 'sitemanager2@hubsight.com')
sm2.assign_attributes(
  role: 'site_manager',
  first_name: 'Sophie',
  last_name: 'Leroy',
  phone: '+33 6 55 66 77 88',
  organization_id: 1,
  status: 'active',
  department: 'Gestion de Site',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if sm2.new_record?
  sm2.save!
  puts "  ✓ Created site manager: sitemanager2@hubsight.com / pw54321 (Organization 1)"
else
  sm2.save!
  puts "  ✓ Updated site manager: sitemanager2@hubsight.com / pw54321 (Organization 1)"
end

# Site Manager 3 - Organization 2
sm3 = User.find_or_initialize_by(email: 'sitemanager3@hubsight.com')
sm3.assign_attributes(
  role: 'site_manager',
  first_name: 'Luc',
  last_name: 'Moreau',
  phone: '+33 6 99 88 77 66',
  organization_id: 2,
  status: 'active',
  department: 'Gestion de Site',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if sm3.new_record?
  sm3.save!
  puts "  ✓ Created site manager: sitemanager3@hubsight.com / pw54321 (Organization 2)"
else
  sm3.save!
  puts "  ✓ Updated site manager: sitemanager3@hubsight.com / pw54321 (Organization 2)"
end

# Technician 1 - Organization 1
tech1 = User.find_or_initialize_by(email: 'technician@hubsight.com')
tech1.assign_attributes(
  role: 'technician',
  first_name: 'Thomas',
  last_name: 'Petit',
  phone: '+33 6 44 55 66 77',
  organization_id: 1,
  status: 'active',
  department: 'Maintenance',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if tech1.new_record?
  tech1.save!
  puts "  ✓ Created technician: technician@hubsight.com / pw54321 (Organization 1)"
else
  tech1.save!
  puts "  ✓ Updated technician: technician@hubsight.com / pw54321 (Organization 1)"
end

# Inactive User Example
inactive = User.find_or_initialize_by(email: 'inactive@hubsight.com')
inactive.assign_attributes(
  role: 'site_manager',
  first_name: 'Inactive',
  last_name: 'User',
  phone: '+33 6 00 00 00 00',
  organization_id: 1,
  status: 'inactive',
  department: 'Test',
  password: 'pw54321',
  password_confirmation: 'pw54321'
)
if inactive.new_record?
  inactive.save!
  puts "  ✓ Created inactive user: inactive@hubsight.com / pw54321 (for testing)"
else
  inactive.save!
  puts "  ✓ Updated inactive user: inactive@hubsight.com / pw54321 (for testing)"
end

puts "\n✅ Seed completed successfully!"
puts "\n📝 Test Users Created:"
puts "=" * 80
puts "  ADMIN:"
puts "    Email: admin@hubsight.com"
puts "    Password: pw54321"
puts "    Role: admin"
puts ""
puts "  PORTFOLIO MANAGERS:"
puts "    Email: portfolio@hubsight.com"
puts "    Password: pw54321"
puts "    Role: portfolio_manager (Organization 1)"
puts ""
puts "    Email: portfolio2@hubsight.com"
puts "    Password: pw54321"
puts "    Role: portfolio_manager (Organization 2)"
puts ""
puts "  SITE MANAGERS:"
puts "    Email: sitemanager@hubsight.com"
puts "    Password: pw54321"
puts "    Role: site_manager (Organization 1)"
puts ""
puts "    Email: sitemanager2@hubsight.com"
puts "    Password: pw54321"
puts "    Role: site_manager (Organization 1)"
puts ""
puts "    Email: sitemanager3@hubsight.com"
puts "    Password: pw54321"
puts "    Role: site_manager (Organization 2)"
puts ""
puts "  TECHNICIAN:"
puts "    Email: technician@hubsight.com"
puts "    Password: pw54321"
puts "    Role: technician (Organization 1)"
puts ""
puts "  INACTIVE USER (for testing):"
puts "    Email: inactive@hubsight.com"
puts "    Password: pw54321"
puts "    Role: site_manager (inactive status)"
puts "=" * 80
puts "\n🔐 All users have the same password: pw54321"
puts "🌐 Login at: http://localhost:3000/login"
puts ""
