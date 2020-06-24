require 'test_helper'

class SalesItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sales_item = sales_items(:one)
  end

  test "should get index" do
    get sales_items_url
    assert_response :success
  end

  test "should get new" do
    get new_sales_item_url
    assert_response :success
  end

  test "should create sales_item" do
    assert_difference('SalesItem.count') do
      post sales_items_url, params: { sales_item: { alert: @sales_item.alert, bottles: @sales_item.bottles, bottles_1: @sales_item.bottles_1, bottles_2: @sales_item.bottles_2, cases: @sales_item.cases, cost: @sales_item.cost, department: @sales_item.department, markup: @sales_item.markup, name: @sales_item.name, percent: @sales_item.percent, price: @sales_item.price, quanity: @sales_item.quanity, size: @sales_item.size, type: @sales_item.type } }
    end

    assert_redirected_to sales_item_url(SalesItem.last)
  end

  test "should show sales_item" do
    get sales_item_url(@sales_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_sales_item_url(@sales_item)
    assert_response :success
  end

  test "should update sales_item" do
    patch sales_item_url(@sales_item), params: { sales_item: { alert: @sales_item.alert, bottles: @sales_item.bottles, bottles_1: @sales_item.bottles_1, bottles_2: @sales_item.bottles_2, cases: @sales_item.cases, cost: @sales_item.cost, department: @sales_item.department, markup: @sales_item.markup, name: @sales_item.name, percent: @sales_item.percent, price: @sales_item.price, quanity: @sales_item.quanity, size: @sales_item.size, type: @sales_item.type } }
    assert_redirected_to sales_item_url(@sales_item)
  end

  test "should destroy sales_item" do
    assert_difference('SalesItem.count', -1) do
      delete sales_item_url(@sales_item)
    end

    assert_redirected_to sales_items_url
  end
end
