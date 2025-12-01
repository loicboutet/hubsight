namespace :analytics do
  desc "Seed database with sample contracts and equipment for analytics dashboard"
  task seed: :environment do
    puts "🌱 Seeding analytics data..."
    
    # Get existing organizations and sites
    organizations = Organization.all
    sites = Site.all
    
    if organizations.empty?
      puts "❌ No organizations found. Please run db:seed first."
      exit
    end
    
    if sites.empty?
      puts "❌ No sites found. Please create some sites first."
      exit
    end
    
    # Contract families
    contract_families = [
      'Maintenance CVC',
      'Sécurité & Gardiennage',
      'Nettoyage',
      'Ascenseurs',
      'Électricité',
      'Plomberie'
    ]
    
    # Contract statuses
    statuses = ['active', 'expired', 'pending', 'suspended']
    status_weights = [0.79, 0.07, 0.13, 0.01]  # Distribution from mock data
    
    # Equipment types
    equipment_types = [
      'CVC - Climatisation',
      'Ascenseurs & Monte-charges',
      'Éclairage',
      'Plomberie & Sanitaires',
      'Sécurité Incendie',
      "Contrôle d'Accès",
      'Menuiseries',
      'Autres'
    ]
    
    # Clear existing data
    puts "Clearing existing contracts and equipment..."
    Contract.delete_all
    Equipment.delete_all
    
    # Seed Contracts
    puts "Creating contracts..."
    contracts_created = 0
    
    organizations.each do |org|
      org_sites = sites.where(organization_id: org.id)
      next if org_sites.empty?
      
      # Create 30-40 contracts per organization
      contract_count = rand(30..40)
      
      contract_count.times do
        family = contract_families.sample
        # Weighted status selection
        rand_val = rand
        status = if rand_val < 0.79
          'active'
        elsif rand_val < 0.86
          'expired'
        elsif rand_val < 0.99
          'pending'
        else
          'suspended'
        end
        site = org_sites.sample
        
        # Generate realistic dates
        start_date = Date.today - rand(1..36).months
        duration_months = rand(12..60)
        end_date = start_date + duration_months.months
        
        # Generate realistic amounts based on family
        base_amounts = {
          'Maintenance CVC' => rand(80_000..150_000),
          'Sécurité & Gardiennage' => rand(50_000..120_000),
          'Nettoyage' => rand(30_000..80_000),
          'Ascenseurs' => rand(40_000..100_000),
          'Électricité' => rand(20_000..60_000),
          'Plomberie' => rand(15_000..40_000)
        }
        
        Contract.create!(
          organization: org,
          site: site,
          contract_number: "CTR-#{Date.today.year}-#{family[0..2].upcase}-#{rand(100..999)}",
          contract_family: family,
          status: status,
          annual_amount: base_amounts[family] || rand(20_000..100_000),
          start_date: start_date,
          end_date: end_date
        )
        
        contracts_created += 1
      end
    end
    
    puts "✅ Created #{contracts_created} contracts"
    
    # Seed Equipment
    puts "Creating equipment..."
    equipment_created = 0
    
    organizations.each do |org|
      org_sites = sites.where(organization_id: org.id)
      next if org_sites.empty?
      
      # Create 80-120 equipment per organization
      equipment_count = rand(80..120)
      
      equipment_count.times do
        type = equipment_types.sample
        site = org_sites.sample
        
        # Generate commissioning date for realistic age distribution
        rand_val = rand
        years_ago = if rand_val < 0.34
          rand(0..5)
        elsif rand_val < 0.62  # 0.34 + 0.28
          rand(6..10)
        elsif rand_val < 0.82  # 0.62 + 0.20
          rand(11..15)
        elsif rand_val < 0.94  # 0.82 + 0.12
          rand(16..20)
        else
          rand(21..30)
        end
        commissioning_date = Date.today - years_ago.years - rand(0..364).days
        
        Equipment.create!(
          organization: org,
          site: site,
          equipment_type: type,
          equipment_category: type.split(' - ').first || type,
          commissioning_date: commissioning_date
        )
        
        equipment_created += 1
      end
    end
    
    puts "✅ Created #{equipment_created} equipment"
    
    # Summary
    puts "\n📊 Analytics Data Summary:"
    puts "  Organizations: #{organizations.count}"
    puts "  Sites: #{sites.count}"
    puts "  Contracts: #{Contract.count}"
    puts "  Equipment: #{Equipment.count}"
    puts "\n✨ Analytics seed complete!"
  end
  
  desc "Clear all analytics data (contracts and equipment)"
  task clear: :environment do
    puts "🗑️  Clearing analytics data..."
    Contract.delete_all
    Equipment.delete_all
    puts "✅ All contracts and equipment cleared"
  end
end
