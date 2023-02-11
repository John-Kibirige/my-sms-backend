class CreateParents < ActiveRecord::Migration[7.0]
  def change
    create_table :parents do |t|
      t.string :full_name
      t.string :contact
      t.string :physical_address
      t.string :sex
      t.integer :number_of_students
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
