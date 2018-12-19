class Event < ApplicationRecord
  mount_uploader :image, ImageUploader
  mount_uploader :attachment_file, AttachmentUploader

  validates :title, presence: true, uniqueness: true
  validates :date, presence: true
  validates :start_time, presence: true
  validates :desc, presence: true
  validates :city, presence: true
  validates :address, presence: true
  validates :image, presence: true
  validates :link, presence: true, url: true

  belongs_to :organizer

  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings

  def all_tags
    self.tags.map(&:name).join(', ')
  end

  def all_tags=(names)
    self.tags = names.split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
