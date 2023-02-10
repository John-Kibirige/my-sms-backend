class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :full_name
      t.string :sex
      t.string :contact
      t.string :email
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
