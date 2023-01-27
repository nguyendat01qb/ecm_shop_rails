import '../../lib/notify';

function AUser(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_admins',
    },
    data: {
      list_admins: {},
    },
  };

  var elements = {
    container: $('#admins_list'),
    list_admins: $('#admin_user_template')
  }

  module.settings = $.extend({}, defaults, options);

  module.loadAdmins = function(callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          debugger
          module.settings.data.list_admins = res.data.admins;
          module.settings.total_page = res.data.total_page;
          module.settings.total = res.data.total;
          module.settings.per_page = res.data.per_page;
          if (module.settings.total_page > 1) {
            $('#paginate').show();
            module.initPaginate();
          } else {
            $('#paginate').hide();
          }
          if (callback) {
            callback();
          }
        }
      },
    });
  };

  module.renderAdmins = function () {
    var admins = module.settings.data.list_admins;
    var template = _.template(elements.list_admins.html());
    _.each(admins, (user, idx) => {
      user.idx = (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: admins }));
    module.eventGoPage();
  };

  module.eventGoPage = function() {
    $('.pagination span a').on('click', function(){
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadAdmins(module.renderAdmins);
    });
  };

  module.initPaginate = function() {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info = 1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_admins.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info += (module.settings.per_page * (module.settings.page - 1) + module.settings.data.list_admins.length);

    $('.totalpage_info').html(totalpage_info);
  };

  module.init = function () {
    module.loadAdmins(module.renderAdmins);
  };
}

$(document).ready(function () {
  var user = new AUser();
  user.init();
});
