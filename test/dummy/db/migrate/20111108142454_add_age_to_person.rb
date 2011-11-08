class AddAgeToPerson < ActiveRecord::Migration
  def up
    add_column :people, :age, :integer
  end

  def down
    remove_column :people, :age
  end
end
