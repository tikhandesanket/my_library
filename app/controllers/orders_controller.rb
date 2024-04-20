class OrdersController < ApplicationController
  def order_item
    user = User.find(params[:user_id])
    item = Item.find_by(title: params[:title], is_available: true)

    if user.transactions.where('date >= ?', 30.days.ago).count >= 10
      render json: { error: 'Transaction limit exceeded' }, status: :bad_request
      return
    end

    if item.nil?
      render json: { error: 'Item not available' }, status: :bad_request
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
      render json: { message: 'Order successful' }, status: :ok
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
end
