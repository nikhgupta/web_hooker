class User < ActiveRecord::Base
  has_many :portals, dependent: :destroy
  has_many :submissions, through: :portals, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

end
