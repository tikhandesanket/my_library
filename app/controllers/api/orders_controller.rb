class Api::OrdersController < ApplicationController
  before_action :available_items, only: [:library_items, :order_item]
  def library_items
    @items = Item.all
    render json: @items.as_json(only: [:id,:title,:genre,:category])
  end

  # def order_items
  #   Item.where(id: params["@items_without_user"]).update(user_id: params["user_id"])
  #   render json: { message: 'Order has been placed  successfully' }
  # end
  #
  # def return_items
  #   Item.where(id: params["returned_items"]).update(user_id:nil)
  #   render json: { message: 'Items returned successfully' }
  # end


  def order_item
    user = User.find(params[:user_id])
    item = Item.find_by(title: params[:title], is_available: true)

    available_items = @available_items & params[:order_items  ]
    un_available_items = params[order_items] & @available_items


    if user.transactions.where('date >= ?', 30.days.ago).count >= 10
      render json: { error: 'Transaction limit exceeded' }, status: :bad_request
      return
    end

    if !un_available_items.nil?
      items = Item.where(id:un_available_items).pluck(:title)
      render json: { message:  items.join(",")+'are not available' }, status: :ok
      return
    end

    if item.genre == 'Crime' && user.age < 18
      render json: { error: 'Age restriction' }, status: :bad_request
      return
    end

    if user.transactions.where(item_id: item.id).count >= user.subscription.max_books
      render json: { error: 'Max books reached for subscription' }, status: :bad_request
      return
    end

    transaction = Transaction.new(user_id: user.id, item_id: item.id)
    if transaction.save
      items = Item.where(id:available_items).pluck(:title)
      render json: { message: items.join(",")+'Ordered successfuly' }, status: :ok
    else
      render json: { error: 'Failed to create transaction' }, status: :unprocessable_entity
    end
  end

  def return_item
    user = User.find(params[:user_id])
    items = Item.where(title: params[:titles])

    items.each do |item|
      transaction = user.transactions.find_by(item_id: item.id)

      if transaction.nil?
        render json: { error: "Item #{item.title} not borrowed by user" }, status: :bad_request
        return
      end

      transaction.destroy
      item.update(is_available: true)
    end

    render json: { message: 'Return successful' }, status: :ok
  end


private
  def avaibile_items
    @available_items = Item.where(user_id: nil).pluck(:id)
  end

end
