class Book < ApplicationRecord
  belongs_to :category
  validates :title, :author, presence: true
end
