// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import Rails from '@rails/ujs';


export default class extends Controller {
  static targets = [ "splitsTbody","deletesTbody","numb" ,'description','date','transfer','debit',
  'credit','amount','balanced','submit',"theForm",'errors']

  connect() {
    let currSplits
    let currStatus
    let valid
    if (!this.haserrorsTarget){
      console.log('no errors')
      this.validate()
    }
  }

  validate(){
    // event.preventDefault()
    this.getSplits()
    this.getStatus(this.currSplits)
    this.check_valid()
  }

  changed() {
    // event.preventDefault()
    this.getSplits()
    this.getStatus(this.currSplits)
    this.check_valid()
  }

  cutRow(){
    const tr = event.target.closest('tr')
    const tbody = tr.parentNode
    tbody.removeChild(tr)
    this.changed()

  }

  deleteRow(){
    const checkbox = event.target
    const tbodySplits = this.splitsTbodyTarget
    const tbodyDeletes = this.deletesTbodyTarget
    const tr = checkbox.closest('tr')
    if (checkbox.checked == true) {
      tbodyDeletes.append(tr)
    } else {
      tbodySplits.prepend(tr)
    }
    this.changed()
  }

  submitForm(){
    const theForm = this.theFormTarget
    theForm.submit()
  }

  selectit(){
    event.target.select()
  }

  reconcile() {
    const sp = event.target
    const td = sp.closest('td')
    // const span = td.querySelector('span')
    const inpt = td.querySelector('input')
    // console.log(span)
    if (inpt.value === 'n') {
      inpt.value = 'c'

    }else if (inpt.value == 'c'){
      inpt.value = 'n'
    }
    sp.innerHTML = inpt.value
  }

  // $('#splits .s-reconcile').on 'click', (e) ->
  //   # console.log "trying to flip reconcile"
  //   td = $(this)
  //   inp = td.find('input')
  //   spn = td.find('span')
  //   if inp.val() is 'n' or '' 
  //     inp.val('c')
  //   else if inp.val() is 'c'
  //     inp.val('n')
  //   spn.text(inp.val())


  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  check_valid = function() {
    let invalid;
    let evalid =  this.entry_valid();
    if (evalid) { 
      invalid = "Entry Valid - ";
    } else {
      invalid = "Entry Invalid: Date or Desc missing - ";
    }
    const svalid = this.splits_valid(invalid);
    const button = this.submitTarget;
    if (evalid && svalid) {
      this.valid = true
      button.removeAttribute('disabled');
      button.classList.add('w3-green')
      button.classList.remove('w3-red')

      // return button.parent().css('background-color','lightgreen');
    } else {
      this.valid = false
      button.setAttribute('disabled','disabled');
      button.classList.add('w3-red')
      button.classList.remove('w3-green')
      event.preventDefault()

    }
  };

  entry_valid() {
    return(this.dateTarget.value !== '') && (this.descriptionTarget.value !== '')
  }
  splits_valid = function(evalid) {
    // console.log "START"
    let isValid;
    let balanced = this.balancedTarget;
    let balance = this.currStatus.balance
    let valid = this.currStatus.valid && (balance === 0);
    let incomplete_row = this.currStatus.incomplete_row
    if (!valid) {
      // we're goint to stuff any imbalace in a row and then toggle buttons and exit
      let imbalance_row;

      if (incomplete_row != null) {
        imbalance_row = incomplete_row;
      } else if (this.currStatus.scratch_row != null) {
        imbalance_row = this.currStatus.scratch_row;
      } else {
        imbalance_row = this.currStatus.blank_row;
      }
      // console.log(`imbalacnce row ${imbalance_row}`)
      const curr_amt = this.currSplits[imbalance_row].amount;
      const diff = curr_amt  - balance;

      // console.log "before  #{balance} c #{curr_amt} d #{diff}"
      if (diff > 0) {
        // need to offset it with a debit
        this.currSplits[imbalance_row].cr = 0;
        this.currSplits[imbalance_row].db = (diff  / 100);
        this.set_split(this.currSplits[imbalance_row]);
      } else if (diff < 0) {
        // need to offset it with a credit after abs(diff)
        this.currSplits[imbalance_row].db = 0;
        this.currSplits[imbalance_row].cr = (-diff  / 100);
        this.set_split(this.currSplits[imbalance_row]);
      } else {
        if (balance === curr_amt) {
          this.clear_split(this.currSplits[imbalance_row]);
        } else {
          alert("da problem should not happen");
        }
        // currSplits were balanced, but something added that made it balance
        // don't update split, just fall through
      }
      // lets update status in case there was a double call
      this.getSplits()
      this.getStatus(this.currSplits)
      // return(this.changed())
    }
    balance = this.currStatus.balance
    valid = this.currStatus.valid && (balance === 0);


    if (this.currStatus.valid) { 
      isValid =  `${evalid} Splits Valid: `;
    } else {
      if (this.currStatus.balance === 0) {
        isValid = `${evalid} Splits Invalid: Account Missing:`; 
      } else {
        isValid = `${evalid} Splits Invalid: Imbalanced: `;
      }
    }
    balanced.innerHTML =(isValid+ ` Balance: (${(balance / 100).toFixed(2)})`);
    if (this.currStatus.blank_rows < 2) {
      const last =  this.currSplits.length - 1;
      this.addSplit(last);
    }
    return valid;
  };

  clearAmounts() {
    // event.preventDefault()
    // var transfers = this.transferTargets
    var debits = this.debitTargets
    // var credits = this.creditTargets
    // var amounts = this.amountTargets
    // var numbSplits = debits.length
    var i
    for (i = 0;  i < debits.length; i++) {
      console.log(`gonna clear row ${i}`)
      this.clear_split(this.currSplits[i])
      // debits[i].value = ''
      // credits[i].value = ''
      // amounts[i].value = ''
    }
    this.changed()
  }

  addSplit() {
    // event.preventDefault()
    var splits = this.splitsTbodyTarget
    var new_tr = splits.lastChild.cloneNode(true)
    var old_numb = Number(new_tr.getAttribute('id').replace(/\D/g, ''))
    var new_numb = old_numb + 1
    var inputs = new_tr.querySelectorAll("input")
    var selects = new_tr.querySelectorAll("select")
    var i
    for (i = 0; i < inputs.length; i++) {
      // console.log(inputs[i])
      var iid = inputs[i].getAttribute('id')
      var iname = inputs[i].getAttribute('name')
      inputs[i].setAttribute('id',iid.replace(old_numb,new_numb))
      inputs[i].setAttribute('name',iname.replace(old_numb,new_numb))
      // console.log(inputs[i])
      if (inputs[i].value != 'n') {
        inputs[i].value = '' 
      }
    }
    for (i = 0; i < selects.length; i++) {
      // console.log(inputs[i])
      var iid = selects[i].getAttribute('id')
      var iname = selects[i].getAttribute('name')
      selects[i].setAttribute('id',iid.replace(old_numb,new_numb))
      selects[i].setAttribute('name',iname.replace(old_numb,new_numb))
      // console.log(selects[i])
    }
     splits.appendChild(new_tr)
  }

  getSplits() {
    let transfers = this.transferTargets
    let debits = this.debitTargets
    let credits = this.creditTargets
    let amounts = this.amountTargets
    let numbSplits = debits.length
    this.currSplits = []
    for (var i = 0;  i < numbSplits; i++) {
      let split = {}
      split.sindex = i 
      // node elem
      split.$cr = credits[i]
      split.$db = debits[i]
      split.$amount = amounts[i]
      split.$acct = transfers[i]
      // do addbits on db and cr
      if (debits[i].value != '') {
        debits[i].value = this.addbits(debits[i].value)
      }
      if (credits[i].value != '') {
        credits[i].value = this.addbits(credits[i].value)
      }
      // set numbers
      split.acct = Number(transfers[i].value)
      split.db = Number(debits[i].value)
      split.cr = Number(credits[i].value)
      split.amount = Number(amounts[i].value)
      split.valid = false
      split.blank = false
      split.incomplete = false
      split.credit = false
      split.debit = false
      split.scratch = false
      split.has_account =false
      split.has_amount = false
      this.currSplits[i] = split
    }
  }

  /*
   * decaffeinate suggestions:
   * DS101: Remove unnecessary use of Array.from
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  getStatus = function(splits) {
    // status changes after any of the 4 attributes are changed
    let status = {
      blank_row: null,
      incomplete_row: null,
      scratch_row: null,
      blank_rows: 0,
      balance: 0,
      sbalance: 0,
      valid: true
    };
    for (let s of Array.from(splits)) {
      this.set_split(s);
      if (s.blank) { status.blank_rows += 1; }
      if ((status.blank_row === null) && s.blank) { status.blank_row = s.sindex; }
      if ((status.incomplete_row === null) && s.incomplete) { status.incomplete_row = s.sindex; }
      if ((status.scratch_row === null) && s.scratch) { status.scratch_row = s.sindex; }
      status.valid = status.valid && s.valid;
      status.balance = (status.balance += s.amount);
      if (s.scratch) { status.sbalance = (status.sbalance += s.amount); }
    }
    this.currStatus = status
  };

  // numbChange(){
  //   // event.preventDefault()
  //   const numb = event.target
  //   const e = event
  //   if ((e.which !== 187) && (e.which !== 189)){
  //     console.log( e.which)
  //     return false
  //   } else {
  //     // console.log("got a + or - keydown")
  //     let adder, key, ltr, num;
  //     if (e.which === 187) {
  //       adder = 1;
  //     } else {
  //       adder = -1;
  //     }
  //     // e.which = 0
  //     const last_numbers = this.last_numbersTarget
  //     const json = JSON.parse(last_numbers.dataset.numbers);

  //     // console.log(json)
  //     if (numb.value === '') {
  //       key = 'numb';
  //       ltr = '';
  //       num = '';
  //     } else {
  //       const val = numb.value;
  //       ltr = val.replace(/\d+/,'');
  //       num = val.replace(/\D+/,'');
  //       if (num === '') {
  //         key = ltr;
  //       } else {
  //         numb.value = ltr + (Number(num) + adder);
  //         this.changed()       
  //         return('') ;
  //       }
  //     }

  //     // now have a key that has no number
  //     const hasKey = json.hasOwnProperty(key);
  //     // console.log( `has key ${hasKey} ${key} ${adder}`)
  //     if (key === 'numb') {
  //       // console.log("key is numb")
  //       numb.value = json[key] + adder;
  //     } else {
  //       if (hasKey) {
  //         const nxt = json[key] + adder;
  //         numb.value = key + nxt;
  //         json[key] = nxt;
  //       } else {
  //         json[key] = adder;
  //         numb.value = key+'1';
  //       }
  //     }
  //     this.changed()       
  //     return('') ;
  //   }
  // }
  

  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  clear_split = function(s) {
    s.amount = 0;
    s.cr = 0;
    s.db = 0;
    s.$cr.value = '';
    s.$db.value = '';
    s.$amount.value = '';
    this.set_state(s)
    this.getStatus
  };

  clear_amt = function(s) {
    s.amount = 0;
    s.$amount.value = (s.amount);
    return this.set_state(s);
  };

  set_db_amount = function(s) {
    const db = s.db.toFixed(2);
    s.$db.value = db;
    s.$cr.value = '';
    s.cr = 0;
    const amt = db.replace('.',''); 
    s.amount = Number(amt);
    s.$amount.value = (s.amount);
    s.debit = true;
    return this.set_state(s);
  };

  set_cr_amount = function(s) {
    const cr = s.cr.toFixed(2);
    s.$cr.value = (cr);
    s.$db.value = ('');
    s.db = 0;
    const amt = cr.replace('.',''); 
    s.amount = Number(amt) * -1;
    s.$amount.value = (s.amount);
    s.credit = true;
    return this.set_state(s);
  };

 set_dbcr_amount = function(s) {
    const amt = Number((s.db - s.cr));
    if (amt >= 0) {
      s.cr = 0;
      s.db = amt;
      return this.set_db_amount(s);
    } else { 
      s.db = 0;
      s.cr = amt * -1;
      return this.set_cr_amount(s);
    }
  };

  set_chg_dbcr_amount = function(s) {
    // console.log "chg what? id #{s.sindex} ac #{(s.acct)} db #{(s.db)} cr #{(s.cr)} amt #{(s.amount)}"
    // assume if cr and db present, they want to replace what was auto balanced with the other value
    const amt = Number((s.db - s.cr));

    if (amt >= 0) {
      // debit was last set, change to new credit
      // s.$db.val('');
      return this.set_cr_amount(s);
    } else { 
      // credit was last set, change to new debit
      s.cr = 0;
      return this.set_db_amount(s);
    }
  };

  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  set_state = function(s) {
    s.has_account = s.acct !== 0;
    s.has_amount = s.amount !== 0;
    s.debit = s.db !== 0;
    s.credit = s.cr !== 0;
    s.blank = (!s.has_account && !s.debit && !s.credit && !s.has_amount);
    s.incomplete = s.has_account && !s.debit && !s.credit && !s.has_amount;
    s.scratch = !s.has_account && (s.debit || s.credit) && s.has_amount;
    return s.valid = (s.has_account && (s.credit || s.debit)) || (s.blank || s.incomplete);
  };

  /*
   * decaffeinate suggestions:
   * DS102: Remove unnecessary code created because of implicit returns
   * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
   */
  set_split = function(s) {
    // there or 16 possible states for 4 attributes
    // 8 tests for account blank
    if (s.acct === 0) {
      // yyyy
      if ((s.db === 0)  && (s.cr === 0) && (s.amount === 0)) {
        this.set_state(s);
        return;
      }
      // yyyn
      if ((s.db === 0)  && (s.cr === 0) && (s.amount !== 0)) {
        this.clear_amt(s); 
        return;
      }
      // yyny
      if ((s.db === 0)  && (s.cr !== 0) && (s.amount === 0)) {
        this.set_cr_amount(s);
        return;
      }
      // yynn
      if ((s.db === 0)  && (s.cr !== 0) && (s.amount !== 0)) {
        this.set_cr_amount(s);
        return;
      }
      // ynyy
      if ((s.db !== 0)  && (s.cr === 0) && (s.amount === 0)) {
        this.set_db_amount(s);
        return;
      }
      // ynyn
      if ((s.db !== 0)  && (s.cr === 0) && (s.amount !== 0)) {
        this.set_db_amount(s);
        return;
      }
      // ynny
      if ((s.db !== 0)  && (s.cr !== 0) && (s.amount === 0)) {
        this.set_dbcr_amount(s);
        return;
      }
      // ynnn
      if ((s.db !== 0)  && (s.cr !== 0) && (s.amount !== 0)) {
        this.set_dbcr_amount(s);
        return;
      }
    // 8 test for account present
    } else { 
      // nyyy
      if ((s.db === 0)  && (s.cr === 0) && (s.amount === 0)) {
        this.set_state(s);
        return;
      }
      // nyyn
      if ((s.db === 0)  && (s.cr === 0) && (s.amount !== 0)) {
        this.clear_amt(s);
        return;
      }
      // nyny
      if ((s.db === 0)  && (s.cr !== 0) && (s.amount === 0)) {
        this.set_cr_amount(s);
        return;
      }
      // nynn
      if ((s.db === 0)  && (s.cr !== 0) && (s.amount !== 0)) {
        this.set_cr_amount(s);
        return;
      }
      // nnyy
      if ((s.db !== 0)  && (s.cr === 0) && (s.amount === 0)) {
        this.set_db_amount(s);
        return;
      }
      // nnyn
      if ((s.db !== 0)  && (s.cr === 0) && (s.amount !== 0)) {
        this.set_db_amount(s);
        return;
      }
      // nnny
      if ((s.db !== 0)  && (s.cr !== 0) && (s.amount === 0)) {
        this.set_dbcr_amount(s);
        return;
      }
      // nnnn
      if ((s.db !== 0)  && (s.cr !== 0) && (s.amount !== 0)) {
        this.set_chg_dbcr_amount(s);
        return;
      }
    }
    // Falling through was an error I had and fixed, but just in case
    alert(`Why did it end up here it? id ${s.sindex} ac ${(s.acct)} db ${(s.db)} cr ${(s.cr)} amt ${(s.amount)}`);
    return console.log(s);
  };

  addbits = s => // some code I found that does math calculation
    (s.replace(/\s/g, '').match(/[+\-]?([0-9\.]+)/g) || []).reduce((sum, value) => parseFloat(sum) + parseFloat(value));

}
