# frozen_string_literal: true

require "test_helper"

class ActiveRecord::TestAnonymizer < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ActiveRecord::Anonymizer::VERSION
  end
end
