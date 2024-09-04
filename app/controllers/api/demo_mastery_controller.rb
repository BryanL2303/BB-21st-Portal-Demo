module Api
	class DemoMasteryController < ApplicationController
		protect_from_forgery with: :null_session

		def createMastery
			mastery = DemoMastery.new(mastery_name: params[:mastery_name], mastery_requirements: params[:mastery_requirements], results_description: params[:results_description], recommended_level: params[:recommended_level])
			if mastery.save
				render json: mastery
			else
				render json: {error: mastery.errors.messages}, status: 422
			end
		end

		def getMastery
			mastery = DemoMastery.find_by(id: params[:id])
			
			render json: mastery
		end

		def getColumns
			columns = DemoCustomColumn.where(demo_mastery_id: params[:id])

			render json: columns
		end

		def getQuestions
			
		end

		def deleteAward
			if topic.destroy
				head :no_content
			else
				render json: {error: topic.errors.messages}, status: 422
			end
		end
	end
end