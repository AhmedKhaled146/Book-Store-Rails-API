class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :book

  before_validation :set_default_starting_date, on: :create
  validate :valid_booking_dates, :no_overlapping_bookings
  validates :starting_date, :ending_date, presence: true

  # Set the default starting date to current time plus 1 second (to avoid microsecond delay issues)
  def set_default_starting_date
    self.starting_date ||= DateTime.now + 1.second
  end

  # Ensure the starting date and ending date are valid
  def valid_booking_dates
    current_time = DateTime.now

    if starting_date < current_time
      errors.add(:starting_date, 'cannot be in the past.')
    end

    if ending_date < current_time
      errors.add(:ending_date, 'cannot be in the past.')
    end

    if ending_date <= starting_date
      errors.add(:ending_date, 'must be after the starting date.')
    end
  end

  # Ensure the dates don't overlap with existing bookings for the same book
  def no_overlapping_bookings
    if book.bookings.available(starting_date, ending_date).exists?
      errors.add(:base, 'This book is already booked for the selected dates.')
    end
  end

  scope :available, ->(start_date, end_date) {
    where("starting_date < ? AND ending_date > ?", end_date, start_date)
  }

end
