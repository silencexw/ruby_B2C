module Admin::SizesHelper
  def size_name(size_id)
    # puts size_id
    # puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    ele =Size.find_by(id:size_id).name
    puts ele
    ele
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

  def get_size_self(size_id)
    Size.find_by(id:size_id)
  end
  def get_sizes(product_sizes)
    sizes = []
    product_sizes.each do |pc|
      sizes << get_size_self(pc.size_id)
    end
    sizes
  end


end
