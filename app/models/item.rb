class Item < ApplicationRecord
  # app/models/item.rb
  class Item < ApplicationRecord
    has_many :transactions
  end

end
