class Record < ApplicationRecord
  belongs_to :user

  belongs_to :product

  module Behavior
    Buy = 1       # 购买
    Refund = 2    # 退货
    Browse = 3    # 浏览
    Collect = 4   # 收藏
  end
end
