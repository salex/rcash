# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :book
end