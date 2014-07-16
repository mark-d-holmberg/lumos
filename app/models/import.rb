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
    result.merge(result[:count].zero? ? {message: 'no new unique records found'} : {success: true})
  end

end
