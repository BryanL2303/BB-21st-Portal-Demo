Rails.application.routes.draw do
  root "pages#index"

  namespace :api do
    resources :admin do
      member do
        post '/get_tables' => 'demo_admin#getTables'
        post '/get_table_names' => 'demo_admin#getTableNames'
        post '/get_table' => 'demo_admin#getTable'
        post '/add_data' => 'demo_admin#addData'
        post '/update_data' => 'demo_admin#updateData'
        post '/delete_data' => 'demo_admin#deleteData'
      end
    end

    resources :account do 
      member do
        post '/create_account' => 'demo_account#createAccount'
        post '/authenticate_account' => 'demo_account#authenticateAccount'
        post '/get_account' => 'demo_account#getAccount'
        post '/get_accounts' => 'demo_account#getAccounts'
        post '/get_own_account' => 'demo_account#getOwnAccount'
        post '/get_accounts_by_ids' => 'demo_account#getAccountsByIds'
        post '/toggle_type' => 'demo_account#toggleType'
        post '/edit_account' => 'demo_account#editAccount'
        post '/delete_account' => 'demo_account#deleteAccount'
        post '/get_assignments' => 'demo_account#getAssignments'
        post '/get_account_information' => 'demo_account#getAccountInformation'
      end
    end

    resources :award do
      member do
        post '/create_award' => 'demo_award#createAward'
        post '/get_award' => 'demo_award#getAward'
        post '/edit_award' => 'demo_award#editAward'
        post '/get_awards' => 'demo_award#getAwards'
        post '/get_masteries' => 'demo_award#getMasteries'
        post '/get_quizzes' => 'demo_award#getQuizzes'
        post '/get_questions' => 'demo_award#getQuestions'
        post '/get_columns' => 'demo_award#getColumns'
        post '/delete_award' => 'demo_award#deleteAward'
      end
    end

    resources :mastery do
      member do
        post '/get_columns' => 'demo_mastery#getColumns'
      end
    end

    resources :quiz do
      member do
        post '/create_quiz' => 'demo_quiz#createQuiz'
        post '/get_quiz' => 'demo_quiz#getQuiz'
        post '/get_quizzes' => 'demo_quiz#getQuizzes'
        post '/get_questions' => 'demo_quiz#getQuestions'
        post '/submit_quiz' => 'demo_quiz#submitQuiz'
        post '/delete_quiz' => 'demo_quiz#deleteQuiz'
      end
    end

    resources :question do
      member do
        post '/create_question' => 'demo_question#createQuestion'
        post '/get_question' => 'demo_question#getQuestion'
        post '/get_questions' => 'demo_question#getQuestions'
        post '/get_options' => 'demo_question#getOptions'
        post '/get_rubric' => 'demo_question#getRubric'
        post '/edit_question' => 'demo_question#editQuestion'
        post '/set_permanent' => 'demo_question#setPermanent'
        post '/delete_question' => 'demo_question#deleteQuestion'
      end
    end

    resources :question_option do
      member do
        post '/create_option' => 'demo_question_option#createOption'
        post '/edit_option' => 'demo_question_option#editOption'
        post '/delete_option' => 'demo_question_option#deleteOption'
      end
    end

    resources :answer_rubric do 
      member do
        post '/create_rubric' => 'demo_answer_rubric#createRubric'
        post '/edit_rubric' => 'demo_answer_rubric#editRubric'
        post '/delete_rubric' => 'demo_answer_rubric#deleteRubric'
      end
    end

    resources :quiz_question do 
      member do
      end
    end

    resources :assignment do 
      member do
        post '/create_assignment' => 'demo_assignment#createAssignment'
        post '/get_assignment' => 'demo_assignment#getAssignment'
        post '/get_assignments' => 'demo_assignment#getAssignments'
        post '/submit_assignment' => 'demo_assignment#submitAssignment'
        post '/grade_question' => 'demo_assignment#gradeQuestion'
        post '/get_results_information' => 'demo_assignment#getResultsInformation'
        post '/delete_assignment' => 'demo_assignment#deleteAssignment'
      end
    end

    resources :assigned_account do 
      member do
        post '/create_assigned_account' => 'demo_assigned_account#createAssignedAccount'
        post '/get_assigned_account' => 'demo_assigned_account#getAssignedAccount'
        post '/get_assigned_accounts' => 'demo_assigned_account#getAssignedAccounts'
        post '/get_assignment_answers' => 'demo_assigned_account#getAssignmentAnswers'
        post '/update_assigned_account' => 'demo_assigned_account#updateAssignedAccount'
        post '/set_graded' => 'demo_assigned_account#setGraded'
        post '/delete_assigned_account' => 'demo_assigned_account#deleteAssignedAccount'
      end
    end

    resources :uniform_inspection do 
      member do
        post '/create_uniform_inspection' => 'demo_uniform_inspection#createUniformInspection'
        post '/get_inspection' => 'demo_uniform_inspection#getInspection'
        post '/get_inspections' => 'demo_uniform_inspection#getInspectionsSummary'
        post '/get_component_fields' => 'demo_uniform_inspection#getComponentFields'
        post '/delete_uniform_inspection' => 'demo_uniform_inspection#deleteUniformInspection'
      end
    end
  end

  get '*path', to: 'pages#index', via: :all
end
