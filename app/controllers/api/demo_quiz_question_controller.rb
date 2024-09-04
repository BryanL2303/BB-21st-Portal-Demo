module Api
	class DemoQuizQuestionController < ApplicationController
		protect_from_forgery with: :null_session
	end
end