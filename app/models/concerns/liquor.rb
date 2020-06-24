class Liquor < SalesItem


  def self.model_name
    SalesItem.model_name
  end

  def unit_cost
    if self.purchase_price.present?
      shots = (size / 35.51638).to_i
      self.cost = (purchase_price / shots).round(2)
    end
  end

  def buy_liquor(params)
    ml = params[:size].to_i
    total_cost = quanity * cost
    quanity_added = (ml / 35.51638).to_i
    buy_cost = (params[:purchase_price].to_f / quanity_added).round(2)
    total_new = buy_cost * quanity_added
    self.quanity += quanity_added
    self.cost = ((total_cost + total_new) / self.quanity).round(2)
    self
  end

  def self.update_liquor(params)
    params[:liquor].each do |id,val|
      if val[:total].present?
        liquor = Liquor.find(id)
        val[:quanity] = val[:total]
        liquor.update(val)
      end
    end
  end

end
