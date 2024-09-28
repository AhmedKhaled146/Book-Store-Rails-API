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
  end

  def destroy
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:categories).permit(:name, :description)
  end
end
