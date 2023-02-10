class CreateTeachers < ActiveRecord::Migration[7.0]
  def change
    create_table :teachers do |t|
      t.string :full_name
      t.string :contact
      t.string :email
      t.string :physical_address
      t.string :sex
      t.date :joining_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
