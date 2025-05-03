class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :properties, foreign_key: :realtor_id, dependent: :destroy
  has_many :signups, dependent: :destroy
  has_one_attached :avatar
  enum role: { client: 0, realtor: 1 }
end
