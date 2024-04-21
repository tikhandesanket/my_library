require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subscription_gold = subscriptions(:gold)
    @user = users(:one)
    @item1 = items(:book1)
    @item2 = items(:magazine1)
  end

  test "should order item" do
    post order_url, params: { user_id: @user.id, selected_items: [1,2,3] }
    assert_response :success
    assert_equal 'Order successful', JSON.parse(response.body)['message']
  end

  test "should return item" do
    post order_url, params: { user_id: @user.id, selected_items: [1,2,3] }
    post return_url, params: { user_id: @user.id,returned_items: [1,2,3] }
    assert_response :success
    assert_equal 'Return successful', JSON.parse(response.body)['message']
  end
end
