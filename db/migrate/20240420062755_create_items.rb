class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :title
      t.string :genre
      t.boolean :is_available

      t.timestamps
    end
  end
end
