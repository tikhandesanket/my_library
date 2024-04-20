class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.integer :max_books
      t.integer :max_magazines

      t.timestamps
    end
  end
end
