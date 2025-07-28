class ThemePage < ApplicationRecord
  belongs_to :theme
  has_many :theme_page_components, -> { order(:position) }, dependent: :destroy
  has_many :components, through: :theme_page_components

  PAGE_TYPES = ['home', 'about_us', 'meet_the_team', 'services', 'testimonials', 'faqs', 'gallery', 'contact_us'].freeze

  validates :page_type, presence: true, inclusion: { in: PAGE_TYPES }
  validates :page_type, uniqueness: { scope: :theme_id }
  validates :position, presence: true

  scope :ordered, -> { order(:position) }
end