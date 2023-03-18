import '../../lib/notify';

function AVoucher(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_vouchers',
    },
    data: {
      list_vouchers: {},
    },
  };

  var elements = {
    container: $('#vouchers_list'),
    list_vouchers: $('#admin_voucher_template'),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadVouchers = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_vouchers = res.data.vouchers;
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

  module.renderVouchers = function () {
    var vouchers = module.settings.data.list_vouchers;
    var template = _.template(elements.list_vouchers.html());
    _.each(vouchers, (voucher, idx) => {
      voucher.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: vouchers }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $('.pagination span a').on('click', function () {
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadVouchers(module.renderVouchers);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_vouchers.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_vouchers.length;

    $('.totalpage_info').html(totalpage_info);
  };

  module.init = function () {
    module.loadVouchers(module.renderVouchers);
  };
}

$(document).ready(function () {
  var voucher = new AVoucher();
  voucher.init();
});
