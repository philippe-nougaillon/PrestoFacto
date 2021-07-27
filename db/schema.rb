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

ActiveRecord::Schema.define(version: 2021_07_27_082424) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "absences", force: :cascade do |t|
    t.bigint "enfant_id"
    t.date "début", null: false
    t.date "fin", null: false
    t.boolean "matin"
    t.boolean "midi"
    t.boolean "soir"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enfant_id"], name: "index_absences_on_enfant_id"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_postgresql_files", force: :cascade do |t|
    t.oid "oid"
    t.string "key"
    t.index ["key"], name: "index_active_storage_postgresql_files_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "titre", null: false
    t.string "corps", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "classrooms", force: :cascade do |t|
    t.bigint "structure_id"
    t.string "nom"
    t.string "référent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["structure_id"], name: "index_classrooms_on_structure_id"
  end

  create_table "comptes", force: :cascade do |t|
    t.bigint "structure_id"
    t.string "nom", default: "", null: false
    t.string "civilité"
    t.string "adresse1"
    t.string "adresse2"
    t.string "cp"
    t.string "ville"
    t.string "num_allocataire"
    t.string "mémo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "enfants_count"
    t.string "slug"
    t.bigint "organisation_id"
    t.index ["organisation_id"], name: "index_comptes_on_organisation_id"
    t.index ["slug"], name: "index_comptes_on_slug", unique: true
    t.index ["structure_id"], name: "index_comptes_on_structure_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "compte_id"
    t.string "nom"
    t.string "fixe"
    t.string "portable"
    t.string "email"
    t.string "mémo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "prevenir"
    t.index ["compte_id"], name: "index_contacts_on_compte_id"
  end

  create_table "enfants", force: :cascade do |t|
    t.bigint "compte_id"
    t.bigint "classroom_id"
    t.string "nom", default: "", null: false
    t.string "prénom"
    t.date "date_naissance"
    t.boolean "menu_sp"
    t.boolean "menu_all"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tarif_type_id"
    t.string "badge"
    t.string "slug"
    t.string "allergenes"
    t.string "mémo"
    t.index ["classroom_id"], name: "index_enfants_on_classroom_id"
    t.index ["compte_id"], name: "index_enfants_on_compte_id"
    t.index ["slug"], name: "index_enfants_on_slug", unique: true
    t.index ["tarif_type_id"], name: "index_enfants_on_tarif_type_id"
  end

  create_table "facture_chronos", force: :cascade do |t|
    t.bigint "organisation_id"
    t.integer "index", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_facture_chronos_on_organisation_id"
  end

  create_table "facture_lignes", force: :cascade do |t|
    t.bigint "facture_id"
    t.bigint "prestation_type_id"
    t.decimal "qté", precision: 4, scale: 2, default: "0.0", null: false
    t.decimal "prix", precision: 6, scale: 2, default: "0.0", null: false
    t.decimal "total", precision: 6, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "intitulé"
    t.index ["facture_id"], name: "index_facture_lignes_on_facture_id"
    t.index ["prestation_type_id"], name: "index_facture_lignes_on_prestation_type_id"
  end

  create_table "factures", force: :cascade do |t|
    t.bigint "compte_id"
    t.string "réf"
    t.datetime "date"
    t.date "échéance"
    t.decimal "montant", precision: 6, scale: 2, default: "0.0", null: false
    t.boolean "vérifiée", default: false
    t.string "mémo"
    t.datetime "envoyée_le"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "workflow_state"
    t.decimal "solde_avant", precision: 8, scale: 2
    t.decimal "solde_après", precision: 8, scale: 2
    t.index ["compte_id"], name: "index_factures_on_compte_id"
    t.index ["slug"], name: "index_factures_on_slug", unique: true
    t.index ["workflow_state"], name: "index_factures_on_workflow_state"
  end

  create_table "messages", force: :cascade do |t|
    t.string "email"
    t.string "objet"
    t.text "contenu"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "organisations", force: :cascade do |t|
    t.string "nom", default: "", null: false
    t.string "adresse"
    t.string "cp"
    t.string "ville"
    t.string "téléphone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "zone"
    t.string "slug"
    t.index ["slug"], name: "index_organisations_on_slug", unique: true
  end

  create_table "paiements", force: :cascade do |t|
    t.bigint "compte_id"
    t.datetime "date"
    t.string "réf"
    t.string "mode"
    t.string "banque"
    t.string "chèque_num"
    t.decimal "montant", precision: 5, scale: 2, default: "0.0", null: false
    t.date "date_remise"
    t.string "mémo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compte_id"], name: "index_paiements_on_compte_id"
  end

  create_table "prestation_types", force: :cascade do |t|
    t.bigint "organisation_id"
    t.string "nom", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_prestation_types_on_organisation_id"
  end

  create_table "prestations", force: :cascade do |t|
    t.bigint "enfant_id"
    t.bigint "prestation_type_id"
    t.date "date", null: false
    t.decimal "qté", precision: 3, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "facture_id"
    t.index ["enfant_id"], name: "index_prestations_on_enfant_id"
    t.index ["facture_id"], name: "index_prestations_on_facture_id"
    t.index ["prestation_type_id"], name: "index_prestations_on_prestation_type_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "enfant_id"
    t.bigint "prestation_type_id"
    t.date "début", null: false
    t.date "fin", null: false
    t.decimal "lundi", precision: 3, scale: 2, default: "0.0", null: false
    t.decimal "mardi", precision: 3, scale: 2, default: "0.0", null: false
    t.decimal "mercredi", precision: 3, scale: 2, default: "0.0", null: false
    t.decimal "jeudi", precision: 3, scale: 2, default: "0.0", null: false
    t.decimal "vendredi", precision: 3, scale: 2, default: "0.0", null: false
    t.boolean "matin"
    t.boolean "midi"
    t.boolean "soir"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.boolean "hors_période_scolaire"
    t.string "workflow_state"
    t.index ["enfant_id"], name: "index_reservations_on_enfant_id"
    t.index ["prestation_type_id"], name: "index_reservations_on_prestation_type_id"
  end

  create_table "structure_classes", force: :cascade do |t|
    t.bigint "structure_id"
    t.string "nom"
    t.string "référent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["structure_id"], name: "index_structure_classes_on_structure_id"
  end

  create_table "structures", force: :cascade do |t|
    t.bigint "organisation_id"
    t.string "nom", default: "", null: false
    t.string "adresse"
    t.string "cp"
    t.string "ville"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_structures_on_organisation_id"
  end

  create_table "tarif_types", force: :cascade do |t|
    t.bigint "organisation_id"
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organisation_id"], name: "index_tarif_types_on_organisation_id"
  end

  create_table "tarifs", force: :cascade do |t|
    t.bigint "tarif_type_id"
    t.bigint "prestation_type_id"
    t.decimal "prix", precision: 4, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prestation_type_id"], name: "index_tarifs_on_prestation_type_id"
    t.index ["tarif_type_id"], name: "index_tarifs_on_tarif_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organisation_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

  create_table "vacances", force: :cascade do |t|
    t.string "zone", default: "", null: false
    t.string "nom", default: "", null: false
    t.date "début"
    t.date "fin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organisation_id"
    t.index ["organisation_id"], name: "index_vacances_on_organisation_id"
  end

  add_foreign_key "absences", "enfants"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "classrooms", "structures"
  add_foreign_key "comptes", "organisations"
  add_foreign_key "comptes", "structures"
  add_foreign_key "contacts", "comptes"
  add_foreign_key "enfants", "classrooms"
  add_foreign_key "enfants", "comptes"
  add_foreign_key "enfants", "tarif_types"
  add_foreign_key "facture_chronos", "organisations"
  add_foreign_key "facture_lignes", "factures"
  add_foreign_key "facture_lignes", "prestation_types"
  add_foreign_key "factures", "comptes"
  add_foreign_key "paiements", "comptes"
  add_foreign_key "prestation_types", "organisations"
  add_foreign_key "prestations", "enfants"
  add_foreign_key "prestations", "factures"
  add_foreign_key "prestations", "prestation_types"
  add_foreign_key "reservations", "enfants"
  add_foreign_key "reservations", "prestation_types"
  add_foreign_key "structure_classes", "structures"
  add_foreign_key "structures", "organisations"
  add_foreign_key "tarif_types", "organisations"
  add_foreign_key "tarifs", "prestation_types"
  add_foreign_key "tarifs", "tarif_types"
  add_foreign_key "users", "organisations"
  add_foreign_key "vacances", "organisations"
end
