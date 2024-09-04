class DemoCustomColumn < ApplicationRecord
	belongs_to :demo_award, optional: true
	belongs_to :demo_mastery, optional: true
end