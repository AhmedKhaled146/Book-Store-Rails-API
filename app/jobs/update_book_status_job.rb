class UpdateBookStatusJob < ApplicationJob
  queue_as :default

  def perform(booking_id)
    Rails.logger.info "Running UpdateBookStatusJob for booking_id: #{booking_id}"

    booking = Booking.find_by(id: booking_id)
    return if booking.nil?

    if DateTime.now >= booking.ending_date
      Rails.logger.info "Updating book status for booking_id: #{booking_id}"
      booking.book.update(status: false)
    else
      Rails.logger.info "Booking for booking_id: #{booking_id} is still active."
    end
  end


end
