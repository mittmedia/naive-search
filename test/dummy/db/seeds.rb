people = [
          { :name => "Arnold", :surname => "Bentley", :description => "tall, skinny, dark, minnie's husband", :age => 48 },
          { :name => "Minnie", :surname => "Bentley", :description => "short, fat, arnold's wife", :age => 46 },
          { :name => "Robert", :surname => "Bentley", :description => "short, skinny, arnold's brother", :age => 44 },
          { :name => "Dennis", :surname => "Donaghue", :description => "ugly, annoying, minne's brother", :age => 46 },
          { :name => "Stan", :surname => "Donaghue", :description => "tall, handsome, minnie's dad", :age => 68 },
          { :name => "Tina", :surname => "Donaghue", :description => "tall, sweet, minnie's mom", :age => 66 },
          { :name => "Dan", :surname => "Bentley", :description => "short, stupid, arnold's dad", :age => 70 },
          { :name => "Julia", :surname => "Bentley", :description => "short, weird, arnold's mom", :age => 68 }
         ]

people.each do |attrs|
  Person.create(attrs)
end