require 'faker'

namespace :populate do

  # District Generation
  desc "Creates some sample districts"
  task :districts, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample districts..."

    # Loop over all this stuff
    args.repeat.to_i.times do |n|
      # See if there is a state that doesn't have any districts
      unassigned_states = State.without_districts

      if unassigned_states.present?
        # Select from unassigned states
        state = unassigned_states.sample
      else
        # Select from any state
        state = State.all.sample
      end

      # Create a new district
      district = District.new(state: state, name: "#{state.name} #{Faker::Lorem.word} #{Faker::Team.creature}")
      if district.valid?
        district.save!
        puts "Created District: #{district.name}, for State: #{district.state.name}"
      end
    end
    puts "...done!"
  end

  # School Generation
  desc "Creates some sample schools"
  task :schools, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample schools..."
    args.repeat.to_i.times do |n|
      # See if there is a district that doesn't have any schools
      unassigned_districts = District.without_schools

      if unassigned_districts.present?
        # Select from unassigned districts
        district = unassigned_districts.sample
      else
        # Select from any district
        district = District.all.sample
      end

      # Create a new School
      school = School.new(district: district, name: Faker::Team.name)
      if school.valid?
        school.save!
        puts "Created School: #{school.name}, for District: #{school.district.name}"
      end
    end
    puts "...done!"
  end

  # Teacher Generation
  desc "Creates some sample teachers"
  task :teachers, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample teachers..."
    args.repeat.to_i.times do |n|

      # See if there is a school that doesn't have any teachers
      unassigned_schools = School.without_teachers

      if unassigned_schools.present?
        # Select from unassigned schools
        school = unassigned_schools.sample
      else
        # Select from any school
        school = School.all.sample
      end

      # Create a new Teacher
      teacher = Teacher.new(school: school, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email)
      if teacher.valid?
        teacher.save!
        puts "Created Teacher: #{teacher.full_name}, for School: #{teacher.school.name}"
      end
    end
    puts "...done!"
  end

  # Product Generation
  desc "Creates some sample products"
  task :products, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '2')
    puts "Generating sample products..."
    args.repeat.to_i.times do |n|
      # Create a new Product
      product = Product.new(name: Faker::Company.catch_phrase, description: Faker::Lorem.paragraph, price_cents: rand(10000..100000))
      if product.valid?
        product.save!
        puts "Created Product: #{product.name}"
      end
    end
    puts "...done!"
  end

  namespace :campaigns do
    # TODO: fix me to only create a single, active school based campaign
    # School-Wide campaigns
    desc "Creates some sample school-wide campaigns"
    task :school_wide, [:repeat] => [:environment] do |t, args|
      args.with_defaults(repeat: '5')
      puts "Generating sample school wide campaigns..."
      args.repeat.to_i.times do |n|
        # Randomly pick a school
        school = School.all.sample

        campaign = Campaign.new({
          name: "#{Faker::Company.catch_phrase} Campaign",
          school_wide: true,
          active: true,
          state: school.district.state,
          district: school.district,
          school: school,
          product: Product.all.sample,
          campaignable: school,
          campaignable_type: 'School',
          goal_amount_cents: rand(100..100000),
          physical_address: Faker::Address.street_address,
          physical_address_ext: Faker::Address.secondary_address,
          physical_city: Faker::Address.city,
          physical_state: Faker::Address.state,
          physical_postal_code: Faker::Address.zip_code,
        })
        if campaign.valid?
          campaign.save!
          puts "Created School-Wide Campaign: #{campaign.name}, for School: #{school.name}"
        end
      end
      puts "...done!"
    end

    # Teacher based campaigns
    desc "Creates some sample teacher-based campaigns"
    task :teacher_based, [:repeat] => [:environment] do |t, args|
      args.with_defaults(repeat: '5')
      puts "Generating sample teacher based campaigns..."
      args.repeat.to_i.times do |n|
        # Randomly pick a school
        teacher = Teacher.all.sample
        campaign = Campaign.new({
          name: "#{Faker::Company.catch_phrase} Campaign",
          school_wide: false,
          active: true,
          state: teacher.school.district.state,
          district: teacher.school.district,
          school: teacher.school,
          product: Product.all.sample,
          campaignable: teacher,
          campaignable_type: 'Teacher',
          goal_amount_cents: rand(100..10000),
          physical_address: Faker::Address.street_address,
          physical_address_ext: Faker::Address.secondary_address,
          physical_city: Faker::Address.city,
          physical_state: Faker::Address.state,
          physical_postal_code: Faker::Address.zip_code,
        })
        if campaign.valid?
          campaign.save!
          puts "Created Teacher-Based Campaign: #{campaign.name}, for Teacher: #{teacher.full_name} at School: #{teacher.school.name}"
        end
      end
      puts "...done!"
    end
  end

  # Contributors
  desc "Creates some sample contributors"
  task :contributors, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample contributors..."
    args.repeat.to_i.times do |n|
      contributor = Contributor.new(name: Faker::Name.name, email: Faker::Internet.email)
      if contributor.valid?
        contributor.save!
        puts "Created Contributor: #{contributor.name}, with email: #{contributor.email}"
      end
    end
    puts "...done!"
  end

  # Contributions
  desc "Creates some sample contributions"
  task :contributions, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample contributions..."
    args.repeat.to_i.times do |n|
      contribution = Contribution.new({
        pledge_id: Faker::Number.number(5),
        pledged_at: rand(5.weeks.ago..1.second.ago),
        contributor: Contributor.all.sample,
        campaign: Campaign.all.sample,
        amount_cents: rand(100..10000),
      })

      if contribution.valid?
        contribution.save!
        puts "Created Contribution: #{contribution.pledge_id}, for Amount: #{contribution.amount.to_s}"
      end
    end
    puts "...done!"
  end

  # Impressions
  desc "Creates some sample impressions"
  task :impressions, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample impressions..."
    args.repeat.to_i.times do |n|
      impression = Impression.new({
        email: Faker::Internet.email,
        campaign: Campaign.active.sample,
        referral_kind: 'social',
      })

      if impression.valid?
        impression.save!
        puts "Created Impression: #{impression.email}, for Campaign: #{impression.campaign.name}"
      end
    end
    puts "...done!"
  end

end
