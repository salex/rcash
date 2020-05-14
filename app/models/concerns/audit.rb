class Inventory < Stash
  after_initialize :set_stashable

  def set_stashable
    if self.new_record?
      self.stashable_id = 1
      self.stashable_type = "Stash"
    end
  end
end