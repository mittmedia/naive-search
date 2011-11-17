class AddNaiveSearchIndexToCity < ActiveRecord::Migration
  def up
    add_column :cities, :naive_search_index, :text
  end

  def down
    remove_column :cities, :naive_search_index
  end
end
