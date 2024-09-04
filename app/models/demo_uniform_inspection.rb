class DemoUniformInspection < ApplicationRecord
	has_many :demo_selected_components
	belongs_to :demo_account
end