class DemoAssignmentAnswer < ApplicationRecord
	belongs_to :demo_account
	belongs_to :demo_assignment
	belongs_to :demo_question
	belongs_to :demo_question_option, optional: true
end