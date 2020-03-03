// app/javascript/controllers/ajax_request_controller.js
import { Controller } from "stimulus"

// Import UJS so we can access the Rails.ajax method
import Rails from "@rails/ujs";

/*
 *
 * Usage:
 * <form data-controller="ajax-request" data-ajax-request-url="/sample-path">
 *   <button data-action="click->ajax-request#makeRequest">Make Request</button>
 * </form>
 *
 */
export default class extends Controller {

  /*
   * https://github.com/rails/rails/blob/cb3b37b37975ceb1d38bec9f02305ff5c14ba8e9/actionview/app/assets/javascripts/rails-ujs/utils/ajax.coffee#L15
   * UJS has a nice Rails.ajax method, which worked in older version of IE & is a lot like jQuery's $.ajax
   */
  makeRequest() {
    Rails.ajax({
      type: "post",
      url: this.data.get('url'),
      // data: new FormData(this.element)
    })
  }
}
