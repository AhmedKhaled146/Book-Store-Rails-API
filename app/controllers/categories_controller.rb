class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @categories = Category.all
    render json: {
      data: @categories,
      status: :ok,
      message: "Categories fetched successfully"
    }
  end

  def show
    render json: {
      data: @category,
      status: :ok,
      message: "Category fetched successfully"
    }
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: {
        data: @category,
        status: :created,
        message: "Category created successfully"
      }, status: :created
    else
      render_errors(@category, "Failed to create category")
    end
  end

  def update
    if @category.update(category_params)
      render json: {
        data: @category,
        status: :ok,
        message: "Category successfully updated"
      }
    else
      render_errors(@category, "Failed to update category")
    end
  end

  def destroy
    if @category.destroy
      render json: {
        data: nil,
        message: "Category successfully deleted",
        status: :ok
      }
    else
      render_errors(@category, "Failed to delete category")
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def render_errors(object, message = "An error occurred")
    render json: {
      errors: object.errors,
      status: :unprocessable_entity,
      message: message
    }, status: :unprocessable_entity
  end

  def record_not_found
    render json: {
      errors: "Category not found",
      status: :not_found,
      message: "Could not find the requested category"
    }, status: :not_found
  end
end
