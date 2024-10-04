class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :book

  before_validation :set_default_starting_date, on: :create
  validates :starting_date, :ending_date, presence: true

  validate :valid_booking_dates, :no_overlapping_bookings

  # Ensure the dates don't overlap with existing bookings for the same book
  def no_overlapping_bookings
    overlapping_bookings = Booking.where(book_id: book_id).where("starting_date < ? AND ending_date > ?", ending_date, starting_date)
    if overlapping_bookings.exists?
      errors.add(:base, 'This book is already booked for the selected dates.')
    end
  end

  # Set the default starting date as current time
  def set_default_starting_date
    self.starting_date ||= Time.current
  end

  # Ensure the starting date is not in the past
  def valid_booking_dates
    if starting_date < Time.current
      errors.add(:starting_date, 'cannot be in the past.')
    end
  end

  # Method to update book status after the booking has expired
  def update_book_status_expired
    if Time.current > ending_date
      book.update(status: false)
    end
  end
end
