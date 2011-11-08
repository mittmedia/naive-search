require 'test_helper'

class NaiveSearchTest < ActiveSupport::TestCase
  setup do
    [
      { :name => "Arnold", :surname => "Bentley", :description => "tall, skinny, dark, minnie's husband" },
      { :name => "Minnie", :surname => "Bentley", :description => "short, fat, arnold's wife" },
      { :name => "Robert", :surname => "Bentley", :description => "short, skinny, arnold's brother" },
      { :name => "Dennis", :surname => "Donaghue", :description => "ugly, annoying, minne's brother" },
      { :name => "Stan", :surname => "Donaghue", :description => "tall, handsome, minnie's dad" },
      { :name => "Tina", :surname => "Donaghue", :description => "tall, sweet, minnie's mom" },
      { :name => "Dan", :surname => "Bentley", :description => "short, stupid, arnold's dad" },
      { :name => "Julia", :surname => "Bentley", :description => "short, weird, arnold's mom" }
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
end
