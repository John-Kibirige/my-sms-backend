class CreateSubjectStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_students do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
