import '../../../lib/notify';

function AUser(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_users',
      search: '/v1/admin/users/search',
    },
    data: {
      list_users: {},
    },
  };

  var elements = {
    container: $('#users_list'),
    list_users: $('#admin_user_template'),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadUsers = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_users = res.data.users;
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
        } else {
          $('.card-body').hide();
          $.notify(res.message);
        }
      },
    });
  };

  module.search = function (callback) {
    $('#form_search').on('keypress', function (e) {
      var keycode = e.keyCode ? e.keyCode : e.which;
      if (keycode == '13') {
        var name = $(this).val();
        return $.ajax({
          url: module.settings.api.search,
          type: 'POST',
          data: { name: name, per_page: module.settings.per_page },
          dataType: 'json',
          success: function (res) {
            if (res.code === 200) {
              module.settings.data.list_users = res.data.users;
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
      }
    })
  }

  module.renderUsers = function () {
    var users = module.settings.data.list_users;
    var template = _.template(elements.list_users.html());
    _.each(users, (user, idx) => {
      user.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: users }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $('.pagination span a').on('click', function () {
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadUsers(module.renderUsers);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_users.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_users.length;

    $('.totalpage_info').html(totalpage_info);
  };

  module.init = function () {
    module.loadUsers(module.renderUsers);
    module.search(module.renderUsers);
  };
}

$(document).ready(function () {
  var user = new AUser();
  user.init();
});
