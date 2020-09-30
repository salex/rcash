// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "hidden",'showButton']

  connect() {
    console.log("got a search")
  }

  addSearched() {
    var entryID = this.hiddenTarget.value
    location.assign(`/entries/${entryID}/duplicate`)
  }

  showSearched(){
    var showButton = this.showButtonTarget
    showButton.classList.toggle('w3-hide')
  }

}
