module Api
	class DemoUniformInspectionController < ApplicationController
		protect_from_forgery with: :null_session

		def createUniformInspection
			assessorId = decode_token(params[:token])
			for boy in params[:boys]
				uniformInspection = DemoUniformInspection.new(demo_account_id: boy['id'], demo_assessor_id: assessorId, date: params[:date])
				uniformInspection.save
				totalScore = 0
				components = DemoUniformComponent.all.order('id')
				for component in components
					fields = DemoComponentField.where(demo_uniform_component_id: component.id)
					for field in fields
						if params[:selectedContents][boy['id'].to_s][component.id.to_s][field.id.to_s]
							selectedComponent = DemoSelectedComponent.new(demo_uniform_inspection_id: uniformInspection.id, demo_component_field_id: field.id)
							selectedComponent.save
							totalScore += DemoComponentField.find_by(id: field.id).score
						end
					end
				end
				uniformInspection.total_score = totalScore
				uniformInspection.save
			end

			render json: true
		end

		def getInspection
			inspection = DemoUniformInspection.find_by(id: params[:id])
			accounts = DemoAccount.where(account_type: 'Boy').order('id')
			boy = DemoAccount.find_by(id: inspection.demo_account_id)
			inspections = {}
			boys = []
			for account in accounts
				accountInspections = DemoUniformInspection.where(demo_account_id: account.id).order('id')
				if accountInspections != []
					boys.push(account)
					inspections[account.id] = {'inspections': accountInspections}
					for accountInspection in accountInspections
						selectedComponents = DemoSelectedComponent.where(demo_uniform_inspection_id: accountInspection.id)
						componentIds = {}
						for selectedComponent in selectedComponents
							componentIds[selectedComponent.id] = true
						end
						assessor = DemoAccount.find_by(id: accountInspection.assessor_id)
						inspections[account.id][accountInspection.id] = {selectedComponents: componentIds, inspection: accountInspection, assessor: assessor}
					end
				end
			end
			data = {'boy': boy, 'inspections': inspections, 'boys': boys}

			render json: data
		end

		def getInspectionsSummary
			accounts = DemoAccount.where(account_type: 'Boy').order('level').order('account_name')
			data = {'boys': accounts}
			for account in accounts
				inspection = DemoUniformInspection.where(demo_account_id: account.id).order('created_at')[-1]
				data[account.id] = inspection
				if inspection != nil
					data[inspection.assessor_id] = DemoAccount.find_by(id: inspection.assessor_id)
				end
			end

			render json: data
		end

		def getComponentFields
			uniformComponents = DemoUniformComponent.all.order('id')
			components = []
			data = {}
			for component in uniformComponents
				fields = DemoComponentField.where('demo_uniform_component_id': component.id)
				components.push(component)
				data[component['component_name']] = fields
			end
			data['components'] = components
			render json: data
		end

		def deleteUniformInspection
			assignment = DemoAssignment.find_by(id: params[:id])

			assigned_accounts = DemoAssignedAccount.where(demo_assignment_id: params[:id])
			for assigned_account in assigned_accounts
				attemptScores = DemoAttemptScore.where(demo_assigned_account_id: assigned_account.id)
				attemptScores.destroy_all
				assignmentAnswers = DemoAssignmentAnswer.where(demo_account_id: assigned_account.account_id).where(demo_assignment_id: assigned_account.demo_assignment_id)
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