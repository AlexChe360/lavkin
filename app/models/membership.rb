class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :account

  enum :role, {
    owner: "owner",
    admin: "admin",
    manager: "manager",
    staff: "staff"
  }

  def role_name
    {
      "owner" => "Владелец",
      "admin" => "Администратор",
      "manager" => "Менеджер",
      "staff" => "Сотрудник"
    }.fetch(role, role)
  end

  validates :role,
            presence: true

  validates :user_id,
            uniqueness: {
              scope: :account_id
            }
end
