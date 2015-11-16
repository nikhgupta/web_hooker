class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :portals, dependent: :destroy
  has_many :destinations, dependent: :destroy
  has_many :submissions, dependent: :destroy
  has_many :replies, dependent: :destroy
end
