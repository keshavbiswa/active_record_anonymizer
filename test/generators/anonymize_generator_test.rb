# frozen_string_literal: true

require "test_helper"
require "generators/anonymize/anonymize_generator"

module ActiveRecordAnonymizer
  class AnonymizeGeneratorTest < Rails::Generators::TestCase
    tests AnonymizeGenerator

    destination File.expand_path("../tmp", File.dirname(__FILE__))
    setup :prepare_destination

    test "generator does not create a migration if invalid model name is provided" do
      run_generator %w[InvalidModelName first_name]
      assert_no_migration "db/migrate/anonymize_generator_test_models.rb"
    end

    test "generator does not create a migration if arguments are invalid" do
      assert_no_migration "db/migrate/anonymize_generator_test_models.rb"
      run_generator %w[GeneratorTestModel non_existing_column first_name]
    end

    test "generator does not create a migration if arguments are missing" do
      assert_no_migration "db/migrate/anonymize_generator_test_models.rb"
    end

    test "generator runs without errors if arguments are valid" do
      run_generator %w[GeneratorTestModel first_name last_name age birth_date]
      assert_migration "db/migrate/anonymize_generator_test_models.rb" do |migration|
        assert_class_method :up, migration do |up|
          assert_match(/anonymized_first_name/, up)
          assert_match(/anonymized_last_name/, up)
          assert_match(/anonymized_age/, up)
          assert_match(/anonymized_birth_date/, up)
        end

        assert_class_method :down, migration do |down|
          assert_match(/remove_column :generator_test_models, :anonymized_first_name/, down)
          assert_match(/remove_column :generator_test_models, :anonymized_last_name/, down)
          assert_match(/remove_column :generator_test_models, :anonymized_age/, down)
          assert_match(/remove_column :generator_test_models, :anonymized_birth_date/, down)
        end
      end
    end
  end
end
