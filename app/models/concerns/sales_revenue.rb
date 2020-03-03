class SalesRevenue < Revenue
 
  def self.sales_revenue_totals(dids)
    sales = SalesRevenue.where(deposit_id:dids)
    items = sales.pluck(:item).uniq
    obj = {}
    items.each do |i|
      rsales = sales.where(item:i)
      obj[i] = {quanity:rsales.sum(:quanity),amount:rsales.sum(:amount)}
    end
    obj
  end

end