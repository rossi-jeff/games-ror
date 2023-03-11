class CreateWords < ActiveRecord::Migration[6.1]
  def change
    create_table :words do |t|
      t.string :Word, limit: 30
      t.integer :Length

      t.timestamps
    end
  end
end
