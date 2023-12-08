module Admin::ColorsHelper
  def color_name(color_id)
    case color_id
    when Color::ProductColor::Red
      "红色"
    when Color::ProductColor::Blue
      "蓝色"
    else
      "黄色"
    end
  end

  def get_color(color_id)

    Color.find_by(id: color_id)&.hex_code

    # case color_id
    # when Color::ProductColor::Red
    #   "<span class='var red'></span>"
    # when Color::ProductColor::Blue
    #   "<span class='var blue'></span>"
    # else
    #   "<span class='var yellow'></span>"
    # end
  end
end
