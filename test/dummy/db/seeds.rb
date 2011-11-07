people = [
          { :name => "Arnold", :surname => "Bentley", :description => "tall, skinny, dark, minnie's husband" },
          { :name => "Minnie", :surname => "Bentley", :description => "short, fat, arnold's wife" },
          { :name => "Robert", :surname => "Bentley", :description => "short, skinny, arnold's brother" },
          { :name => "Dennis", :surname => "Donaghue", :description => "ugly, annoying, minne's brother" },
          { :name => "Stan", :surname => "Donaghue", :description => "tall, handsome, minnie's dad" },
          { :name => "Tina", :surname => "Donaghue", :description => "tall, sweet, minnie's mom" },
          { :name => "Dan", :surname => "Bentley", :description => "short, stupid, arnold's dad" },
          { :name => "Julia", :surname => "Bentley", :description => "short, weird, arnold's mom" }
         ]

people.each do |attrs|
  Person.create(attrs)
end