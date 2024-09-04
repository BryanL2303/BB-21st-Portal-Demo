class DemoMastery < ApplicationRecord
	belongs_to :demo_award
	has_many :demo_questions
	has_many :demo_quizzes
	has_many :demo_custom_columns
end