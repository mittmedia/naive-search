class AddNaiveSearchIndexTo<%= class_name.singularize %> < ActiveRecord::Migration
  def up
    add_column :<%= class_name.tableize %>, :naive_search_index, :text
  end

  def down
    remove_column :<%= class_name.tableize %>, :naive_search_index
  end
end
