class Organizer < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_one :event
end
