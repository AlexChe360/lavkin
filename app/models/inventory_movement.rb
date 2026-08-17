class InventoryMovement < ApplicationRecord
  belongs_to :product
  belongs_to :location

  OPERATIONS = %w[
    receipt
    write_off
    adjustment
    transfer_out
    transfer_in
    sale
    return
  ].freeze

  validates :quantity_change,
            numericality: {
              only_integer: true,
              other_than: 0
            }

  validates :operation,
            presence: true,
            inclusion: {
              in: OPERATIONS
            }

  def operation_name
    case operation
    when "receipt"
      "Приход"
    when "write_off"
      "Списание"
    when "adjustment"
      "Корректировка"
    when "transfer_out"
      "Перемещение со склада"
    when "transfer_in"
      "Перемещение на склад"
    when "sale"
      "Продажа"
    when "return"
      "Возврат"
    else
      operation
    end
  end
end
