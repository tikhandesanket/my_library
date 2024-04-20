class Subscription < ApplicationRecord
  # app/models/subscription.rb
  class Subscription < ApplicationRecord
    has_many :users
  end

end
