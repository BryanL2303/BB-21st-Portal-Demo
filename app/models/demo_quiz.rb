class DemoQuiz < ApplicationRecord
	belongs_to :demo_award, optional: true
	belongs_to :demo_mastery, optional: true
	has_and_belongs_to_many :demo_questions, join_table: 'demo_quiz_questions'
end