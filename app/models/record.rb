class Record < ApplicationRecord
  belongs_to :user

  belongs_to :product

  module Behavior
    Buy = 1
    Refund = 2
    Browse = 3
    Collect = 4
  end
end
