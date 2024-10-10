class Book < ApplicationRecord
  belongs_to :category
  has_many :bookings # TODO: Whenever you define a has_many relationship, you must tell what to do with the dependent records, ex: has_many :bookings, dependent: :destroy

  validates :title, :author, presence: true
  # TODO: Duplicate presence validation for title. wither you remove it from above like or bottom line
  validates :title, presence: true, uniqueness: true, length: { minimum: 3 }
  # TODO: Duplicate presence validation for author
  validates :author, presence: true

  def available?(start_date, end_date)
    # TODO: Make a "scope" in Booking model and use it. bookings.available(start_date, end_date).none?
    bookings.where("starting_date < ? AND ending_date > ?", end_date, start_date).none?
  end

  scope :filter_by_status, ->(status) {
    where(status: ActiveModel::Type::Boolean.new.cast(status)) if status.present?
  }

  scope :filter_by_category, ->(category_id) {
    where(category_id: category_id) if category_id.present?
  }

  # TODO: Better to be "filter_by_keyword"
  scope :search, ->(term) {
      where("title ILIKE :term OR author ILIKE :term", term: "%#{term}%") if term.present?
  }


end
