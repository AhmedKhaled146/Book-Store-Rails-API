class Book < ApplicationRecord
  belongs_to :category
  has_many :bookings, dependent: :destroy

  validates :author, presence: true
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }

  def available?(start_date, end_date)
    bookings.available(start_date, end_date).none?
  end

  scope :filter_by_status, ->(status) {
    where(status: ActiveModel::Type::Boolean.new.cast(status)) if status.present?
  }

  scope :filter_by_category, ->(category_id) {
    where(category_id: category_id) if category_id.present?
  }

  scope :filter_by_keyword, ->(term) {
    where("title ILIKE :term OR author ILIKE :term", term: "%#{term}%") if term.present?
  }



end
