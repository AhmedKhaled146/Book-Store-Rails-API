class BooksController < ApplicationController
  before_action :set_category
  before_action :set_book, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
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
      render json: {
        errors: @book.errors,
        status: :unprocessable_entity,
        message: "Errors occurred while creating book"
      }, status: :unprocessable_entity
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
      render json: {
        errors: @book.errors,
        status: :unprocessable_entity,
        message: "Errors occurred while updating book"
      }, status: :unprocessable_entity
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
      render json: {
        errors: @book.errors,
        status: :unprocessable_entity,
        message: "Errors occurred while deleting book"
      }, status: :unprocessable_entity
    end
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end

  def set_book
    @book = @category.books.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  def book_params
    params.require(:books).permit(:title, :author, :description, :published_at)
  end

  def record_not_found
    render json: {
      errors: "Category not found",
      status: :not_found,
      message: "Could not find the requested category"
    }, status: :not_found
  end
end
