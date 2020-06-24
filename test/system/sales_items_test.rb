require "application_system_test_case"

class SalesItemsTest < ApplicationSystemTestCase
  setup do
    @sales_item = sales_items(:one)
  end

  test "visiting the index" do
    visit sales_items_url
    assert_selector "h1", text: "Sales Items"
  end

  test "creating a Sales item" do
    visit sales_items_url
    click_on "New Sales Item"

    fill_in "Alert", with: @sales_item.alert
    fill_in "Bottles", with: @sales_item.bottles
    fill_in "Bottles 1", with: @sales_item.bottles_1
    fill_in "Bottles 2", with: @sales_item.bottles_2
    fill_in "Cases", with: @sales_item.cases
    fill_in "Cost", with: @sales_item.cost
    fill_in "Department", with: @sales_item.department
    fill_in "Markup", with: @sales_item.markup
    fill_in "Name", with: @sales_item.name
    fill_in "Percent", with: @sales_item.percent
    fill_in "Price", with: @sales_item.price
    fill_in "Quanity", with: @sales_item.quanity
    fill_in "Size", with: @sales_item.size
    fill_in "Type", with: @sales_item.type
    click_on "Create Sales item"

    assert_text "Sales item was successfully created"
    click_on "Back"
  end

  test "updating a Sales item" do
    visit sales_items_url
    click_on "Edit", match: :first

    fill_in "Alert", with: @sales_item.alert
    fill_in "Bottles", with: @sales_item.bottles
    fill_in "Bottles 1", with: @sales_item.bottles_1
    fill_in "Bottles 2", with: @sales_item.bottles_2
    fill_in "Cases", with: @sales_item.cases
    fill_in "Cost", with: @sales_item.cost
    fill_in "Department", with: @sales_item.department
    fill_in "Markup", with: @sales_item.markup
    fill_in "Name", with: @sales_item.name
    fill_in "Percent", with: @sales_item.percent
    fill_in "Price", with: @sales_item.price
    fill_in "Quanity", with: @sales_item.quanity
    fill_in "Size", with: @sales_item.size
    fill_in "Type", with: @sales_item.type
    click_on "Update Sales item"

    assert_text "Sales item was successfully updated"
    click_on "Back"
  end

  test "destroying a Sales item" do
    visit sales_items_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Sales item was successfully destroyed"
  end
end
