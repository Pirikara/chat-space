class CreateGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :groups do |t|
      t.string :name, null: false
      #rails5からインデックスの貼り方が以下の通りに変わった。
      t.index :name, unique: true
      t.timestamps
    end
  end
end
