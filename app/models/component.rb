class Component < ApplicationRecord
  has_many :theme_page_components, dependent: :destroy
  has_many :theme_pages, through: :theme_page_components
  has_many :website_contents, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :html_content, presence: true

  # Store editable field configurations as JSON
  attribute :editable_fields, :string, default: '[]'

  COMPONENT_TYPES = ['header', 'hero', 'content', 'footer', 'sidebar', 'gallery', 'contact'].freeze
  validates :component_type, inclusion: { in: COMPONENT_TYPES }

  scope :by_type, ->(type) { where(component_type: type) }

  def editable_fields_array
    JSON.parse(editable_fields || '[]')
  rescue JSON::ParserError
    []
  end

  def editable_fields_array=(array)
    self.editable_fields = array.to_json
  end
end