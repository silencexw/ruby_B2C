require 'will_paginate/array'

class ProductsController < ApplicationController

  def show
    @user_id = session[:user_id]
    @categories = Category.grouped_data
    @product = Product.find(params[:id])
    @product_colors = @product.product_colors.order(weight: "desc")
    @product_sizes = @product.product_sizes.order(weight: "desc")
    @is_favorite = false

    if not logged_in?
      @is_favorite = false
    elsif @product.favorites.blank?
      @is_favorite = false
    else
      favorite = @product.favorites.find_by(user_id: session[:user_id])
      @is_favorite = favorite.nil? ? false : true
    end

    @first_product_item_name = @product.product_items.first&.image

    if logged_in?
      record = Record.new(behaviour: Record::Behavior::Browse, product_id: @product.id, user_id: session[:user_id])
      record.save!
    end
  end

  def search
    @categories = Category.grouped_data
    query = params[:w]

    product_ids = Product.where("title LIKE :title", title: "%#{query}%").pluck(:id)

    sorted_product_ids = product_ids.sort_by { |id| -similarity_score(Product.find(id).title, query) }

    sorted_products = Product.where(id: sorted_product_ids)
    # .includes(:main_product_image)

    unless params[:category_id].blank?
      sorted_products = sorted_products.where(category_id: params[:category_id])
    end

    @products = sorted_products.sort_by { |product| sorted_product_ids.index(product.id) }
                               .paginate(page: params[:page] || 1, per_page: params[:per_page] || 12)

    render template: 'welcome/index'
  end

  def get_product_item
    @product = Product.find(params[:product_id])
    size_id = params[:size_id]
    color_id = params[:color_id]
    puts params

    # 调用 get_product_item 方法，并返回库存数量
    ele = @product.product_items.find_by(product_id: @product.id, color_id: color_id, size_id: size_id)

    unless ele
      render json: { inventory_id: 0, inventory_amount: 0, inventory_image: 0, flag: false }
      return
    end

    inventory_amount = ele.amount
    # inventory_amount = @product.product_items.find_by(product_id: @product.id, color_id: color_id, size_id: size_id).amount
    inventory_image = rails_blob_path(ele.image, only_path: true)
    inventory_id = ele.id

    puts inventory_image

    # 将库存数量以 JSON 形式返回
    render json: { inventory_id: inventory_id, inventory_amount: inventory_amount, inventory_image: inventory_image, flag: true }
  end

  private

  def similarity_score(str1, str2)
    # Convert strings to lowercase for case-insensitive comparison
    str1 = str1.downcase
    str2 = str2.downcase

    # Calculate Levenshtein distance between the two strings
    distance = levenshtein_distance(str1, str2)

    # Calculate similarity score as a ratio of the distance to the maximum possible distance
    max_distance = [str1.length, str2.length].max
    similarity = (max_distance - distance) / max_distance.to_f

    similarity
  end

  def levenshtein_distance(str1, str2)
    m = str1.length
    n = str2.length
    d = Array.new(m + 1) { Array.new(n + 1) }

    (0..m).each { |i| d[i][0] = i }
    (0..n).each { |j| d[0][j] = j }

    (1..n).each do |j|
      (1..m).each do |i|
        cost = str1[i - 1] == str2[j - 1] ? 0 : 1
        d[i][j] = [d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost].min
      end
    end

    d[m][n]
  end

end
