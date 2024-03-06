# ActiveRecordAnonymizer

Anonymize your ActiveRecord models with ease :sunglasses:

`ActiveRecordAnonymizer` uses `faker` to anonymize your ActiveRecord model's attributes without the need to write custom anonymization logic for each model.

Using `ActiveRecordAnonymizer`, you can:
- Anonymize specific attributes of your model (uses `faker` under the hood)
- Provide custom anonymization logic for specific attributes
- Provide custom anonymized columns for each attributes
- Encrypt anonymized data using `ActiveRecord::Encryption` (Requires Rails 7+)
- Environment dependent, so you can decide whether you want to view original data in development and anonymized data in production

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_anonymizer'
```

And then execute:

    $ bundle install

Or install it yourself as:
    
    $ gem install active_record_anonymizer

Install the gem using the following command:

    $ bin/rails generate active_record_anonymizer:install

You must have anonymized columns in your Model to store the anonymized data.
You can use the following migration generator to add anonymized columns to your existing table:

    $ bin/rails generate anonymize User first_name last_name
This will generate a migration file similar to the following:

```ruby
class AddAnonymizedColumnsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :anonymized_first_name, :string
    add_column :users, :anonymized_last_name, :string
  end
end
```

Add the following line to your model to enable anonymization:

```ruby
class User < ApplicationRecord
  # There are other options available, please refer to the Usage section
  anonymize :first_name, :last_name
end
```
To populate the anonymized columns, run the following command:

    $ bin/rails anonymize:populate CLASS=User

## Usage

Attributes can be anonymized using the `anonymize` method. The `anonymize` method takes the following options:

- `:column_name` - The name of the column to store the anonymized data. ("anonymized_#{column_name}" by default)
- `:with` - The custom logic to anonymize the attribute. (Optional, uses `faker` by default)
- `:encrypt` - Encrypt the anonymized data using `ActiveRecord::Encryption` (Requires Rails 7+)

```ruby
class User < ApplicationRecord
  anonymize :first_name, :last_name
  anonymize :email, with: ->(email) { Faker::Internet.email }
  anonymize :age, with: ->(age) { age + 5 }
  anonymize :phone, column_name: :fake_phone_number, with: ->(phone) { phone.gsub(/\d/, 'X') }
  anonymize :address, encrypt: true
end
```

## Configuration

You can configure the gem using the following options:

- `:environments` - The environments in which the anonymized data should be used. (Defaults to `[:staging]`)
- `:skip_update` - Skip updating the anonymized data when the record is updated. This ensures your anonymized data remains the same even if it's updated. (Defaults to `false`)
- `:alias_original_columns` - Alias the original columns to the anonymized columns. You can still access the original value of the attribute using the alias `original_#{attribute_name}`(Defaults to `false`)
- `:alias_column_name` - The name of the alias column. (Defaults to `original_#{column_name}`)

```ruby
ActiveRecordAnonymizer.configure do |config|
  config.environments = [:staging, :production] # The environments in which the anonymized data should be used
  config.skip_update = true # Skip updating the anonymized data when the record is updated
  config.alias_original_columns = true # Alias the original columns to the anonymized columns
  config.alias_column_name = "original" # The original column will be aliased to "original_#{column_name}
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
 Then, run `rake test` to run the tests.
 You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports are welcome on GitHub at https://github.com/keshavbiswa/active_record_anonymizer/issues.

- Fork the Repository: Start by forking this [repo](https://github.com/keshavbiswa/active_record_anonymizer.git) on GitHub.

- Set Up Your Local Environment: Navigate into the project directory and run the setup script to install dependencies:

```shell
    $ cd active_record_anonymizer
    $ bin/setup
```
- Create a New Branch: Before making any changes, create a new branch to keep your work organized:

```shell
    $ git checkout -b my-new-feature
```

- Make Your Changes: 
  - Implement your changes or fixes in your local repository.
  - Be sure to keep your changes as focused as possible. 
  - If you're working on multiple unrelated improvements, consider making separate branches and pull requests for each.

- Write Tests: If you're adding a new feature or fixing a bug, please add or update the corresponding tests. 

- Run Tests: Before submitting your changes, run the test suite to ensure everything is working correctly:
```shell
    $ bin/rake test
```

- Update Documentation: If your changes involve user-facing features or APIs, update the README or other relevant documentation accordingly.

- Submit a Pull Request: Go to the original `ActiveRecordAnonymizer` repository on GitHub, and you'll see a prompt to submit a pull request from your new branch.


Bug reports and pull requests are welcome on GitHub at https://github.com/keshavbiswa/active_record_anonymizer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
