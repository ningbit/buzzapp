#generates topics and questions from questions.json in lib/assets

Topic.create!(:name => "Tech Breakfast")

puts "created topic 'Tech Breakfast'"

Question.generate

puts "seeded questions from JSON"