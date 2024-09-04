import React, { useState, useContext } from 'react'
import Cookies from 'universal-cookie'
import axios from 'axios'
import { errorMessage } from '../general/functions';

/*To log in, accounts can only be created by existing users
*/
const LogInPage = () => {
  const cookies = new Cookies()

  //If there is an ongoing session go to home page
  if (cookies.get('Token') != null) {
    window.location.href = '/home'
  }

  //Handle submit form event to authenticate account with backend
  function submitForm(e) {
    e.preventDefault()
    axios.post('/api/account/0/authenticate_account', {
      account_name: e.target[0].value,
      password: e.target[1].value,
    })
    .then(resp => {
      console.log(resp)
      if (resp.data != false) {
        //If account is authenticated save JWT in cookies
        cookies.set('Name', resp.data.account_name, { path: '/' });
        cookies.set('Token', resp.data.token, { path: '/' });
        cookies.set('Type', resp.data.account_type, { path: '/' });
        window.location.href = '/home'
      }
      else {
        alert("Username or password is wrong, please double check input.")
      }
    })
    .catch(resp => errorMessage(resp.response.statusText))
  }

  return(
    <div className='log-in-page'>
      <div className='navigation-bar'>
        <img className="crest" src="/packs/media/packs/general/bb-crest-7106b85f04ce6829d39a973203d05a81.png"></img>
      </div>
      
      <form className='log-in-form' onSubmit={ submitForm }>
        <label>BB 21st Portal</label>
        <p>This is the demo version of the site!</p>
        <p>Log in with the following account to try out the website</p>
        <p>username: 'John Doe'</p>
        <p>password: 'John Doe'</p>
        <input className='log-in-form__name' placeholder='username'></input>
        <input className='log-in-form__password' type='password' placeholder='password'></input>
        <br/>
        <br/>
        <button>Log In</button>
      </form>
    </div>
  )
}

export { LogInPage }