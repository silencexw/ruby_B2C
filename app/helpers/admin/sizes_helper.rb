module Admin::SizesHelper
  def size_name(size_id)

    Size.find_by(id:size_id).name

    # case size_id
    # when Size::ProductSize::M
    #   'M'
    # when Size::ProductSize::L
    #   'L'
    # when Size::ProductSize::XL
    #   'XL'
    # when Size::ProductSize::XXL
    #   'XXL'
    # else
    #   '未知'
    # end
  end
end
