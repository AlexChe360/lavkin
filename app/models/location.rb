class Location < ApplicationRecord
  belongs_to :shop

  has_many :inventory_levels,
            dependent: :destroy

  has_many :products,
          through: :inventory_levels

  has_many :inventory_movements,
          dependent: :restrict_with_error

  has_many :inventory_counts,
         dependent: :restrict_with_error

  before_validation :normalize_code

  validates :name,
            presence: true

  validates :code,
            presence: true,
            uniqueness: {
              scope: :shop_id
            }

  scope :active,
          -> { where(active: true) }

  private

  def normalize_code
    self.code =
      code.to_s
        .strip
        .downcase
        .parameterize
  end
end
