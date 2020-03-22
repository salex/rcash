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
 
  linkTo(){
    const goto = event.target
    const url = goto.dataset.url
    location.assign(url)
    // Rails.ajax({
    //   type: "get",
    //   url: url,
    //   // data: new FormData(this.element)
    // })
  }
}
