class Theme < ApplicationRecord
  has_many :theme_pages, dependent: :destroy
  has_many :websites, dependent: :destroy
  has_one_attached :placeholder_image

  validates :name, presence: true, uniqueness: true

  def page_types
    theme_pages.pluck(:page_type).uniq
  end
end