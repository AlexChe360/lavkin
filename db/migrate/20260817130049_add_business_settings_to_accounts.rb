class AddBusinessSettingsToAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :email, :string
    add_column :accounts, :phone, :string

    add_column :accounts,
               :timezone,
               :string,
               null: false,
               default: "Asia/Almaty"

    add_column :accounts,
               :currency,
               :string,
               null: false,
               default: "KZT"
  end
end
