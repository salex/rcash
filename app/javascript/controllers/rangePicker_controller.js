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
  static targets = [ "from_date" ,'to_date','toOptions','fromOptions','byRange','byDate','pdf']

  connect() {
    // console.log("range_picker")
    this.toDate
    this.fromDate
  }

  toOption(){
    var toSel = this.toOptionsTarget
    this.toDate = this.to_dateTarget
    this.toDate.value= toSel.value
    console.log(this.toDate)
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
  }
  selectPDF(){
    console.log('wants a ledger pdf')
    console.log(event.target)
    const url = (event.target.value)
    this.assign(url)


  }

  selectSplit(){
    console.log('wants a split ledger pdf')
    console.log(event.target)
    const url = (event.target.value)
    this.assign(url)

  }
  selectLedger(){
    console.log('wants a html ledger')
    console.log(event.target)
    const url = (event.target.value)
    this.assign(url)

  }

  assign(url){
    if(url.includes("fromto=1")) {
      if ((this.fromDate != undefined) && (this.toDate != undefined)) {
        url = url.replace('fromto=1',`from=${this.fromDate.value}&to=${this.toDate.value}`)
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
