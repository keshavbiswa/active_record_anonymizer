class User < ApplicationRecord
  anonymize :first_name, :last_name, :email
end
