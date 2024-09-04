class DemoTopic < ApplicationRecord
	has_many :demo_questions
	has_many :demo_quizzes
end