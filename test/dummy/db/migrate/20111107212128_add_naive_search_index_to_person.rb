class AddNaiveSearchIndexToPerson < ActiveRecord::Migration
  def up
    add_column :people, :naive_search_index, :text
  end

  def down
    remove_column :people, :naive_search_index
  end
end
