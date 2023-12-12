# frozen_string_literal: true

require "test_helper"

class ActiveRecordAnonymizerTest < ActiveSupport::TestCase
  def test_that_it_has_a_version_number
    refute_nil ActiveRecordAnonymizer::VERSION
  end
end
