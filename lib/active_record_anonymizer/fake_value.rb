# frozen_string_literal: true

module ActiveRecordAnonymizer
  class FakeValue
    def initialize(name, column)
      @name = name
      @column = column
    end

    def generate_fake_value
      case @column.type
      when :string, :text, :citext then Faker::Lorem.word
      when :uuid then SecureRandom.uuid
      when :integer, :bigint, :smallint then Faker::Number.number(digits: 5)
      when :decimal, :float, :real then Faker::Number.decimal(l_digits: 2, r_digits: 2)
      when :datetime, :timestamp, :timestamptz then Faker::Time.between(from: DateTime.now - 1, to: DateTime.now)
      when :date then Faker::Date.between(from: Date.today - 2, to: Date.today)
      when :time, :timetz then Faker::Time.forward(days: 23, period: :morning)
      when :boolean then Faker::Boolean.boolean
      when :json, :jsonb then generate_json
      when :inet then Faker::Internet.ip_v4_address
      when :cidr, :macaddr then Faker::Internet.mac_address
      when :bytea then Faker::Internet.password
      when :bit, :bit_varying then %w[0 1].sample
      when :money then generate_money
      when :hstore then generate_json
      when :year then rand(1901..2155)
      else raise UnknownColumnTypeError, "Unknown column type: #{@column.type}"
      end
    end

    private

    def generate_json
      { "value" => { "key1" => Faker::Lorem.word, "key2" => Faker::Number.number(digits: 2) } }
    end

    def generate_money
      Faker::Commerce.price.to_s
    end
  end
end
