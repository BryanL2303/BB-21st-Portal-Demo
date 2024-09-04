module Api
	class DemoQuizController < ApplicationController
		protect_from_forgery with: :null_session

		def createQuiz
			#Check that there are no quizes with the same name within the same topic
			if (params[:award]['masteryId'] == '0')
				findQuiz = DemoQuiz.where(demo_award_id: params[:award]['awardId']).find_by(quiz_name: params[:quiz_name])
			else
				findQuiz = DemoQuiz.where(demo_mastery_id: params[:award]['masteryId']).find_by(quiz_name: params[:quiz_name])
			end

			if findQuiz == nil
				if (params[:award]['masteryId'] == '0')
					quiz = DemoQuiz.new(quiz_name: params[:quiz_name], marks: params[:marks], demo_award_id: params[:award]['awardId'], assigned: false)
				else
					quiz = DemoQuiz.new(quiz_name: params[:quiz_name], marks: params[:marks], demo_mastery_id: params[:award]['masteryId'], assigned: false)
				end
				if quiz.save
					#Create joint table associations with questions
					for id in params[:existing_questions]
						quizQuestion = DemoQuizQuestion.new(demo_quiz_id: quiz.id, demo_question_id: id)
						question = DemoQuestion.find_by(id: id)
						question['assigned'] = true
						question.save
						if quizQuestion.save
						else
							render json: {error: quizQuestion.errors.messages}, status: 422
						end
					end
					for question in params[:new_questions]
						if (params[:award]['masteryId'] == '0')
							newQuestion = DemoQuestion.new(question_type: question['question_type'], question: question['question'], marks: question['marks'], demo_award_id: params[:award]['awardId'], permanent: false, assigned: true)
						else
							newQuestion = DemoQuestion.new(question_type: question['question_type'], question: question['question'], marks: question['marks'], demo_mastery_id: params[:award]['masteryId'], permanent: false, assigned: true)
						end
						if newQuestion.save
							if question['question_type'] == 'MCQ' || question['question_type'] == 'MRQ' 
								for option in question['answer']
									questionOption = DemoQuestionOption.new(answer: option[:option], correct: option[:correct], demo_question_id: newQuestion.id)
									if questionOption.save
									else
										render json: {error: questionOption.errors.messages}, status: 422
									end
								end
							elsif question['question_type'] == 'Open-ended'
								answerRubric = DemoAnswerRubric.new(rubric: question.answer, demo_question_id: newQuestion.id)
								if answerRubric.save
								else
									render json: {error: answerRubric.errors.message}, status: 422
								end
							end
							quizQuestion = DemoQuizQuestion.new(demo_quiz_id: quiz.id, demo_question_id: newQuestion.id)
							if quizQuestion.save
							else
								render json: {error: quizQuestion.errors.messages}, status: 422
							end
						else
							render json: {error: newQuestion.errors.messages}, status: 422
						end
					end
					render json: {quiz: quiz}
				else
					render json: {error: quiz.errors.messages}, status: 422
				end
			else
				render json: false
			end
		end

		def getQuiz
			quiz = DemoQuiz.find_by(id: params[:id])
			
			render json: quiz
		end

		def getQuizzes
			if (params[:award]['masteryId'] == '0')
				quizzes = DemoQuiz.where(demo_award_id: params[:award]['awardId'])
			else
				quizzes = DemoQuiz.where(demo_mastery_id: params[:award]['masteryId'])
			end			
			
			render json: quizzes
		end

		def getQuestions
			quizQuestions = DemoQuizQuestion.where(demo_quiz_id: params[:quiz_id]).order('id')
			questions = []
			for quizQuestion in quizQuestions
				question = DemoQuestion.find_by(id: quizQuestion.demo_question_id)
				questions.push(question)
			end

			render json: questions
		end

		#This is only for submission of random questions from question bank
		def submitQuiz
		end

		def deleteQuiz
			quiz = DemoQuiz.find_by(id: params[:id])
			quizQuestions = DemoQuizQuestion.where(demo_quiz_id: quiz.id)
			for quizQuestion in quizQuestions
				question = DemoQuestion.find_by(id: quizQuestion['demo_question_id'])
				if question['permanent'] == false
					if question['question_type'] == 'Open-ended'
						rubric = DemoAnswerRubric.find_by(demo_question_id: question.id)
						rubric.destroy
					else
						options = DemoQuestionOption.where(demo_question_id: question.id)
						options.destroy_all
					end
					question.destroy
				else
					question = DemoQuestion.find_by(id: quizQuestion['demo_question_id'])
					quizzes = DemoQuizQuestion.find_by(["demo_question_id = :questionId and demo_quiz_id != :quizId", { questionId: question.id, quizId: quiz.id }])
					if quizzes == nil
						question['assigned'] = false
						question.save
					end
				end
			end
			quizQuestions.destroy_all

			if quiz.destroy
				head :no_content
			else
				render json: {error: quiz.errors.messages}, status: 422
			end
		end
	end
end