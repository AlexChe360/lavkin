# Общая логика slug для Shop, Product и Category.
#
#   class Category < ApplicationRecord
#     include Sluggable
#     self.slug_scope_column = :shop_id   # уникальность внутри магазина
#   end
#
# Поведение:
# - slug пустой: строится из name (кириллица транслитерируется),
#   при занятости получает суффикс -2, -3...
# - slug введён вручную: нормализуется (латиница, цифры, дефисы).
#   Занятость покажет обычная валидация uniqueness в модели.
module Sluggable
  extend ActiveSupport::Concern

  SLUG_FORMAT = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

  included do
    class_attribute :slug_scope_column, instance_writer: false, default: nil

    before_validation :normalize_slug

    validates :slug,
              presence: true,
              format: { with: SLUG_FORMAT, allow_blank: true }
  end

  private

  def normalize_slug
    if slug.blank?
      self.slug = unique_slug(Slugifier.call(name))
    else
      self.slug = Slugifier.call(slug)
    end
  end

  def unique_slug(base)
    return base if base.blank?

    candidate = base
    counter = 2

    while slug_siblings.exists?(slug: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end

    candidate
  end

  def slug_siblings
    siblings = self.class.where.not(id: id)
    siblings = siblings.where(slug_scope_column => self[slug_scope_column]) if slug_scope_column
    siblings
  end
end
