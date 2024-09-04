import React, { useEffect, useState, useContext } from 'react'
import Cookies from 'universal-cookie'
import axios from 'axios'
import {NavigationBar} from '../general/NavigationBar'
import {ManualResultPage} from './ManualResultPage'

/*To manually create 32A results
*/
const ResultGenerationPage = () => {
  const cookies = new Cookies()
  const [awards, setAwards] = useState([])
  const [masteries, setMasteries] = useState([])
  const [award, setAward] = useState();
  const [mastery, setMastery] = useState();
  const [masteryLevel, setMasteryLevel] = useState()
  const [boyAccounts, setBoyAccounts] = useState([])
  const [primerAccounts, setPrimerAccounts] = useState([])
  const [officerAccounts, setOfficerAccounts] = useState([])
  const [pdf, setPdf] = useState(false)
  const [awardId, setAwardId] = useState()
  const [instructorId, setInstructorId] = useState()
  const [boys, setBoys] = useState([])
  const [columns, setColumns] = useState([])
  const [limiter, setLimiter] = useState(false)
  const [customDescription, setCustomDescription] = useState()
  const [columnContents, setColumnContents] = useState({})

  //If there is no ongoing session go to login page
  if (cookies.get('Token') == null) {
    window.location.href = '/'
  }

  useEffect(() => {
    //make axios call and set awards and accounts
    axios.post('/api/award/0/get_awards', {
    })
    .then(resp => {
      setAwards(resp.data['awards'])
      setMasteries(resp.data['masteries'])
      setAward(resp.data['awards'][0])
      setAwardId(resp.data['awards'][0].id)
      setMasteryLevel('0')
    })
    .catch(resp => errorMessage(resp.response.statusText))
    axios.post('/api/account/0/get_accounts', {
      'account_type': 'Boy'
    })
    .then(resp => {
      setBoyAccounts(resp.data)
    })
    .catch(resp => errorMessage(resp.response.statusText))
    axios.post('/api/account/0/get_accounts', {
      'account_type': 'Primer'
    })
    .then(resp => {
      setPrimerAccounts(resp.data)
      let blank = true
      if (resp.data.length > 0) {
        setInstructorId(resp.data[0].id)
        blank = false
      }
      axios.post('/api/account/0/get_accounts', {
        'account_type': 'Officer'
      })
      .then(resp => {
        setOfficerAccounts(resp.data)
        if (blank == true) {
          setInstructorId(resp.data[0].id)
        }
      })
      .catch(resp => {
        setOfficerAccounts([])
      })
    })
    .catch(resp => {console.log(resp)})
  }, [])

  function selectAward(e) {
    let data = e.target.value.split(" ")
    setAwardId(data[0])
    setMasteryLevel(data[1])
    setCustomDescription()
    setColumnContents({})
    //make axios call and set states
    axios.post('/api/award/' + data[0] + '/get_award', {
      'id': data[0]
    })
    .then(resp => {
      setAward(resp.data)
      setCustomDescription(resp.data.results_description)
      if (resp.data.has_mastery) {
        axios.post('/api/award/' + data[0] + '/get_masteries', {
          'award_id': data[0]
        })
        .then(resp => {
          console.log(resp.data)
          setMastery(resp.data[parseInt(data[1]) - 1])
          let descriptionBoxes = document.getElementsByClassName('result-description')
          for (let descriptionBox of descriptionBoxes) {
            descriptionBox.value = resp.data[parseInt(data[1]) - 1].results_description
          }
          setCustomDescription(resp.data[parseInt(data[1]) - 1].results_description)
          axios.post('/api/mastery/' + resp.data[parseInt(data[1]) - 1].id + '/get_columns', {
            'id': resp.data[parseInt(data[1]) - 1].id
          })
          .then(resp => {
            setColumns(resp.data)
          })
          .catch(resp => console.log(resp.response.statusText))
        })
        .catch(resp => console.log(resp.response))
      }
      else {
        setMastery()
        let descriptionBox = document.getElementsByClassName('result-description')
        descriptionBox.map((descriptionBox) => {
          descriptionBox.value = resp.data.results_description
        })
        axios.post('/api/award/' + resp.data.id + '/get_columns', {
          'id': resp.data.id
        })
        .then(resp => {
          setColumns(resp.data)
        })
        .catch(resp => console.log(resp.response.statusText))
      }
    })
    .catch(resp => errorMessage(resp.response.statusText))
  }

  function selectInstructor(e) {
    setInstructorId(e.target.value)
  }

  function selectBoy(e) {
    let boyAccountSelector = document.getElementsByClassName('boy-account-selector')
    let accounts = []
    for (let account of boyAccountSelector) {
      if (account.checked) {
        accounts.push(account.id)
      }
    }
    axios.post('/api/account/0/get_accounts_by_ids', {
      'boy_ids': accounts
    })
    .then(resp => {
      setBoys(resp.data)
    })
    .catch(resp => errorMessage(resp.response.statusText))
  }

  function updateCustomDescription(e) {
    e.preventDefault()
    setCustomDescription(e.target.value)
  }

  //Sends the information from the form to the backend to create assignment
  //If the form is not fully filled returns an alert to the user
  function generateResult(e) {
    e.preventDefault()
    // Check for any  invalid inputs and warns users
    if (instructorId == null) {
      alert("Results cannot be generated without any Primers or Officers.")
    }
    else {
      let i = 1
      let data = {}
      columns.map((column) => {
        data[column.column_title] = []
      })
      // edit the form such that when a new award is selected reset the entire form
      boys.map((boy) => {
        columns.map((column) => {
          if (e.target[i] != null && e.target[i].value != '') {
            data[column.column_title].push(e.target[i].value)
          }
          i += 1
        })
      })
      setColumnContents(data)

      document.getElementsByClassName('fields')[0].hidden = true
      document.getElementsByClassName('fields')[1].hidden = true
      setPdf(true)
    }
  }

  function undoPdf(e) {
    e.preventDefault()
    setPdf(false)
    document.getElementsByClassName('fields')[0].hidden = false
    document.getElementsByClassName('fields')[1].hidden = false
  }

  return(
    <div className='result-generation-page'>
      <NavigationBar/>
      <div className='page-container'>
        <div className='main-block'>
          <div className='fields'>
          <h1>Generate Results</h1>
          <br/>
          <p>Pick the badge to generate results for</p>
          <select onChange={selectAward}>
            {awards.map((award, index) => {
              if (!award.has_mastery && award.has_results) {
                return(
                  <option value={String(award.id) + ' ' + '0'}>{award.badge_name}</option>
                )
              } 
              else {
                let array = []
                masteries[index].map((mastery, index) => {
                  if (mastery.has_results) {
                    array.push(<option value={String(award.id) + ' ' + String(index + 1)}>{award.badge_name} {mastery.mastery_name}</option>)
                  }
                })
                return(array)
              }
            })}            
          </select>
          <br/>
          <br/>
          <p>Pick the instructor for the badgework</p>
          <select onChange={selectInstructor}>
            {primerAccounts.map((primerAccount) => {
              return(
                <option value={primerAccount.id}>{primerAccount.rank} {primerAccount.account_name}</option>
              )
            })}
            {officerAccounts.map((officerAccount) => {
              return(
                <option value={officerAccount.id}>{officerAccount.rank} {officerAccount.account_name}</option>
              )
            })}
          </select>
          <br/>
          <br/>
          <p>Pick the Boys to include in the results</p>
          {boyAccounts.map((boyAccount) => {
            return(
              <div className='account-display'>
                <input type='checkbox' className='boy-account-selector' id={boyAccount.id} onChange={selectBoy}></input>
                <label> Sec {boyAccount.level} {boyAccount.rank} {boyAccount.account_name}</label>
              </div>
            )
          })}
          <br/>
          </div>
          <form className='fields' onSubmit={generateResult}>
            {award != null && mastery == null && award.custom_description && <div>
              <br/>
              <label>Description of badgework:</label>
              <br/>
              <label>{award.description_cue}</label>
              <br/>
              <textarea className='result-description' onBlur={updateCustomDescription} defaultValue={award.results_description}></textarea>
              <br/>
            </div>}
            {award != null && mastery == null && award.has_custom_columns && <div>
              <label>Fields of custom columns:</label>
              <br/>
              <table>
                <thead>
                  <tr>
                    <th>Name</th>
                    {columns.map((column) =>{
                      return(
                        <th>{column.column_title}</th>
                      )
                    })}
                  </tr>
                </thead>
                <tbody>
                  {boys.map((boy) => {
                    return(
                      <tr>
                        <th>Sec {boy.level} {boy.rank} {boy.account_name}</th>
                        {columns.map((column) =>{
                          return(
                            <th><input id={column.column_title}></input></th>
                          )
                        })}
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>}
            {award != null && mastery != null && mastery.custom_description && <div>
              <br/>
              <label>Description of badgework:</label>
              <br/>
              <label>{mastery.description_cue}</label>
              <br/>
              <textarea className='result-description' onBlur={updateCustomDescription} defaultValue={mastery.results_description}></textarea>
              <br/>
            </div>}
            {award != null && mastery != null && mastery.has_custom_columns && <div>
              <label>Fields of custom columns:</label>
              <br/>
              <table>
                <thead>
                  <tr>
                    <th>Name</th>
                    {columns.map((column) =>{
                      return(
                        <th>{column.column_title}</th>
                      )
                    })}
                  </tr>
                </thead>
                <tbody>
                  {boys.map((boy) => {
                    return(
                      <tr>
                        <th>Sec {boy.level} {boy.rank} {boy.account_name}</th>
                        {columns.map((column) =>{
                          return(
                            <th><input id={column.column_title}></input></th>
                          )
                        })}
                      </tr>
                    )
                  })}
                </tbody>
              </table>
            </div>}
            <button>Generate Results</button>
          </form>
        {pdf && <ManualResultPage award={award} mastery={mastery} instructorId={instructorId} boys={boys} customDescription={customDescription} columns={columns} columnContents={columnContents}/>}
        {pdf && <button onClick={undoPdf}>Change fields</button>}
        </div>
      </div>
    </div>
  )
}

export { ResultGenerationPage }