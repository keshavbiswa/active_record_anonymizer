# frozen_string_literal: true

module ActiveRecordAnonymizer
  class Railtie < Rails::Railtie
    rake_tasks do
      load "tasks/active_record_anonymizer.rake"
    end
  end
end
