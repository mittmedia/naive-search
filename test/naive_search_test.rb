require 'test_helper'

class NaiveSearchTest < ActiveSupport::TestCase
  setup do
    [
      { :name => "Arnold", :surname => "Bentley", :description => "tall, skinny, dark, minnie's husband", :age => 50 },
      { :name => "Minnie", :surname => "Bentley", :description => "short, fat, arnold's wife", :age => 48 },
      { :name => "Robert", :surname => "Bentley", :description => "short, skinny, arnold's brother", :age => 46 },
      { :name => "Dennis", :surname => "Donaghue", :description => "ugly, annoying, minne's brother", :age => 46 },
      { :name => "Stan", :surname => "Donaghue", :description => "tall, handsome, minnie's dad", :age => 70 },
      { :name => "Tina", :surname => "Donaghue", :description => "tall, sweet, minnie's mom", :age => 69 },
      { :name => "Dan", :surname => "Bentley", :description => "short, stupid, arnold's dad", :age => 75 },
      { :name => "Julia", :surname => "Bentley", :description => "short, weird, arnold's mom", :age => 72 }
     ].each do |attrs|
       Person.create(attrs)
     end

     [
       { :name => "Holiday Inn", :description => "cheap, dirty, great breakfast", :rate => 95 },
       { :name => "Holiday Lodge", :description => "cheap, clean, simple breakfast", :rate => 100 },
       { :name => "Holiday Motel", :description => "nice, simple, great breakfast", :rate => 90 },
       { :name => "Holiday Stay", :description => "moderate, simple, nice breakfast", :rate => 130 }
      ].each do |attrs|
        Hotel.create(attrs)
      end
  end
  
  test "result order" do
    hotels = Hotel.search_for("cheap great breakfast").map(&:name)
    assert_equal ["Holiday Inn", "Holiday Motel", "Holiday Lodge", "Holiday Stay"], hotels, "should order matches by relevance #1"

    hotels = Hotel.search_for("cheap clean").map(&:name)
    assert_equal "Holiday Lodge", hotels.first, "should order matches by relevance #2"
  end
  
  test "relevance" do
    relevance_arnold_bentley = Person.order("id asc").map{|p| p.relevance_for "arnold bentley" }
    assert_equal [6, 4, 4, 0, 0, 0, 4, 4], relevance_arnold_bentley, "should calculate correct relevance for 'arnold bentley'"

    relevance_bentley = Person.order("id asc").map{|p| p.relevance_for "bentley" }
    assert_equal [6, 6, 6, 0, 0, 0, 6, 6], relevance_bentley, "should calculate correct relevance for 'bentley'"

    relevance_great_breakfast = Hotel.order("id asc").map{|h| h.relevance_for "great breakfast" }
    assert_equal [4, 1, 4, 1], relevance_great_breakfast, "should calculate correct relevance for 'great breakfast'"

    relevance_nice_breakfast = Hotel.order("id asc").map{|h| h.relevance_for "nice breakfast" }
    assert_equal [1, 1, 2, 4], relevance_nice_breakfast, "should calculate correct relevance for 'nice breakfast'"
  end
  
  test "updating" do
    new_person = Person.create(:name => "Abraham", :surname => "Lincoln", :description => "nice hat!", :age => 56)
    assert_equal "Abraham\nLincoln\nnice hat!", new_person.naive_search_index, "should store value of the indexed fields in the search index"
  
    new_person.age = 57
    new_person.send :update_naive_search_index

    assert_equal ["age"], new_person.changed, "should not change the search index #1"
    assert_equal "Abraham\nLincoln\nnice hat!", new_person.naive_search_index, "should not change the search index #2"
  end
  
  test "pagination" do
    page_one = Person.search_for("arnold bentley", 1, 2).map(&:name)
    page_two = Person.search_for("arnold bentley", 2, 2).map(&:name)
    
    assert_equal ["Julia", "Dan"], page_one
    assert_equal ["Robert", "Minnie"], page_two
  end
end
