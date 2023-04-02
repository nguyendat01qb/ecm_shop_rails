import '../../lib/notify';

function AMain(options) {
  var module = this;
  var defaults = {
    api: {},
    elements: {},
  };

  module.settings = $.extend({}, defaults, options);

  module.init = function () {
    setTimeout(function(){
      $('#flash').remove();
    }, 5000);
  };
}

$(document).ready(function () {
  var main = new AMain();
  main.init();
});
