class Book < ApplicationRecord
  belongs_to :category
  has_many :bookings

  validates :title, :author, presence: true
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
  validates :author, presence: true

  def available?(start_date, end_date)
    bookings.where("starting_date < ? AND ending_date > ?", end_date, start_date).none?
  end

  scope :filter_by_status, ->(status) {
    where(status: ActiveModel::Type::Boolean.new.cast(status)) if status.present?
  }

  scope :filter_by_category, ->(category_id) {
    where(category_id: category_id) if category_id.present?
  }

end
