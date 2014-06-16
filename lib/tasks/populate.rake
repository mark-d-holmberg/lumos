require 'faker'

namespace :populate do

  # District Generation
  desc "Creates some sample districts"
  task :districts, [:repeat] => [:environment] do |t, args|
    args.with_defaults(repeat: '5')
    puts "Generating sample districts..."
    args.repeat.to_i.times do |n|
      district = District.new(state: State.all.sample, name: Faker::Team.name)
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
      school = School.new(district: District.all.sample, name: Faker::Team.name)
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
      teacher = Teacher.new(school: School.all.sample, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
      if teacher.valid?
        teacher.save!
        puts "Created Teacher: #{teacher.full_name}, for School: #{teacher.school.name}"
      end
    end
    puts "...done!"
  end

  namespace :campaigns do
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
          campaignable: school,
          campaignable_type: 'School',
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
          campaignable: teacher,
          campaignable_type: 'Teacher',
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

end
