require 'csv'

class Import

  # Import schools and shit
  def self.import_schools(file)
    result = {count: 0, success: false, warnings: []}
    return result.merge(message: 'No File Found!') if file.nil?
    begin
      # School Name, State, School Name Again, District
      CSV.parse(file.read).map do |fields|
        if fields.first.to_s.squish.first == '#' || fields.size != 4
          nil
        else
          school_name, state_name, school_name_proper, district_name = fields

          # Find the state
          my_state = State.find_by(name: state_name)
          if my_state.present?
            district = my_state.districts.find_or_create_by(name: district_name)

            if district.present?
              school = district.schools.find_or_create_by(name: school_name)

              school.valid? # Trigger validations

              if school.errors.any?
                Rails.logger.debug("failed to validate: school_name: #{school_name}, state_name: #{state_name}, district_name: #{district_name}")
                Rails.logger.debug("error messages: #{school.errors.full_messages.to_sentence}")
                # Don't save if you're invalid
              else
                # Rails.logger.debug("Added new School: #{school.name}, for District: #{district.name}") if school.new_record?
                if school.save
                  result[:count] += 1
                else
                Rails.logger.debug("failed to save: school_name: #{school_name}, state_name: #{state_name}, district_name: #{district_name}")
                Rails.logger.debug("error messages: #{school.errors.full_messages.to_sentence}")
                end
              end
            end
          end
        end
      end
    rescue CSV::MalformedCSVError => e
      result.merge!(message: e)
    end
    result.merge(result[:count].zero? ? {message: 'no new unique records found'} : {success: true})
  end

  def self.import_indiegogo_data(file)
    result = {count: 0, success: false, warnings: []}
    return result.merge(message: 'No File Found!') if file.nil?
    begin
      # Pledge ID, Date, Name, Email, Amount (USD)
      CSV.parse(file.read).map do |fields|
        if fields.first.to_s.squish.first == '#' || fields.size != 5
          nil
        else
          pledge_id, pledged_at, name, email, amount_usd = fields
          # Find the contributor, if one exists
          contributor = Contributor.find_by(email: email)

          # Create a new contributor if this one doesn't exist
          unless contributor.present?
            contributor = Contributor.create!(email: email, name: name)
          end

          # Format the date
          pretty_date = Date.strptime(pledged_at, "%m/%d/%Y")

          # Find all the pending impressions with this email
          impressions = Impression.with_date(pretty_date).where(email: email)


          # 1) Find the contributor if it exists, otherwise create one.

          # 2) Find any impressions that have a created_at DATE that might match the pledged_at DATE

          # 3) If there is only one record returned, then it is a one-to-one, so create the contribution and delete the impression

          # 4) If there are multiple records found, then it needs to be resolved manually.

          # 5) If there are no records found then don't do anything because it's a new impression or we haven't matched yet

          # 6) If there are multiple impressions for this email for different campaigns, or the same campaign, it requires
          # manual resolution. We can't do it for them, because we just don't know.

          # 7) In that case, we'd create the contribution, but not assign it to a campaign until it's resolved. Once it's resolved
          # then we would have it delete the impression.

          # We have something in the database
          if impressions.present?
            if (impressions.length == 1)
              # Easy Case
              impression = impressions.first

              contribution = contributor.contributions.new({
                pledge_id: pledge_id,
                pledged_at: pretty_date,
                campaign: impression.campaign,
                amount: amount_usd.to_money,
                impression_token: impression.token,
                imported_at: Time.zone.now,
              })
              # Trigger Validations
              contribution.valid?

              # Check for errors
              if contribution.errors.any?
                Rails.logger.debug("the following errors occured: #{contribution.errors.full_messages.to_sentence}")
              else
                if contribution.save
                  result[:count] += 1
                  impression.destroy
                end
              end
            elsif (impressions.length > 1)
              # TODO: make this work
              # Hard Case
              # Rails.logger.debug("hard case: #{name} #{email} - #{impressions.inspect}")
            end
          else
            # Nothing found
            # Rails.logger.debug("impossible case: nothing found!")
          end
        end
      end
    rescue CSV::MalformedCSVError => e
      result.merge!(message: e)
    end
    result.merge(result[:count].zero? ? {message: 'no new unique records found'} : {success: true})
  end

end
