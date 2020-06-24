class SalesItem < ApplicationRecord
  require 'csv'

  validates_uniqueness_of :name

  attribute :total, :integer
  attribute :purchase_price, :float

  def self.update_sales_items(csv)
    items = CSV.parse(csv)
    csvkeys = items.delete_at(0)
    keys = {name:0,price:2,cost:3,markup:4,type:5,department:6,status:7}
    sales_items = {}
    items.each do |si|
      if si[keys[:status]] == 'Active'
        sales_items[si[keys[:name]]] = {}
        sales_items[si[keys[:name]]][:name] = si[keys[:name]]
        sales_items[si[keys[:name]]][:price] = si[keys[:price]].to_f
        sales_items[si[keys[:name]]][:cost] = si[keys[:cost]].to_f
        sales_items[si[keys[:name]]][:markup] = si[keys[:markup]].to_f
        sales_items[si[keys[:name]]][:type] = si[keys[:type]]
        sales_items[si[keys[:name]]][:department] = si[keys[:department]]
        sales_items[si[keys[:name]]][:quanity] = 0
        sales_items[si[keys[:name]]][:alert] = 0
      end
    end
    sales_items.each do |k,v|
      si = SalesItem.find_by(name:v[:name])
      next if si.present?
      case v[:type]
      when 'Liquor'
        v[:size] = 1000
        Liquor.create(v)
  
      when 'Beer'
        v[:size] = 24
        Beer.create(v)
    
      when 'Beverage'
        Beverage.create(v)
      
      when 'Food'
        Food.create(v)
      end
    end
  end

  def self.seed
    # => ["Item Name", "Item UPC", "Item Price", "Cost", "Markup", "Revenue Class", "Department", "Status"]
    # Item Name,UPC,Quantity on Hand,Alert Threshold,Unit Cost,Total Cost,Unit Price,Total Price,Status

    keys = {name:0,price:2,cost:3,markup:4,type:5,department:6,status:7}
    items_path = Rails.root.join('yaml/inventory/menu-item-detail.csv')
    inventory_path = Rails.root.join('yaml/inventory/inventory-detail.csv')
    items = CSV.parse(File.read(items_path))
    quanities = CSV.parse(File.read(inventory_path))
    qkey = quanities.delete_at(0)
    cvskeys = items.delete_at(0)
    sales_items = {}

    items.each do |si|
      if si[keys[:status]] == 'Active'
        sales_items[si[keys[:name]]] = {}
        sales_items[si[keys[:name]]][:name] = si[keys[:name]]
        sales_items[si[keys[:name]]][:price] = si[keys[:price]].to_f
        sales_items[si[keys[:name]]][:cost] = si[keys[:cost]].to_f
        sales_items[si[keys[:name]]][:markup] = si[keys[:markup]].to_f
        sales_items[si[keys[:name]]][:type] = si[keys[:type]]
        sales_items[si[keys[:name]]][:department] = si[keys[:department]]
        sales_items[si[keys[:name]]][:quanity] = 0
        sales_items[si[keys[:name]]][:alert] = 0
      end
    end
    quanities.each do |q|
      item = q[0]
      quanity = q[2].to_f
      alert = q[3].to_f
      if sales_items[item].present?
        sales_items[item][:quanity] = quanity
        sales_items[item][:alert] = alert
      end
    end
    sales_items.each do |k,v|
      case v[:type]
      when 'Liquor'
        v[:size] = 1000
        Liquor.create(v)
  
      when 'Beer'
        v[:size] = 24
        Beer.create(v)
    
      when 'Beverage'
        Beverage.create(v)
      
      when 'Food'
        Food.create(v)
      end
    end
  end

end
