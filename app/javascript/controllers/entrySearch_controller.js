// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "hidden",'showButton' ]

  connect() {
    // console.log("got a autocomplete")
  }

  addSearched() {
    console.log( "searched")
    var entryID = this.hiddenTarget.value
    console.log(entryID)
    location.assign(`/entries/${entryID}/duplicate`)

    // var form = this.addForm
    // var id_input = this.player_id
    // var status = this.statusTarget
    // id_input.value = playerID
    // status.classList.toggle('w3-hide')
    // form.classList.toggle('w3-hide')
  }

  showSearched(){
    var showButton = this.showButtonTarget
    showButton.classList.toggle('w3-hide')
  }
}
