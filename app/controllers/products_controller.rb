require 'will_paginate/array'
class ProductsController < ApplicationController
  def show
    @user_id = session[:user_id]
    @categories = Category.grouped_data
    @product = Product.find(params[:id])

  end

  def search
    @categories = Category.grouped_data
    query = params[:w]

    product_ids = Product.where("title LIKE :title", title: "%#{query}%").pluck(:id)

    sorted_product_ids = product_ids.sort_by { |id| -similarity_score(Product.find(id).title, query) }

    sorted_products = Product.where(id: sorted_product_ids)
                             .includes(:main_product_image)

    unless params[:category_id].blank?
      sorted_products = sorted_products.where(category_id: params[:category_id])
    end

    @products = sorted_products.sort_by { |product| sorted_product_ids.index(product.id) }
                               .paginate(page: params[:page] || 1, per_page: params[:per_page] || 12)

    render template: 'welcome/index'
  end

  private
  def get_amount

    @all_amount = 0

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
        cost = str1[i-1] == str2[j-1] ? 0 : 1
        d[i][j] = [d[i-1][j] + 1, d[i][j-1] + 1, d[i-1][j-1] + cost].min
      end
    end

    d[m][n]
  end


end
