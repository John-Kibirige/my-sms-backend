class CreateSubjects < ActiveRecord::Migration[7.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :tag
      t.string :level
      t.string :category
      t.text :description

      t.timestamps
    end
  end
end
