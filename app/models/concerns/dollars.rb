# http://stackoverflow.com/questions/1019939/ruby-on-rails-best-method-of-handling-currency-money
module Dollars
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods

    def has_dollar_field(field_name)
      # Setter
      # Make sure we've invoked a call to monetize
      if self.respond_to?(:monetized_attributes) && self.monetized_attributes.try(:[], field_name).present?
        define_method "#{field_name}_dollars=".to_sym do |arg|
          column_name = self.class.monetized_attributes[field_name]
          self.send("#{field_name}=", arg.to_money) if arg.present?
        end
      end

      # # Getter
      # define_method "#{field_name}_in_dollars".to_sym do
      #   self.send("#{field_name}_in_cents".to_sym).dollars if self.send("#{field_name}_in_cents".to_sym)
      # end
    end

  end

end
