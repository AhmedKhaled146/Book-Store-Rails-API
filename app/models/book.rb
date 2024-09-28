class Book < ApplicationRecord
  belongs_to :category
  validates :title, :author, presence: true
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :author, presence: true
end
