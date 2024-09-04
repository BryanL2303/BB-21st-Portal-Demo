class DemoAssignedAccount < ApplicationRecord
	belongs_to :demo_assignment
	belongs_to :demo_account
end