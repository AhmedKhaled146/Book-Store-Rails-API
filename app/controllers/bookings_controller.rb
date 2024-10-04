class BookingsController < ApplicationController
  before_action :authenticate_user!

  # Admin can See the booking
  def index
    @bookings = Booking.all
    render json: @bookings
  end

  # Regular User Can Book a Book
  def create
    @book = Book.find_by(id: params[:book_id])
    if @book.nil?
      render json: { error: "Book not found" }, status: :not_found and return
    end

    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.book = @book

    if @booking.save
      @booking.book.update(status: true)

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
    params.require(:bookings).permit(:starting_date, :ending_date)
  end
end
