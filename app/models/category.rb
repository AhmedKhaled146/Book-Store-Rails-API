class Category < ApplicationRecord
  has_many :books, dependent: :destroy
  validates :name, presence: true, uniqueness: true, length: { in: 3..20 }
end
