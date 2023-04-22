import '../../lib/notify';

function ABrand(options) {
  var module = this;
  var defaults = {
    pagination_template: $('#pagination-template'),
    pagination_content: $('#paginate'),
    page: 1,
    per_page: 10,
    api: {
      get_all: '/v1/admin/load_brands',
      search: '/v1/admin/brands/search',
    },
    data: {
      list_brands: {},
    },
  };

  var elements = {
    container: $('#brands_list'),
    list_brands: $('#admin_brand_template'),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadBrands = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + '?page=' + module.settings.page,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_brands = res.data.brands;
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
        var brand_name = $(this).val();
        return $.ajax({
          url: module.settings.api.search,
          type: 'POST',
          data: { brand_name: brand_name, per_page: module.settings.per_page },
          dataType: 'json',
          success: function (res) {
            if (res.code === 200) {
              module.settings.data.list_brands = res.data.brands;
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

  module.renderBrands = function () {
    var brands = module.settings.data.list_brands;
    var template = _.template(elements.list_brands.html());
    _.each(brands, (brand, idx) => {
      brand.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: brands }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $('.pagination span a').on('click', function () {
      if ($(this).closest('.page').hasClass('current')) return;
      module.settings.page = $(this).data('page');
      module.loadBrands(module.renderBrands);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html('');
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += ' - ';
    if (module.settings.per_page == module.settings.data.list_brands.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_brands.length;

    $('.totalpage_info').html(totalpage_info);
  };

  module.init = function () {
    module.search(module.renderBrands);
    module.loadBrands(module.renderBrands);
  };
}

$(document).ready(function () {
  var brand = new ABrand();
  brand.init();
});
