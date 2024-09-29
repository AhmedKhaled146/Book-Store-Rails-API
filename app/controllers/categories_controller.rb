class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
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
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: {
        message: "Category successfully deleted",
      }
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:categories).permit(:name, :description)
  end
end
