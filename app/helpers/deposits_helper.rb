module DepositsHelper

  def dmoney(decimal,unit="")
   return "" if decimal.zero?
    number_to_currency(decimal,unit:unit)
  end

end
