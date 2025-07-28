class Website < ApplicationRecord
  belongs_to :user
  belongs_to :theme
  has_many :website_contents, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true, format: { with: /\A[a-z0-9\-]+\z/ }
  validates :user_id, uniqueness: true # One website per customer

  before_validation :generate_subdomain, if: :new_record?

  scope :published, -> { where(published: true) }

  def url
    "#{subdomain}.yourwebsitebuilder.com"
  end

  private

  def generate_subdomain
    return if subdomain.present?

    base_subdomain = name.parameterize
    counter = 1

    while Website.exists?(subdomain: base_subdomain)
      base_subdomain = "#{name.parameterize}-#{counter}"
      counter += 1
    end

    self.subdomain = base_subdomain
  end
end