class UpdateBookStatusJob < ApplicationJob
  queue_as :default

  def perform(booking)
    if DateTime.now > booking.ending_date
      booking.book.update(status: false)
    end
  end
end
