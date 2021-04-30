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

ActiveRecord::Schema.define(version: 2021_04_29_212510) do

  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "public_display"
  end

  create_table "activity_categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "category_id"
    t.index ["activity_id"], name: "index_activity_categories_on_activity_id"
    t.index ["category_id"], name: "index_activity_categories_on_category_id"
  end

  create_table "activity_equipment", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "activity_id"
    t.bigint "equipment_id"
    t.decimal "quantity", precision: 10, scale: 3
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["activity_id"], name: "index_activity_equipment_on_activity_id"
    t.index ["equipment_id"], name: "index_activity_equipment_on_equipment_id"
  end

  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "parent_id"
    t.string "type"
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "consortia", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_consortia_on_category_id"
  end

  create_table "consortium_activities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "association_id"
    t.bigint "activity_id"
    t.index ["activity_id"], name: "index_consortium_activities_on_activity_id"
    t.index ["association_id"], name: "index_consortium_activities_on_association_id"
  end

  create_table "consortium_events", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "association_id"
    t.bigint "event_id"
    t.index ["association_id"], name: "index_consortium_events_on_association_id"
    t.index ["event_id"], name: "index_consortium_events_on_event_id"
  end

  create_table "consortium_locations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "association_id"
    t.bigint "location_id"
    t.index ["association_id"], name: "index_consortium_locations_on_association_id"
    t.index ["location_id"], name: "index_consortium_locations_on_location_id"
  end

  create_table "consortium_users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "association_id"
    t.bigint "user_id"
    t.index ["association_id"], name: "index_consortium_users_on_association_id"
    t.index ["user_id"], name: "index_consortium_users_on_user_id"
  end

  create_table "contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "lastname"
    t.string "firstname"
    t.string "phone_number"
    t.string "email"
    t.bigint "coordinate_id"
    t.index ["coordinate_id"], name: "index_contacts_on_coordinate_id"
  end

  create_table "coordinates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "street"
    t.integer "zip_code"
    t.string "city"
    t.string "country"
  end

  create_table "dimensions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "width", precision: 10, scale: 3
    t.decimal "length", precision: 10, scale: 3
    t.decimal "height", precision: 10, scale: 3
    t.decimal "weight", precision: 10, scale: 3
  end

  create_table "equipment", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id"
    t.bigint "supplier_id"
    t.bigint "dimension_id"
    t.decimal "unit_price", precision: 10, scale: 3
    t.index ["category_id"], name: "index_equipment_on_category_id"
    t.index ["dimension_id"], name: "index_equipment_on_dimension_id"
    t.index ["supplier_id"], name: "index_equipment_on_supplier_id"
  end

  create_table "event_activities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "activity_id"
    t.integer "simultaneous_activities"
    t.index ["activity_id"], name: "index_event_activities_on_activity_id"
    t.index ["event_id"], name: "index_event_activities_on_event_id"
  end

  create_table "event_categories", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_event_categories_on_category_id"
    t.index ["event_id"], name: "index_event_categories_on_event_id"
  end

  create_table "event_equipment", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "equipment_id"
    t.decimal "quantity", precision: 10, scale: 3
    t.index ["equipment_id"], name: "index_event_equipment_on_equipment_id"
    t.index ["event_id"], name: "index_event_equipment_on_event_id"
  end

  create_table "events", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "location_id"
    t.string "price"
    t.datetime "registration_deadline"
    t.integer "min_participant"
    t.integer "max_participant"
    t.bigint "contact_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "type"
    t.index ["contact_id"], name: "index_events_on_contact_id"
    t.index ["location_id"], name: "index_events_on_location_id"
  end

  create_table "location_activities", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "activity_id"
    t.index ["activity_id"], name: "index_location_activities_on_activity_id"
    t.index ["location_id"], name: "index_location_activities_on_location_id"
  end

  create_table "locations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.bigint "contact_id"
    t.bigint "dimension_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "capacity"
    t.string "street"
    t.integer "zip_code"
    t.string "city"
    t.string "country"
    t.index ["contact_id"], name: "index_locations_on_contact_id"
    t.index ["dimension_id"], name: "index_locations_on_dimension_id"
  end

  create_table "profiles", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id"
    t.string "gender"
    t.date "birthdate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_profiles_on_contact_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "registrations", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "user_id"
    t.decimal "price", precision: 10, scale: 3
    t.datetime "confirmation_datetime"
    t.datetime "payment_confirmation_datetime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_registrations_on_event_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "supplier_contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "supplier_id"
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_supplier_contacts_on_contact_id"
    t.index ["supplier_id"], name: "index_supplier_contacts_on_supplier_id"
  end

  create_table "suppliers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "zip_code"
    t.string "city"
    t.string "country"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.boolean "admin", default: false
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
