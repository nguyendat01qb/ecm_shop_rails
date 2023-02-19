function ADashboard(options) {
  var module = this;
  var defaults = {
    api: {
      number: '/v1/admin/dashboards/numbers',
    },
    elements: {
      number: $('#list_numbers')
    },
    templates: {
      number: $('#list_numbers_template')
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.loadNumbers = function () {
    return $.ajax({
      url: module.settings.api.number,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.renderNumbers(res.data);
        }
      },
    });
  };

  module.renderNumbers = function (data) {
    var template = _.template(module.settings.templates.number.html());
    $(module.settings.elements.number).html(template({ options: data }));
  };

  module.init = function () {
    module.loadNumbers();
  };
}

$(document).ready(function () {
  var dashboard = new ADashboard();
  dashboard.init();
});
