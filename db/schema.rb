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

ActiveRecord::Schema[7.0].define(version: 2024_11_30_082101) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "guides", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "section"
    t.string "type"
  end

  create_table "points", force: :cascade do |t|
    t.string "guide_name"
    t.string "student_name"
    t.string "student_usn"
    t.string "project_title"
    t.decimal "mark1", precision: 3, scale: 1, default: "0.0"
    t.decimal "mark2", precision: 3, scale: 1, default: "0.0"
    t.decimal "mark3", precision: 3, scale: 1, default: "0.0"
    t.decimal "mark4", precision: 3, scale: 1, default: "0.0"
    t.decimal "mark5", precision: 3, scale: 1, default: "0.0"
    t.decimal "total", precision: 3, scale: 1, default: "0.0"
    t.boolean "locked", default: false
    t.bigint "presentation_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["presentation_id"], name: "index_points_on_presentation_id"
  end

  create_table "presentations", force: :cascade do |t|
    t.string "name"
    t.bigint "student_id", null: false
    t.bigint "program_id", null: false
    t.decimal "grand_total", precision: 3, scale: 1, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_presentations_on_program_id"
    t.index ["student_id"], name: "index_presentations_on_student_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "title"
    t.bigint "program_id", null: false
    t.bigint "batch_id", null: false
    t.bigint "guide_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_projects_on_batch_id"
    t.index ["guide_id"], name: "index_projects_on_guide_id"
    t.index ["program_id"], name: "index_projects_on_program_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "usn"
    t.string "name"
    t.string "section"
    t.string "c_no"
    t.decimal "mini_marks", precision: 3, scale: 1, default: "0.0"
    t.decimal "major_marks", precision: 3, scale: 1, default: "0.0"
    t.bigint "guide_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "batch_id", null: false
    t.index ["batch_id"], name: "index_students_on_batch_id"
    t.index ["guide_id"], name: "index_students_on_guide_id"
  end

  create_table "students_projects", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_students_projects_on_project_id"
    t.index ["student_id"], name: "index_students_projects_on_student_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "points", "presentations"
  add_foreign_key "presentations", "programs"
  add_foreign_key "presentations", "students"
  add_foreign_key "projects", "batches"
  add_foreign_key "projects", "guides"
  add_foreign_key "projects", "programs"
  add_foreign_key "students", "batches"
  add_foreign_key "students", "guides"
  add_foreign_key "students_projects", "projects"
  add_foreign_key "students_projects", "students"
end
