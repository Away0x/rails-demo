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

ActiveRecord::Schema.define(version: 2021_02_28_051524) do

  create_table "categories", charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.integer "weight", default: 0, comment: "分类权重"
    t.integer "products_counter", default: 0, comment: "产品数量"
    t.string "ancestry", comment: "树结构的子关联字段"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_categories_on_ancestry"
    t.index ["title"], name: "index_categories_on_title"
  end

  create_table "products", charset: "utf8", force: :cascade do |t|
    t.integer "category_id", comment: "外键指向 categories 表"
    t.string "title"
    t.string "status", default: "off", comment: "off 下架, on 上架"
    t.integer "amount", default: 0, comment: "库存数"
    t.string "uuid", comment: "商品序列号"
    t.decimal "msrp", precision: 10, scale: 2, comment: "市场建议零售价"
    t.decimal "price", precision: 10, scale: 2, comment: "销售价"
    t.text "description", comment: "商品描述"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["status", "category_id"], name: "index_products_on_status_and_category_id"
    t.index ["title"], name: "index_products_on_title"
    t.index ["uuid"], name: "index_products_on_uuid", unique: true
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uuid"
    t.string "phone"
    t.index ["email"], name: "index_users_on_email"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

end
