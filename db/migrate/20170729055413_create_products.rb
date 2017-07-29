class CreateProducts < ActiveRecord::Migration[5.1]
  def up
    create_table :products do |t|
      t.string "address"
      t.string "city"
      t.string "storeid"
      t.string "storename"
      t.string "zipcode"
      t.string "productname"
      t.decimal "price", :precision => 2
      t.decimal "thc"
      t.decimal "thcvalue"
      t.timestamps
    end
  end

  def down
    drop_table :products
  end
end
