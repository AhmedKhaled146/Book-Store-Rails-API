class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:all_books, :index, :show]
  before_action :set_category, except: [:all_books]
  before_action :set_book, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def all_books
    authorize Book
    @books = Book.filter_by_status(params[:status]).page(params[:page]).per(3)
    render json: {
      data: @books,
      status: :ok,
      message: "All books fetched successfully",
      meta: pagination_meta(@books)
    }
  end

  def index
    authorize Book
    @books_category = @category.books.page(params[:page]).per(2)
    render json: {
      data: @books_category,
      status: :ok,
      message: "Books fetched successfully",
      meta: pagination_meta(@books_category)
    }
  end

  def show
    authorize Book
    render json: {
      data: @book,
      status: :ok,
      message: "Book fetched successfully"
    }
  end

  def create
    authorize Book
    @book = @category.books.build(book_params)
    if @book.save
      render json: {
        data: @book,
        status: :created,
        message: "Book created successfully"
      }, status: :created
    else
      render_errors(@book)
    end
  end

  def update
    authorize @book
    if @book.update(book_params)
      render json: {
        data: @book,
        status: :ok,
        message: "Book updated successfully"
      }
    else
      render_errors(@book)
    end
  end

  # Method to update book status after the booking has expired
  def update_book_status_expired
    if DateTime.now > ending_date
      @book.update(status: false)
    end
  end

  def destroy
    authorize @book
    if @book.destroy
      render json: {
        data: nil,
        status: :ok,
        message: "Book deleted successfully"
      }
    else
      render_errors(@book)
    end
  end

  private

  def pagination_meta(paginated_records)
    {
      current_page: paginated_records.current_page,
      next_page: paginated_records.next_page,
      prev_page: paginated_records.prev_page,
      total_pages: paginated_records.total_pages,
      total_count: paginated_records.total_count
    }
  end

  def set_category
    @category = Category.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    record_not_found('Category')
  end

  def set_book
    @book = @category.books.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    record_not_found('Book')
  end

  def book_params
    params.require(:book).permit(:title, :author, :description, :published_at)
  end

  def render_errors(object)
    render json: {
      errors: object.errors,
      status: :unprocessable_entity,
      message: "Errors occurred while processing the request"
    }, status: :unprocessable_entity
  end

  def record_not_found(resource)
    render json: { error: "#{resource} not found" }, status: :not_found
  end

  def user_not_authorized
    render json: {
      status: { code: 403, message: "You are not authorized to perform this action." }
    }, status: :forbidden
  end
end
