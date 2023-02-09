class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = find_item
    render json: item
  end

  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(item_params)
    else
      item = Item.create(item_params)
    end
    render json: item, status: :created
  end

  private

  def not_found_response(exception)
    render json: {error: "#{exception.model} not found"}, status: :not_found
  end

  def find_item
    Item.find(params[:id])
  end

  def item_params
    params.permit(:name, :description, :price )
  end
end
