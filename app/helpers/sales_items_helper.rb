module SalesItemsHelper

  def index_path(si)
    send("#{si.type.downcase}_sales_items_path")
  end
end
