class DemoQuizQuestion < ApplicationRecord
	belongs_to :demo_quiz
	belongs_to :demo_question
end