require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:line_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create line_item" do
    # without change this gives us "Couldn't find Product without an ID"
    assert_difference('LineItem.count') do
      # Before -> post :create, line_item: @line_item.attributes
      post :create, product_id: products(:ruby).id
    end

    # Before -> assert_redirected_to line_item_path(assigns(:line_item))
    assert_redirected_to cart_path(assigns(:line_item).cart)
  end

  test "should show line_item" do
    get :show, id: @line_item.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @line_item.to_param
    assert_response :success
  end

  test "should update line_item" do
    put :update, id: @line_item.to_param, line_item: @line_item.attributes
    assert_redirected_to line_item_path(assigns(:line_item))
  end

  test "should destroy line_item" do
    assert_difference('LineItem.count', -1) do
      # Sergey implementation http://pragprog.com/wikis/wiki/Pt-E-4
      delete :destroy, id: @line_item
    end

    # Sergey implementation http://pragprog.com/wikis/wiki/Pt-E-4
    assert_redirected_to Cart.find(session[:cart_id])
  end
end
