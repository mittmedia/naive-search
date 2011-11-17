class City < ActiveRecord::Base
  naive_search_on :name
end
