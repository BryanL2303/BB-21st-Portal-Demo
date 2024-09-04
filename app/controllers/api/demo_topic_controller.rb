module Api
	class DemoTopicController < ApplicationController
		protect_from_forgery with: :null_session

		def createTopic
			findTopic = DemoTopic.find_by(topic_name: params[:topic_name])

			if findTopic == nil
				topic = DemoTopic.new(topic_name: params[:topic_name])
				if topic.save
					render json: {topic_name: topic.topic_name}
				else
					render json: {error: topic.errors.messages}, status: 422
				end
			else
				render json: false
			end
		end

		def getTopics
			topics = DemoTopic.all.order('topic_name')
			
			render json: topics
		end

		def getQuizzes
			topic = DemoTopic.find_by(topic_name: params[:topic_name])
			quizzes = DemoQuiz.where(demo_topic_id: topic.id)
			
			render json: quizzes
		end

		def getQuestions
			topic = DemoTopic.find_by(topic_name: params[:topic_name])
			questions = DemoQuestion.where(demo_topic_id: topic.id, question_type: params[:question_type]).order('permanent')
			
			render json: questions
		end

		def deleteTopic
			quizzes = DemoQuiz.where(demo_topic_id: params[:topic_id])
			quizzes.destroy_all
			topic = DemoTopic.find_by(topic_name: params[:topic_name])
			#Need to loop through all replies, comments and topics related to this account
			#and delete them all

			if topic.destroy
				head :no_content
			else
				render json: {error: topic.errors.messages}, status: 422
			end
		end
	end
end