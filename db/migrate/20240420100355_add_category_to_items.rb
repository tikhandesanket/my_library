class AddCategoryToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :category, :string
    add_column :items, :user_id, :integer

  end
end
