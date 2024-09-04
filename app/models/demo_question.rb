class DemoQuestion < ApplicationRecord
	belongs_to :demo_award, optional: true
	belongs_to :demo_mastery, optional: true
	has_many :demo_question_options
	has_many :demo_answer_rubrics
	has_and_belongs_to_many :demo_quizzes, join_table: 'demo_quiz_questions'
end