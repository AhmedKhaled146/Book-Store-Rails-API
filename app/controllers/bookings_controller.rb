class BookingsController < ApplicationController
  before_action :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Admin can See the booking
  def index
    authorize Booking

    @bookings = Booking.all
    render json: @bookings
  end

  # Regular User Can Book a Book
  def create
    authorize Booking

    @book = Book.find_by(id: params[:book_id])
    return render json: { error: "Book not found" }, status: :not_found if @book.nil?

    params[:booking][:starting_date] ||= DateTime.now
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.book = @book

    if @booking.save
      # Update the book's status to true (indicating it's booked)
      @booking.book.update(status: true)

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

  def user_not_authorized
    render json: {
      status: { code: 403, message: "You are not authorized to perform this action." }
    }, status: :forbidden
  end
end
