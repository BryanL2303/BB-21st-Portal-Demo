import React, { useEffect } from 'react'
import Cookies from 'universal-cookie'
import axios from 'axios'

/*To access quizes and create new ones
*/
const NavigationBar = () => {
  const cookies = new Cookies()

  //On render hide the user menu
  useEffect(() => {
    if (cookies.get('Name') != null) {
      let userMenu = document.getElementsByClassName('user-menu')[0]
      userMenu.style['visibility'] = 'hidden'
    }
  }, [cookies.get('Name')])

  //Go to QuizPage
  function quizPage () {
    window.location.href = '/quiz'
  }

  //Go to QuestionBankPage
  function questionBankPage () {
    window.location.href = '/question_bank'
  }

  //Go to QuizBankPage
  function quizBankPage () {
    window.location.href = '/quiz_bank'
  }

  //Go to UserManagementPage
  function userManagementPage () {
    window.location.href = '/user_management'
  }

  //Go to AwardManagementPage
  function awardManagementPage () {
    window.location.href = '/awards'
  }

  //Go to ResultGenerationPage
  function resultGenerationPage () {
    window.location.href = '/generate_result'
  }

  //Go to UniformInspectionPage
  function uniformInspectionPage () {
    window.location.href = '/uniform_inspection_results'
  }

  function helpPage () {
    window.location.href = '/help'
  }

  //Go to ResetPasswordPage
  function resetPasswordPage () {
    window.location.href = '/reset_password'
  }

  //Logout the user by removing the token issued to the user
  function logOut () {
    cookies.remove('Name',{path:'/'});
    cookies.remove('Token',{path:'/'});
    cookies.remove('Type',{path:'/'});
    window.location.href = '/'
  }

  //Lets the user access the user menu
  function showUserMenu(e) {
    let userMenu = document.getElementsByClassName('user-menu')[0]
    if (userMenu.style['visibility'] == 'hidden') {
      userMenu.style['visibility'] = 'visible'
    }
    else {
      userMenu.style['visibility'] = 'hidden'
    }
  }

  function toUrl(url) {
    window.location.href = url
  }

  //The functions within the usermenu
  const UserMenu = () => {
    return(
      <div className='user-menu'>
        {cookies.get("Type") == "Admin" && <button className="admin--button" onClick={() => {toUrl('/admin')}}>Admin Page</button>}
        {false && cookies.get("Type") == "Boy" && <button className="quiz--button" onClick={quizPage}>Quizzes</button>}
        {false && cookies.get("Type") != "Boy" && <button className="question-bank--button" onClick={questionBankPage}>Questions</button>}
        {false && cookies.get("Type") != "Boy" && <button className="quiz-bank--button" onClick={quizBankPage}>Quizzes</button>}
        {cookies.get("Type") != "Boy" && <button className="user-management--button" onClick={userManagementPage}>Users Management</button>}
        {cookies.get("Type") != "Boy" && <button className="award-management--button" onClick={awardManagementPage}>Awards</button>}
        {cookies.get("Type") != "Boy" && <button className="result-generation--button" onClick={resultGenerationPage}>Result Generation</button>}
        {cookies.get("Type") != "Boy" && <button className="uniform-inspection--button" onClick={uniformInspectionPage}>Uniform Inspection</button>}
        {cookies.get("Type") != "Boy" && <button className="help--button" onClick={helpPage}>Help</button>}
        {cookies.get("Name") != "John Doe" && <button onClick={resetPasswordPage}>Reset Password</button>}
        <button className="log-out--button" onClick={logOut}>Log Out</button>
      </div>
    )
  }

  return(
    <div className='navigation-bar'>
      <img className="crest" src="/packs/media/packs/general/bb-crest-7106b85f04ce6829d39a973203d05a81.png"></img>
      <button className="account-dropdown" onClick={showUserMenu}><img src="/packs/media/packs/general/sidebar-icon-d04f396ba76b9667ee34744d3127b961.jpg"></img></button>
      <UserMenu/>
    </div>
  )
}

export { NavigationBar }