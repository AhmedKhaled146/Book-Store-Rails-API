class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:books, :index, :show]
  before_action :set_category, except: [:books]
  before_action :set_book, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def books
    authorize Book
    @books = Book.filter_by_keyword(params[:search]).filter_by_status(params[:status]).filter_by_category(params[:category_id]).page(params[:page]).per(params[:per_page].presence || 10)
    render json: {
      data: @books,
      status: :ok,
      message: "All books fetched successfully",
      meta: pagination_meta(@books)
    }
  end

  def index
    authorize Book
    @books_category = @category.books.page(params[:page]).per(params[:per_page].presence || 10)
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
end
