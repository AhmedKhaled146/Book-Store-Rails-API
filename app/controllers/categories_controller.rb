class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_category, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def index
    authorize Category
    @categories = Category.page(params[:page]).per(params[:per_page].presence || 10)
    render json: {
      data: @categories,
      status: :ok,
      message: "Categories fetched successfully",
      meta: pagination_meta(@categories)
    }
  end

  def show
    authorize Category
    render json: {
      data: @category,
      status: :ok,
      message: "Category fetched successfully"
    }
  end

  def create
    authorize Category
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
    authorize @category
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
    authorize @category
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

end
