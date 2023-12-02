class Size < ApplicationRecord
  belongs_to :product

  module ProductSize
    M = 1
    L = 2
    XL = 3
    XXL = 4
  end
end
