// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ "from_date" ,'to_date','toOptions','fromOptions','byRange','byDate','pdf','account','level']

  connect() {
    console.log("range picker")
    this.toDate
    this.fromDate
  }

  toOption(){
    var toSel = this.toOptionsTarget
    this.toDate = this.to_dateTarget
    this.toDate.value= toSel.value
    // console.log(this.toDate)
  }

  fromOption() {
    var fromSel = this.fromOptionsTarget
    this.fromDate = this.from_dateTarget
    var toSel = this.toOptionsTarget
    this.toDate = this.to_dateTarget
    var fromIndex = fromSel.selectedIndex
    this.fromDate.value = fromSel.value
    toSel.selectedIndex = fromIndex
    this.toDate.value = toSel.value
    // console.log(this.fromDate)

  }
  selectPDF(){
    var url = (event.target.value)
    //  if coming from reports, accout not assigned, asign it
    if (this.hasAccountTarget) {
      const acct = this.accountTarget.value
      url += `&account=${acct}`
    }
    this.assign(url)
  }

  selectSplit(){
    var url = (event.target.value)
    //  if coming from reports, accout not assigned, asign it
    if (this.hasAccountTarget) {
      const acct = this.accountTarget.value
      url += `&account=${acct}`
    }
    this.assign(url)
  }
  selectLedger(){
    const url = (event.target.value)
    this.assign(url)
  }

  selectSummary(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    url = (`${url}?account=${acct}`+ this.getFromTo())
    location.assign(url)

  }

  selectCombo(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    url = (`${url}?account=${acct}&combo=true` + this.getFromTo() + this.getLevel())
    location.assign(url)
  }

  selectPL(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    url = (`${url}?account=${acct}&combo=true` + this.getFromTo() + this.getLevel())
    location.assign(url)
  }
  selectTrialBalance(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    url = (`${url}?account=${acct}&combo=true` + this.getFromTo() + this.getLevel())
    location.assign(url)
  }
  selectAuditPDF(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    location.assign(url)
  }

  selectAuditConfig(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    location.assign(url)
  }
  selectAuditHTML(){
    const button = event.target
    const acct = this.accountTarget.value
    var url = button.dataset.url
    location.assign(url)
  }

  accountSet(){
    console.log("account set")
    const item = event.target
    const id = item.value
    console.log(`account set ${id}`)

    Rails.ajax({
      url: "/reports/set_acct",
      type: "patch",
      data: "id="+id,
    })

  }





  getFromTo(){
    this.fromDate = this.from_dateTarget
    this.toDate = this.to_dateTarget
    if (this.fromDate.value == '' || this.toDate.value == '') {
      return('')
    }
    return(`&from=${this.fromDate.value}&to=${this.toDate.value}`)
  }
  getLevel(){
    if (this.hasLevelTarget) {
      var lev = this.levelTarget.value
      if (lev == '') {
        return('')
      }
      return(`&level=${lev}`)
    }
  }




  assign(url){
    /* this is used it two places, account ledger and report
      for reports it needs an account id it gets from optioal target account
    */
    if(url.includes("fromto=1")) {
      if ((this.fromDate != undefined) && (this.toDate != undefined)) {
        url = url.replace('fromto=1',`from=${this.fromDate.value}&to=${this.toDate.value}`)
        if (this.hasAccountTarget) {
          url += `&account=${this.accountTarget.value}`
        }
        location.assign(url)
      }else{
        alert('Sorry, from and to dates not set')
      }
    } else { 
      // url = url.replace('?','.js?')
      // Rails.ajax({
      //   type: "get",
      //   url: url,
      //   // data: new FormData(this.element)
      // })

      location.assign(url)
    }
  }

}
