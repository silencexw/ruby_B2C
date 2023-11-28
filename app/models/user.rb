class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :addresses, -> { where(address_type: "user").order(id: :desc) }

  has_many :transaction_orders,  dependent: :destroy

  belongs_to :default_address, class_name: :Address, optional: true

  attr_accessor :password, :password_confirmation

  # 邮箱验证
  validates_presence_of :email, :message => "邮箱不能为空"
  validates_format_of :email, message: "邮箱格式不合法",
                      with: /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/,
                      if: proc { |user| !user.email.blank? }
  validates :email, uniqueness: { message: "该邮箱已被注册" }


  # 用户名验证
  validates_presence_of :username, :message => "用户名不能为空"
  validates :username, uniqueness: { message: "该用户名已被占用" }

  # 密码验证
  validates_presence_of :password, :message => "密码不能为空", if: :password_validate
  validates_presence_of :password_confirmation, :message => "确认密码不能为空", if: :password_validate
  validates_confirmation_of :password, :message => "两次密码不一致", if: :password_validate
  validates_length_of :password, :message => "最小密码长度为6", :minimum => 6, if: :password_validate
  validates_length_of :password, :message => "最大密码长度为15", :maximum => 15, if: :password_validate


  private
  def password_validate
    self.new_record? || (!self.password.nil? || !self.password_confirmation.nil?)
  end
end
