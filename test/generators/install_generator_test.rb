# frozen_string_literal: true

require "test_helper"
require "generators/active_record_anonymizer/install_generator"

module ActiveRecordAnonymizer
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests InstallGenerator

    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    teardown do
      FileUtils.rm_rf(destination_root)
    end

    test "generator creates an initializer file" do
      run_generator
      expected_output = <<~RUBY
        # frozen_string_literal: true

        ActiveRecordAnonymizer.configure do |config|
          # Configure the environments in which anonymization is allowed.
          config.environments = %i[staging]

          # Uncomment the following line to skip updating anonymized_columns when updating the original columns.
          # config.skip_update = true
        end
      RUBY
      assert_file "config/initializers/anonymizer.rb" do |initializer|
        assert_match expected_output, initializer
      end
    end
  end
end
