class Category < ApplicationRecord
  has_many :products, dependent: :destroy

  has_ancestry orphan_strategy: :destroy

  # 检查 title
  validates_presence_of :title, :message => "类别名不能为空"
  validates :title, uniqueness: true

  # 处理为空的 ancestry
  before_validation :nil_ancestry

  def self.grouped_data
    self.roots.order("weight desc").inject([]) do |result, parent|
      row = []
      row << parent
      row << parent.children.order("weight desc")
      result << row
    end
  end

  private
  def nil_ancestry
    self.ancestry = nil if self.ancestry.blank?
  end
end
