class Transaction < ApplicationRecord
  # app/models/transaction.rb
  class Transaction < ApplicationRecord
    belongs_to :user
    belongs_to :item
  end

end
