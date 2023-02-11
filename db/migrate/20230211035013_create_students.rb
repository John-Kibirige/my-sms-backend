class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :full_name
      t.string :sex
      t.date :date_of_birth
      t.string :contact
      t.string :physical_address
      t.date :date_of_enrollment
      t.references :parent, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
