class CreateTenGrands < ActiveRecord::Migration[6.1]
  def change
    create_table :ten_grands do |t|
      t.integer :Status, default: 1
      t.integer :Score, default: 0
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
