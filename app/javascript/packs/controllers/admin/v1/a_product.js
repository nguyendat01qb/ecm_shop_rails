import '../../lib/notify';

function AProduct(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_products',
      search: '/v1/admin/products/search',
    },
    data: {
      list_products: {},
    },
  };

  var elements = {
    container: $('#products_list'),
    list_products: $('#admin_product_template'),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadProducts = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_products = res.data.products;
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

  module.search = function (callback) {
    $('#form_search').on('keypress', function (e) {
      var keycode = e.keyCode ? e.keyCode : e.which;
      if (keycode == '13') {
        var product_title = $(this).val();
        return $.ajax({
          url: module.settings.api.search,
          type: 'POST',
          data: { product_title: product_title, per_page: module.settings.per_page },
          dataType: 'json',
          success: function (res) {
            if (res.code === 200) {
              module.settings.data.list_products = res.data.products;
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

  module.renderProducts = function () {
    var products = module.settings.data.list_products;
    var template = _.template(elements.list_products.html());
    _.each(products, (product, idx) => {
      product.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: products }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $('.pagination span a').on('click', function () {
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadProducts(module.renderProducts);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_products.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_products.length;

    $('.totalpage_info').html(totalpage_info);
  };

  module.init = function () {
    module.loadProducts(module.renderProducts);
    module.search(module.renderProducts);
  };
}

$(document).ready(function () {
  var product = new AProduct();
  product.init();
});
