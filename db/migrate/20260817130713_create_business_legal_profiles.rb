class CreateBusinessLegalProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :business_legal_profiles do |t|
      t.references :account,
                   null: false,
                   foreign_key: true,
                   index: { unique: true }

      # Юридическое лицо
      t.string :legal_type, null: false
      t.string :legal_name, null: false
      t.string :bin_iin, null: false
      t.string :iban

      # Адрес
      t.string :country,
               null: false,
               default: "KZ"

      t.string :postal_code
      t.string :city
      t.string :street
      t.string :building
      t.string :office

      # Руководитель / владелец ИП
      t.string :ceo_first_name
      t.string :ceo_last_name
      t.string :ceo_middle_name
      t.string :ceo_phone
      t.string :ceo_email

      # Дополнительная информация для подключения
      t.text :description

      t.timestamps
    end

    add_index :business_legal_profiles, :bin_iin
  end
end
