# frozen_string_literal: true

require_relative "../test_helper"

class ActiveRecordAnonymizer::FakeValueTest < ActiveSupport::TestCase
  setup do
    @name = "name"
    @column = mock("column")
    @fake_value = ActiveRecordAnonymizer::FakeValue.new(@name, @column)
  end

  test "generate_fake_value for string column type" do
    @column.stubs(:type).returns(:string)
    Faker::Lorem.stubs(:word).returns("random_word")

    assert_equal "random_word", @fake_value.generate_fake_value
  end

  test "generate_fake_value for text column type" do
    @column.stubs(:type).returns(:text)
    Faker::Lorem.stubs(:word).returns("random_word")

    assert_equal "random_word", @fake_value.generate_fake_value
  end

  test "generate_fake_value for citext column type" do
    @column.stubs(:type).returns(:citext)
    Faker::Lorem.stubs(:word).returns("random_word")

    assert_equal "random_word", @fake_value.generate_fake_value
  end

  test "generate_fake_value for uuid column type" do
    @column.stubs(:type).returns(:uuid)
    SecureRandom.stubs(:uuid).returns("random_uuid")

    assert_equal "random_uuid", @fake_value.generate_fake_value
  end

  test "generate_fake_value for integer column type" do
    @column.stubs(:type).returns(:integer)
    Faker::Number.stubs(:number).returns("random_number")

    assert_equal "random_number", @fake_value.generate_fake_value
  end

  test "generate_fake_value for bigint column type" do
    @column.stubs(:type).returns(:bigint)
    Faker::Number.stubs(:number).returns("random_number")

    assert_equal "random_number", @fake_value.generate_fake_value
  end

  test "generate_fake_value for smallint column type" do
    @column.stubs(:type).returns(:smallint)
    Faker::Number.stubs(:number).returns("random_number")

    assert_equal "random_number", @fake_value.generate_fake_value
  end

  test "generate_fake_value for decimal column type" do
    @column.stubs(:type).returns(:decimal)
    Faker::Number.stubs(:decimal).returns("random_decimal")

    assert_equal "random_decimal", @fake_value.generate_fake_value
  end

  test "generate_fake_value for float column type" do
    @column.stubs(:type).returns(:float)
    Faker::Number.stubs(:decimal).returns("random_decimal")

    assert_equal "random_decimal", @fake_value.generate_fake_value
  end

  test "generate_fake_value for real column type" do
    @column.stubs(:type).returns(:real)
    Faker::Number.stubs(:decimal).returns("random_decimal")

    assert_equal "random_decimal", @fake_value.generate_fake_value
  end

  test "generate_fake_value for datetime column type" do
    @column.stubs(:type).returns(:datetime)
    Faker::Time.stubs(:between).returns("random_datetime")

    assert_equal "random_datetime", @fake_value.generate_fake_value
  end

  test "generate_fake_value for timestamp column type" do
    @column.stubs(:type).returns(:timestamp)
    Faker::Time.stubs(:between).returns("random_timestamp")

    assert_equal "random_timestamp", @fake_value.generate_fake_value
  end

  test "generate_fake_value for timestamptz column type" do
    @column.stubs(:type).returns(:timestamptz)
    Faker::Time.stubs(:between).returns("random_timestamptz")

    assert_equal "random_timestamptz", @fake_value.generate_fake_value
  end

  test "generate_fake_value for date column type" do
    @column.stubs(:type).returns(:date)
    Faker::Date.stubs(:between).returns("random_date")

    assert_equal "random_date", @fake_value.generate_fake_value
  end

  test "generate_fake_value for time column type" do
    @column.stubs(:type).returns(:time)
    Faker::Time.stubs(:forward).returns("random_time")

    assert_equal "random_time", @fake_value.generate_fake_value
  end

  test "generate_fake_value for timetz column type" do
    @column.stubs(:type).returns(:time)
    Faker::Time.stubs(:forward).returns("random_timetz")

    assert_equal "random_timetz", @fake_value.generate_fake_value
  end

  test "generate_fake_value for boolean column type" do
    @column.stubs(:type).returns(:boolean)
    Faker::Boolean.stubs(:boolean).returns("random_boolean")

    assert_equal "random_boolean", @fake_value.generate_fake_value
  end

  test "generate_fake_value for json column type" do
    @column.stubs(:type).returns(:json)

    Faker::Lorem.stubs(:word).returns("random_text")
    Faker::Number.stubs(:number).with(digits: 2).returns(2)

    result = { "value" => { "key1" => "random_text", "key2" => 2 } }

    assert_equal result, @fake_value.generate_fake_value
  end

  test "generate_fake_value for jsonb column type" do
    @column.stubs(:type).returns(:jsonb)

    Faker::Lorem.stubs(:word).returns("random_text")
    Faker::Number.stubs(:number).with(digits: 2).returns(2)

    result = { "value" => { "key1" => "random_text", "key2" => 2 } }

    assert_equal result, @fake_value.generate_fake_value
  end

  test "generate_fake_value for inet column type" do
    @column.stubs(:type).returns(:inet)
    Faker::Internet.stubs(:ip_v4_address).returns("random_ip")

    assert_equal "random_ip", @fake_value.generate_fake_value
  end

  test "generate_fake_value for cidr column type" do
    @column.stubs(:type).returns(:cidr)
    Faker::Internet.stubs(:mac_address).returns("random_mac_address")

    assert_equal "random_mac_address", @fake_value.generate_fake_value
  end

  test "generate_fake_value for macaddr column type" do
    @column.stubs(:type).returns(:macaddr)
    Faker::Internet.stubs(:mac_address).returns("random_mac_address")

    assert_equal "random_mac_address", @fake_value.generate_fake_value
  end

  test "generate_fake_value for bytea column type" do
    @column.stubs(:type).returns(:bytea)
    Faker::Internet.stubs(:password).returns("random_password")

    assert_equal "random_password", @fake_value.generate_fake_value
  end

  test "generate_fake_value for bit column type" do
    @column.stubs(:type).returns(:bit)

    assert_includes %w[0 1], @fake_value.generate_fake_value
  end

  test "generate_fake_value for bit_varying column type" do
    @column.stubs(:type).returns(:bit_varying)

    assert_includes %w[0 1], @fake_value.generate_fake_value
  end

  test "generate_fake_value for money column type" do
    @column.stubs(:type).returns(:money)
    Faker::Commerce.stubs(:price).returns("random_price")

    assert_equal "random_price", @fake_value.generate_fake_value
  end

  test "generate_fake_value for hstore column type" do
    @column.stubs(:type).returns(:hstore)
    Faker::Lorem.stubs(:word).returns("random_text")
    Faker::Number.stubs(:number).with(digits: 2).returns(2)

    result = { "value" => { "key1" => "random_text", "key2" => 2 } }

    assert_equal result, @fake_value.generate_fake_value
  end

  test "generate_fake_value for year column type" do
    @column.stubs(:type).returns(:year)

    assert_includes 1901..2155, @fake_value.generate_fake_value
  end

  test "generate_fake_value raises error for unknown column type" do
    @column.stubs(:type).returns(:unknown)

    assert_raises ActiveRecordAnonymizer::UnknownColumnTypeError do
      @fake_value.generate_fake_value
    end
  end
end
