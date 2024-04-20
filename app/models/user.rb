# app/models/user.rb
class User < ApplicationRecord
  belongs_to :subscription
  has_many :transactions


  def subscription_plan

  end
end

