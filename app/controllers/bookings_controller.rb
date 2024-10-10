class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:create]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Admin can See the booking
  def index
    authorize Booking
    @bookings = Booking.page(params[:page]).per(params[:per_page].presence || 10)
    render json: @bookings
  end

  # Regular User Can Book a Book
  def create
    authorize Booking
    
    params[:booking][:starting_date] ||= DateTime.now
    @booking = Booking.new(booking_params.merge({user: current_user, book: @book}))

    ActiveRecord::Base.transaction do
      @booking.save!
      @booking.book.update!(status: true)
    end

    UpdateBookStatusJob.set(wait_until: @booking.ending_date).perform_later(@booking.id)

    render json: {
      message: "The Book '#{@booking.book.title}' has been booked",
      booking: @booking
    }, status: :created

  rescue ActiveRecord::RecordInvalid
    render json: @booking.errors, status: :unprocessable_entity
  end



  private

  def set_book
    @book = Book.find_by(id: params[:book_id])
    return render json: { error: "Book not found" }, status: :not_found if @book.nil?
  end
  def booking_params
    params.require(:booking).permit(:starting_date, :ending_date)
  end

end
