class BooksController < ApplicationController
  before_action :set_category, except: [:all_books]
  before_action :set_book, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def all_books
    @books = Book.all
    render json: {
      data: @books,
      status: :ok,
      message: "All books fetched successfully"
    }
  end

  def index
    @books = @category.books.all
    render json: {
      data: @books,
      status: :ok,
      message: "Books fetched successfully"
    }
  end

  def show
    render json: {
      data: @book,
      status: :ok,
      message: "Book fetched successfully"
    }
  end

  def create
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

  def destroy
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
end
