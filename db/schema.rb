# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_12_131659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "full_name"
    t.string "sex"
    t.string "contact"
    t.string "email"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "exams", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.string "term"
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_exams_on_subject_id"
  end

  create_table "parents", force: :cascade do |t|
    t.string "full_name"
    t.string "contact"
    t.string "physical_address"
    t.string "sex"
    t.integer "number_of_students"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_parents_on_user_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.bigint "student_id", null: false
    t.string "mark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_results_on_exam_id"
    t.index ["student_id"], name: "index_results_on_student_id"
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.string "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "full_name"
    t.string "sex"
    t.date "date_of_birth"
    t.string "contact"
    t.string "physical_address"
    t.date "date_of_enrollment"
    t.bigint "parent_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_students_on_parent_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "subject_students", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_subject_students_on_student_id"
    t.index ["subject_id"], name: "index_subject_students_on_subject_id"
  end

  create_table "subject_teachers", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_subject_teachers_on_subject_id"
    t.index ["teacher_id"], name: "index_subject_teachers_on_teacher_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.string "tag"
    t.string "level"
    t.string "category"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teachers", force: :cascade do |t|
    t.string "full_name"
    t.string "contact"
    t.string "email"
    t.string "physical_address"
    t.string "sex"
    t.date "joining_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teachers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "admins", "users"
  add_foreign_key "exams", "subjects"
  add_foreign_key "parents", "users"
  add_foreign_key "results", "exams"
  add_foreign_key "results", "students"
  add_foreign_key "students", "parents"
  add_foreign_key "students", "users"
  add_foreign_key "subject_students", "students"
  add_foreign_key "subject_students", "subjects"
  add_foreign_key "subject_teachers", "subjects"
  add_foreign_key "subject_teachers", "teachers"
  add_foreign_key "teachers", "users"
end
