class CreateMemberInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :member_invitations do |t|
      t.references :account, null: false, foreign_key: true
      t.references :invited_by, null: false, foreign_key: { to_table: :users }
      t.string :email, null: false
      t.string :role, null: false
      t.string :token, null: false
      t.datetime :accepted_at
      t.datetime :expires_at, null: false

      t.timestamps
    end

    add_index :member_invitations,
              :token,
              unique: true

    add_index :member_invitations,
              [ :account_id, :email ]
  end
end
