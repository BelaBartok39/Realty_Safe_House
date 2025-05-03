class Property < ApplicationRecord
  belongs_to :realtor, class_name: "User"
  has_many :signups, dependent: :destroy
  has_one_attached :image
end
