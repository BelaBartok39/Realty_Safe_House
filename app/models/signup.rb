class Signup < ApplicationRecord
  belongs_to :user
  belongs_to :property
  has_one_attached :license_front
  has_one_attached :license_back
  has_one_attached :selfie
  enum status: { pending: 0, approved: 1, denied: 2 }
end
