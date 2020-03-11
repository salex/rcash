module DepositsHelper

  def dmoney(decimal,unit="")
   return 0 if decimal.blank? || decimal.zero?
    number_to_currency(decimal,unit:unit)
  end

end
