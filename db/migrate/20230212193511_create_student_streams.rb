class CreateStudentStreams < ActiveRecord::Migration[7.0]
  def change
    create_table :student_streams do |t|
      t.references :student, null: false, foreign_key: true
      t.references :stream, null: false, foreign_key: true

      t.timestamps
    end
  end
end
