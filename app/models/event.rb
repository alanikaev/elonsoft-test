class Event < ApplicationRecord
  mount_uploader :image, ImageUploader

  validates :title, presence: true, uniqueness: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :desc, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :image, presence: true
  validates :link, presence: true, url: true

  belongs_to :organizer
end
