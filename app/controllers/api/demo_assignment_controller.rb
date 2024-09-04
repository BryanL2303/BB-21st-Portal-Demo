module Api
	class DemoAssignmentController < ApplicationController
		protect_from_forgery with: :null_session

		def createAssignment
			account = decode_token(params[:token])
			if params[:award][:masteryId] == '0'
				assignment = DemoAssignment.new(demo_account_id: account, demo_quiz_id: params[:quiz_id], demo_award_id: params[:award][:awardId], assignment_name: params[:assignment_name], attempt_limit: params[:attempt_limit], show_answer: params[:show_answer])
			else
				assignment = DemoAssignment.new(demo_account_id: account, demo_quiz_id: params[:quiz_id], demo_mastery_id: params[:award][:masteryId], assignment_name: params[:assignment_name], attempt_limit: params[:attempt_limit], show_answer: params[:show_answer])
			end

			if assignment.save
				quiz = DemoQuiz.find_by(id: params[:quiz_id])
				quiz['assigned'] = true
				quiz.save
				for accountId in params[:accounts]
					assigned_account = DemoAssignedAccount.new(demo_account_id: accountId, demo_assignment_id: assignment.id, score: 0, attempts: 0)
					assigned_account.save
				end
				render json: assignment
			else
				render json: {error: assignment.errors.messages}, status: 422
			end			
		end

		def getAssignment
			if params[:id] == '0'
				accountId = decode_token(params[:token])
				assignments = DemoAssignment.where(demo_quiz_id: params[:quiz_id])
				data = {}
				for assignment in assignments
					assigned_account = DemoAssignedAccount.find_by(demo_account_id: accountId, demo_assignment_id: assignment.id)
					if assigned_account != nil
						attemptScore = DemoAttemptScore.find_by(attempt: assigned_account.attempts, demo_assigned_account_id: assigned_account.id)
						data['assigned_account'] = assigned_account
						data['attemptScore'] = attemptScore
					end
				end
				render json: data
			else
				assignment = DemoAssignment.find_by(id: params[:id])
				render json: assignment
			end
		end

		def getAssignments
			if params[:award]['masteryId'] == '0'
				assignments = DemoAssignment.where(demo_award_id: params[:award]['awardId']).order('id')
			else
				assignments = DemoAssignment.where(demo_mastery_id: params[:award]['masteryId']).order('id')
			end

			render json: assignments
		end

		def submitAssignment
			accountId = decode_token(params[:token])
			assignments = DemoAssignment.where(demo_quiz_id: params[:quiz_id])
			graded = true
			for assignment in assignments
				assigned_accounts = DemoAssignedAccount.where(demo_assignment_id: assignment.id)
				assigned_account = assigned_accounts.find_by(demo_account_id: accountId)
				if assigned_account != nil
					quiz = DemoQuiz.find_by(id: params[:quiz_id])
					assigned_account.attempts += 1
					marks = 0.0
					for answer in params[:answers]
						question = DemoQuestion.find_by(id: answer['demo_question_id'])
						if question.question_type == 'MCQ'
							assignmentAnswer = DemoAssignmentAnswer.new(demo_account_id: accountId, demo_assignment_id: assigned_account.demo_assignment_id, demo_question_id: answer['demo_question_id'], attempt: assigned_account.attempts, question_type: question.question_type)
							option = DemoQuestionOption.find_by(id: answer['selected'][0])
							assignmentAnswer.demo_question_option_id = option.id
							if option.correct
								marks += question.marks
								assignmentAnswer.score = question.marks
							else
								assignmentAnswer.score = 0
							end
							assignmentAnswer.save
						end
						if question.question_type == 'MRQ'
							partial = 0.0
							correctAnswers = 0
							temporary = 0.0
							options = DemoQuestionOption.where(demo_question_id: answer['demo_question_id'])
							for option in options
								if option.correct
									correctAnswers += 1
								end
							end
							partial = question.marks / correctAnswers
							for optionId in answer['selected']
								option = DemoQuestionOption.find_by(id: optionId)
								assignmentAnswer = DemoAssignmentAnswer.new(demo_account_id: accountId, demo_assignment_id: assigned_account.demo_assignment_id, demo_question_id: answer['demo_question_id'], attempt: assigned_account.attempts, question_type: question.question_type)
								assignmentAnswer.demo_question_option_id = option.id
								assignmentAnswer.score = 0
								assignmentAnswer.save
								if option.correct
									temporary += partial
								else
									temporary -= partial
								end
							end
							if temporary >= 0.0
								assignmentAnswers = DemoAssignmentAnswer.where(demo_account_id: accountId, demo_assignment_id:assigned_account.demo_assignment_id, demo_question_id: answer['demo_question_id'])
								for assignmentAnswer in assignmentAnswers
									assignmentAnswer.score = temporary
									assignmentAnswer.save
								end
								marks += temporary
							end
						end
						if question.question_type == 'Open-ended'
							graded = false
							assignmentAnswer = DemoAssignmentAnswer.new(demo_account_id: accountId, demo_assignment_id: assigned_account.demo_assignment_id, demo_question_id: answer['demo_question_id'], attempt: assigned_account.attempts, question_type: question.question_type, score: 0, comments: '')
							assignmentAnswer.answer = answer['selected']
							assignmentAnswer.save
						end	
					end
					if marks > assigned_account.score
						assigned_account.score = marks
					end
					attemptScore = DemoAttemptScore.new(demo_assigned_account_id: assigned_account.id, attempt: assigned_account.attempts, score: marks, graded: graded)
					attemptScore.save
					assigned_account.save
					
					render json: assigned_account
				end
			end
		end

		def gradeQuestion
			assignmentAnswer = DemoAssignmentAnswer.find_by(id: params[:id])
			assignmentAnswer.comments = params[:comments]

			assigned_account = DemoAssignedAccount.where(demo_assignment_id: assignmentAnswer.demo_assignment_id).find_by(demo_account_id: assignmentAnswer.demo_account_id)
			attemptScore = DemoAttemptScore.where(demo_assigned_account_id: assigned_account.id).find_by(attempt: assignmentAnswer.attempt)

			oldScore = assignmentAnswer.score
			attemptScore.score -= oldScore
			attemptScore.score += params[:score].to_f
			attemptScore.save

			attemptScores = DemoAttemptScore.where(demo_assigned_account_id: assigned_account.id)
			highestScore = 0
			for attemptScore in attemptScores
				if attemptScore.score > highestScore
					highestScore = attemptScore.score
				end
			end
			assigned_account.score = highestScore
			assigned_account.save

			assignmentAnswer.score = params[:score]
			assignmentAnswer.save

			render json: assignmentAnswer
		end

		def getResultsInformation
			data = {}
			accountId = decode_token(params[:token])
			account = DemoAccount.find_by(id: accountId)
			data['account'] = account
			assignment = DemoAssignment.find_by(id: params[:id])
			data['assignment'] = assignment
			assigned_accounts_temp = DemoAssignedAccount.where(demo_assignment_id: assignment.id)
			assigned_accounts = []
			for assigned_account in assigned_accounts_temp
				account = DemoAccount.find_by(id: assigned_account.demo_account_id)
				assigned_accounts.push(account)
			end
			data['assigned_accounts'] = assigned_accounts
			quiz = DemoQuiz.find_by(id: assignment.demo_quiz_id)
			if quiz.demo_mastery_id == nil
				award = DemoAward.find_by(id: quiz.demo_award_id)
				data['award'] = award
			else
				mastery = DemoMastery.find_by(id: quiz.demo_mastery_id)
				award = DemoAward.find_by(id: mastery.demo_award_id)
				data['award'] = award
				data['mastery'] = mastery
			end

			render json: data
		end

		def deleteAssignment
			assignment = DemoAssignment.find_by(id: params[:id])

			assigned_accounts = DemoAssignedAccount.where(demo_assignment_id: params[:id])
			for assigned_account in assigned_accounts
				attemptScores = DemoAttemptScore.where(demo_assigned_account_id: assigned_account.id)
				attemptScores.destroy_all
				assignmentAnswers = DemoAssignmentAnswer.where(demo_account_id: assigned_account.demo_account_id).where(demo_assignment_id: assigned_account.demo_assignment_id)
				assignmentAnswers.destroy_all
			end
			assigned_accounts.destroy_all

			quiz_id = assignment["demo_quiz_id"]

			if assignment.destroy
				assignments = DemoAssignment.where(demo_quiz_id: quiz_id)
				if assignments == nil
					quiz = DemoQuiz.find_by(id: quiz_id)
					quiz["assigned"] = false
					quiz.save
				end
				head :no_content
			else
				render json: {error: assignment.errors.messages}, status: 422
			end
		end
	end
end