class BookingsController < ApplicationController
  before_action :authenticate_user!

  # Admin can See the booking
  def index
    @bookings = Booking.all # TODO: Requires Pagination
    render json: @bookings
  end

  # Regular User Can Book a Book
  def create
    @book = Book.find_by(id: params[:book_id]) # TODO: Move to before_action (before_action :set_book, only: :create)
    return render json: { error: "Book not found" }, status: :not_found if @book.nil?

    params[:booking][:starting_date] ||= DateTime.now
    @booking = Booking.new(booking_params) # TODO: booking_params.merge({user: current_user, book: @book}) and then no need for the next two lines
    @booking.user = current_user
    @booking.book = @book

    if @booking.save
      # Update the book's status to true (indicating it's booked)
      @booking.book.update(status: true) # TODO: this should be in a "Transcation" to make sure both of the transactions are done correctly

      # Schedule a job to update the book's status when the booking expires
      UpdateBookStatusJob.set(wait_until: @booking.ending_date).perform_later(@booking)

      render json: {
        message: "The Book '#{@booking.book.title}' has been booked",
        booking: @booking
      }, status: :created
    else
      render json: @booking.errors, status: :unprocessable_entity
    end
  end


  private

  def booking_params
    params.require(:booking).permit(:starting_date, :ending_date)
  end
end
