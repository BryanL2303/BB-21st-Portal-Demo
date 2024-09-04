class DemoAssignment < ApplicationRecord
	belongs_to :demo_account
	belongs_to :demo_quiz
	belongs_to :demo_award, optional: true
	belongs_to :demo_mastery, optional: true
end