class Hotel < ActiveRecord::Base
  naive_search_on :name, :description, :order => "rate asc", :limit => 20
end
