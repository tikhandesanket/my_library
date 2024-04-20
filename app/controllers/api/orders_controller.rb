class Api::OrdersController < ApplicationController

  def library_items
    @items = Item.all
    render json: @items.as_json(only: [:id,:title,:genre,:category])
  end

  def order_items
    Item.where(id: params["selected_items"]).update(user_id: params["user_id"])
    render json: { message: 'Order has been placed  successfully' }
  end

  def return_items
    Item.where(id: params["returned_items"]).update(user_id:nil)
    render json: { message: 'Order returned successfully' }
  end

end
