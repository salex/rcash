class Stash < ApplicationRecord
  belongs_to :stashable, polymorphic: true
end
