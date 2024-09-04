module Api
	class DemoAssignedAccountController < ApplicationController
		protect_from_forgery with: :null_session

		def createAssignedAccount
			account = DemoAccount.new(account_name: params[:account_name], password: params[:password], account_type: params[:account_type])
			findAccount = DemoAccount.find_by(account_name: params[:account_name])

			if findAccount == nil
				if account.save
					token = encode_token({user_id: account.id})
					render json: {account_name: account.account_name, type: account.account_type, token: token}
				else
					render json: {error: account.errors.messages}, status: 422
				end
			else
				render json: false
			end
		end

		def getAssignedAccount
			accountId = decode_token(params[:token])
			assigned_accounts = DemoAssignedAccount.where(demo_account_id: accountId)
			assignments = DemoAssignment.where(demo_quiz_id: params[:quiz_id])
			for assignment in assignments
				assigned_account = assigned_accounts.find_by(demo_assignment_id: assignment.id)
				if assigned_account != nil
					render json: assigned_account
					break
				end
			end
		end

		def getAssignedAccounts
			assigned_accounts = DemoAssignedAccount.where(demo_assignment_id: params[:assignment_id]).order('demo_account_id')

			render json: assigned_accounts
		end

		def updateAccountAssigment
			assigned_account = DemoAssignedAccount.find_by(id: params[:id])
			assigned_account.score = params[:new_score]
			assigned_account.attempts = params[:new_attempts]
			if assigned_account.save
				render json: true
			else
				render json: false
			end
		end

		def getAssignmentAnswers
			data = {}
			assigned_account = DemoAssignedAccount.find_by(id: params[:id])
			data["assigned_account"] = assigned_account
			data["account"] = DemoAccount.find_by(id: assigned_account.account_id)
			assignment = DemoAssignment.find_by(id: assigned_account.assignment_id)
			data["assignment"] = assignment
			quiz = DemoQuiz.find_by(id: assignment.quiz_id)
			data["quiz"] = quiz

			attemptScore = DemoAttemptScore.where(demo_assigned_account_id: assigned_account.id).find_by(attempt: params[:attempt])
			data["attempt_score"] = attemptScore

			quizQuestions = DemoQuizQuestion.where(quiz_id: quiz.id).order('demo_question_id')
			
			data["questions"] = []
			assignmentAnswers = DemoAssignmentAnswer.where(demo_account_id: assigned_account.account_id).where(demo_assignment_id: assigned_account.demo_assignment_id).where(attempt: params[:attempt])
			for quizQuestion in quizQuestions
				answer = {}
				question = DemoQuestion.find_by(id: quizQuestion.demo_question_id)
				if question.question_type != 'Open-ended'
					rubric = DemoQuestionOption.where(question_id: question.id).order('id')
					answer = []
					for option in rubric
						assignmentAnswer = assignmentAnswers.where(demo_question_id: question.id).find_by(demo_question_option_id: option.id)
						answer.push({"rubric": option, "answer": assignmentAnswer})
					end
				else
					rubric = DemoAnswerRubric.where(demo_question_id: question.id)
					answer["rubric"] = rubric
					assignmentAnswer = assignmentAnswers.where(demo_question_id: question.id)
					answer["answer"] = assignmentAnswer
				end

				data["questions"].append({'question': question, 'answer': answer})
			end

			render json: data
		end

		def setGraded
			attemptScore = DemoAttemptScore.find_by(id: params[:attempt_score_id])
			attemptScore.graded = true
			attemptScore.save

			render json: attemptScore
		end

		def deleteAssignedAccount
			assigned_account = DemoAssignedAccount.find_by(id: params[:id])

			if assigned_account.destroy
				head :no_content
			else
				render json: {error: assigned_account.errors.messages}, status: 422
			end
		end
	end
end