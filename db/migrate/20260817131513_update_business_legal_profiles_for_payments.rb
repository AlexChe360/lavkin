class UpdateBusinessLegalProfilesForPayments < ActiveRecord::Migration[8.1]
  def change
    rename_column :business_legal_profiles,
                  :company_type,
                  :legal_type

    add_column :business_legal_profiles,
               :office,
               :string

    add_column :business_legal_profiles,
               :iban,
               :string

    add_column :business_legal_profiles,
               :description,
               :text
  end
end
