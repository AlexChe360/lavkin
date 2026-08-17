class CreatePaymentProviderAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :payment_provider_accounts do |t|
      t.references :account,
                   null: false,
                   foreign_key: true

      t.string :provider,
               null: false

      t.string :status,
               null: false,
               default: "draft"

      t.string :request_id
      t.string :external_client_id
      t.string :merchant_id
      t.string :terminal_number

      t.datetime :connected_at
      t.datetime :last_checked_at

      t.timestamps
    end

    add_index :payment_provider_accounts,
              [ :account_id, :provider ],
              unique: true
  end
end
