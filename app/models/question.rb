class Question < ActiveRecord::Base
	attr_accessible :title, :author, :answer, :choice_a, :choice_b, :choice_c, :choice_d, :choice_e, :topic_id

	belongs_to :topic
	accepts_nested_attributes_for :topic

	def self.generate
		json = File.open("lib/assets/questions.json")
		questionsList = MultiJson.load(json, :symbolize_keys => false)
		questionsList["topics"].keys.each do |topic|

			if Topic.find_by_name(topic).nil?
				t = Topic.create!(name: topic)
			end

			if not questionsList["topics"][topic]["questions"].nil?

				questionsList["topics"][topic]["questions"].each do |question|
					q = Question.create!(title: question["title"], answer: question["answer"])

					if not question["options"].nil?
						q.choice_a = question["options"][0]
						q.choice_b = question["options"][1]
						q.choice_c = question["options"][2]
						q.choice_d = question["options"][3]
						q.choice_e = question["options"][4]

					end

					q.save

					t.questions << q
				end
			end
		end
	end
end
