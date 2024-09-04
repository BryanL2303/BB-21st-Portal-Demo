module Api
	class DemoAccountController < ApplicationController
		protect_from_forgery with: :null_session

		def createAccount
			account = DemoAccount.new(account_name: params[:account_name], password: params[:password], account_type: params[:account_type], rank: params[:rank], credentials: params[:credentials])
			if params[:level] != nil
				account['level'] = params[:level]
			end
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

		def authenticateAccount
			account = DemoAccount.find_by(account_name: params[:account_name])
			if account == nil
				render json: false
			else
				if account.password == params[:password]
					token = encode_token({user_id: account.id})
					render json: {account_name: account.account_name, token: token, account_type: account.account_type}
				else
					render json: false
				end
			end
		end

		def getAccount
			account = DemoAccount.find_by(id: params[:id])

			render json: account
		end

		def getAccounts
			accounts = DemoAccount.where(account_type: params[:account_type]).order('level').order('account_name')

			render json: accounts
		end

		def getOwnAccount
			accountId = decode_token(params[:token])
			account = DemoAccount.find_by(id: accountId)

			render json: account
		end

		def getAccountsByIds
			accounts = DemoAccount.where(id: params[:boy_ids]).order('level').order('account_name')

			render json: accounts
		end

		def toggleType
			account = DemoAccount.find_by(account_type: params[:account_type])
			account.type = params[:new_type]
			if account.save
				render json: true
			else
				render json: false
			end
		end

		def editAccount
			account = DemoAccount.find_by(id: params[:id])

			nameClash = DemoAccount.find_by(account_name: params[:account_name])
			if nameClash == nil || nameClash['id'] == account.id
				account['account_name'] = params[:account_name]
				account['account_type'] = params[:account_type]
				if params[:password] != nil
					account['password'] = params[:password]
				end
				account['rank'] = params[:rank]
				account['level'] = params[:level]
				account['credentials'] = params[:credentials]
				account.save
				render json: true
			else
				render json: {error: account.errors.messages}, status: 422
			end
		end

		def deleteAccount
			account = DemoAccount.find_by(account_name: params[:account_name])

			if account.destroy
				head :no_content
			else
				render json: {error: account.errors.messages}, status: 422
			end
		end

		def getAssignments
			account = decode_token(params[:token])

			if params[:award]['masteryId'] == '0'
				assignments = DemoAssignment.where(demo_award_id: params[:award]['awardId']).order('id')
			else
				assignments = DemoAssignment.where(demo_mastery_id: params[:award]['masteryId']).order('id')
			end
			quizzes = []
			for assignment in assignments
				assignedAssignments = DemoAssignedAccount.where(demo_assignment_id: assignment.id).where(demo_account_id: account)
				if assignedAssignments != []
					quiz = DemoQuiz.find_by(id: assignment.quiz_id)
					quizzes.append(quiz)
				end
			end

			render json: quizzes
		end

		def getAccountInformation
			account = DemoAccount.find_by(id: params[:id])

			render json: account
		end

		def destroy
			account = DemoAccount.find_by(id: params[:id])

			if account.destroy
				head :no_content
			else
				render json: {error: account.errors.messages}, status: 422
			end
		end
	end
end