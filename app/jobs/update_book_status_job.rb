class UpdateBookStatusJob < ApplicationJob
  queue_as :default

  def perform(booking)
    # TODO: we usually don't send object as param to the jobs, instead, we send id of the object only and fetch it from inside the job, this way we keep the redis server light. So accept booking_id and fetch booking
    # TODO: Refactor: return if booking.end_date < DateTime.now
    if DateTime.now > booking.ending_date
      booking.book.update(status: false)
    end
  end
end
