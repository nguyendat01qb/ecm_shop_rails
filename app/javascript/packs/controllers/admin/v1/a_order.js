import '../../lib/notify';

function AOrder(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_orders',
      submit: '/v1/admin/orders/submit',
      cancel: '/v1/admin/orders/cancel',
      approve: '/v1/admin/orders/approve'
    },
    data: {
      list_orders: {},
    },
  };

  var elements = {
    container: $('#orders_list'),
    list_orders: $('#admin_order_template'),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadOrders = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_orders = res.data.orders;
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

  module.renderOrders = function () {
    var orders = module.settings.data.list_orders;
    var template = _.template(elements.list_orders.html());
    _.each(orders, (order, idx) => {
      order.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: orders }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $('.pagination span a').on('click', function () {
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadOrders(module.renderOrders);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_orders.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_orders.length;

    $('.totalpage_info').html(totalpage_info);
  };

  module.submitOrder = function (callback) {
    $(document).on('click', '#submitOrder', function () {
      var order_id = $(this).data('order-id');
      return $.ajax({
        url: module.settings.api.submit,
        type: 'POST',
        data: { order_id: order_id },
        dataType: 'json',
        success: function (res) {
          if (res.code === 200) {
            module.loadOrders(module.renderOrders);
          }
        },
      });
    })
  }

  module.cancelOrder = function (callback) {
    $(document).on('click', '#cancelOrder', function () {
      var order_id = $(this).data('order-id');
      return $.ajax({
        url: module.settings.api.cancel,
        type: 'POST',
        data: { order_id: order_id },
        dataType: 'json',
        success: function (res) {
          if (res.code === 200) {
            module.loadOrders(module.renderOrders);
          }
        },
      });
    })
  }

  module.approveOrder = function (callback) {
    $(document).on('click', '#orderSuccess', function () {
      var order_id = $(this).data('order-id');
      return $.ajax({
        url: module.settings.api.approve,
        type: 'POST',
        data: { order_id: order_id },
        dataType: 'json',
        success: function (res) {
          module.loadOrders(module.renderOrders);
        },
      });
    })
  }

  module.init = function () {
    module.loadOrders(module.renderOrders);
    module.submitOrder();
    module.cancelOrder();
    module.approveOrder();
  };
}

$(document).ready(function () {
  var order = new AOrder();
  order.init();
});
