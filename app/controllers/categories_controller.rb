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
      render json: {
        errors: @category.errors,
        status: :unprocessable_entity,
        message: "Failed to create category"
      }, status: :unprocessable_entity
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
      render json: {
        errors: @category.errors,
        status: :unprocessable_entity,
        message: "Failed to update category"
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: {
        message: "Category successfully deleted",
        status: :ok
      }
    else
      render json: {
        errors: @category.errors,
        status: :unprocessable_entity,
        message: "Failed to delete category"
      }, status: :unprocessable_entity
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:categories).permit(:name, :description)
  end

  def record_not_found
    render json: {
      errors: "Category not found",
      status: :not_found,
      message: "Could not find the requested category"
    }, status: :not_found
  end
end
