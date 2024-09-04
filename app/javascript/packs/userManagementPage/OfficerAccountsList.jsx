import React, { useEffect, useState, useContext } from 'react'
import Cookies from 'universal-cookie'
import axios from 'axios'

/*Display list of all officer Accounts
*/
const OfficerAccountsList = ({setPageState}) => {
  const cookies = new Cookies()
  const [officerList, setOfficerList] = useState([])

  //If there is no ongoing session go to login page
  useEffect(() => {
    if (cookies.get('Token') == null) {
      window.location.href = '/'
    } else {
      loadList()
    }
  }, [])

  //Sends the information from the form to the backend to try and create an account
  //If the username is not unique returns an alert back to the user
  function loadList() {
    axios.post('/api/account/0/get_accounts', {
      account_type: "Officer"
    })
    .then(resp => {
      setOfficerList(resp.data)
    })
    .catch(resp => errorMessage(resp.response.statusText))
  }

  function showUser(e) {
    e.preventDefault()
    setPageState(e.target.className)
  }

  return(
    <div className='officer-accounts-list'>
      {officerList.map((officer) => {
        if (officer.name == 'John Doe') {
          return(
            <button onClick={showUser} className={officer.id}>{officer.account_type} {officer.rank} {officer.account_name}</button>
          )
        }
      })}
    </div>
  )
}

export { OfficerAccountsList }