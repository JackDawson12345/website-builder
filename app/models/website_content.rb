class WebsiteContent < ApplicationRecord
  belongs_to :website
  belongs_to :component

  validates :website_id, uniqueness: { scope: :component_id }

  attribute :content, :string, default: '{}'

  def get_content_for_field(field_name)
    content_hash = JSON.parse(content || '{}')
    content_hash[field_name] || ''
  rescue JSON::ParserError
    ''
  end

  def set_content_for_field(field_name, value)
    content_hash = JSON.parse(content || '{}')
    content_hash[field_name] = value
    self.content = content_hash.to_json
  rescue JSON::ParserError
    self.content = { field_name => value }.to_json
  end

  def content_hash
    JSON.parse(content || '{}')
  rescue JSON::ParserError
    {}
  end
end