class Person < ActiveRecord::Base
  naive_search_on :name, :surname, :description
end
