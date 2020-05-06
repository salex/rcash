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
  static targets = [ 'bottles',"wbottles", "cbottles","cases",'total','size','percent','ckd']

  connect() {
    if (this.hasPercentTarget) {
      this.updateLiquor('no')
    }else{
      this.updateBeer('no')
    }
  }

  updateBeer(x){
    this.totalTarget.value = this.wbottles + this.cbottles + (this.cases * this.size )
    if (x != 'no') {
      this.ckdTarget.checked = true
    }
  }

  updateLiquor(x){
    const shots = ((this.size * (this.percent / 100.0)) / 35.5)
    const bottles = ((this.bottles  * this.size) / 35.5)
    this.totalTarget.value = Math.round(bottles + shots)
    if (x != 'no') {
      this.ckdTarget.checked = true
    }

  }

  get cases(){
    return Number(this.casesTarget.value)
  }
  get wbottles(){
    return Number(this.wbottlesTarget.value)
  }
  get cbottles(){
    return Number(this.cbottlesTarget.value)
  }
  get size(){
    return Number(this.sizeTarget.value)
  }
  get bottles(){
    return Number(this.bottlesTarget.value)
  }
  get percent(){
    return Number(this.percentTarget.value)
  }





}

