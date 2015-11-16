class User < ActiveRecord::Base
  acts_as_tenant :account

  belongs_to :account, counter_cache: true
  validates :account_id, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

end
