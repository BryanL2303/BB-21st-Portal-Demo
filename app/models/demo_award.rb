class DemoAward < ApplicationRecord
	has_many :demo_masteries
	has_many :demo_questions
	has_many :demo_quizzes
	has_many :demo_custom_columns
end