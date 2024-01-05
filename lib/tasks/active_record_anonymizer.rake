# frozen_string_literal: true

require "active_record_anonymizer"

namespace :anonymizer do
  desc "populate anonymize columns (specify CLASS)"
  task populate: :environment do
    klass_name = ENV["CLASS"]
    abort "USAGE: rake anonymize:populate CLASS=User" unless klass_name

    model =
      begin
        ActiveRecordAnonymizer.load_model(klass_name)
      rescue ActiveRecordAnonymizer::Error => e
        abort e.message
      end

    puts "Anonymize columns for #{klass_name}..."
    model.each(&:save!)
    puts "Anonymize columns for #{klass_name} done!"
  end

  namespace :populate do
    desc "populate anonymize columns for all models"
    task all: :environment do
      ActiveRecordAnonymizer.models.each do |model|
        puts "Anonymizing #{model.name}..."
        model.find_each(&:save!)
      end
      puts "Anonymize columns for all models done!"
    end
  end
end
