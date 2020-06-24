
class Beer < SalesItem
  def self.model_name
    SalesItem.model_name
  end


  def buy_beer(params)
    cases = params[:cases].to_i
    total_cost = quanity * cost
    quanity_added = (cases * self.size).to_i
    buy_cost = (params[:purchase_price].to_f / quanity_added).round(2)
    total_new = buy_cost * quanity_added
    self.quanity += quanity_added
    self.cost = ((total_cost + total_new) / self.quanity).round(2)
    self
  end

  def self.update_beer(params)
    params[:beer].each do |id,val|
      if val[:total].present?
        beer = Beer.find(id)
        val[:quanity] = val[:total]
        beer.update(val)
      end
    end
  end



end

