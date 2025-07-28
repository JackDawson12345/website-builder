class ThemePageComponent < ApplicationRecord
  belongs_to :theme_page
  belongs_to :component

  validates :position, presence: true, uniqueness: { scope: :theme_page_id }

  scope :ordered, -> { order(:position) }
end