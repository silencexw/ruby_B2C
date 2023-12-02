class Color < ApplicationRecord
  belongs_to :product

  module ProductColor
    Red = 1
    Blue = 2
    Yellow = 3
  end
end
