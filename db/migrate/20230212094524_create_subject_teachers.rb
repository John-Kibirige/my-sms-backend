class CreateSubjectTeachers < ActiveRecord::Migration[7.0]
  def change
    create_table :subject_teachers do |t|
      t.references :subject, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
