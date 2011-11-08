class AddNaiveSearchIndexToHotel < ActiveRecord::Migration
  def up
    add_column :hotels, :naive_search_index, :text
  end

  def down
    remove_column :hotels, :naive_search_index
  end
end
