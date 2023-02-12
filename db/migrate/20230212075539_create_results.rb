class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true
      t.string :mark

      t.timestamps
    end
  end
end
