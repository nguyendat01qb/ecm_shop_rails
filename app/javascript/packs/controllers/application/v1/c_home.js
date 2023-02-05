import '../../lib/notify';
import { loadPage } from '../../lib/application';

function CHome(options) {
  var module = this;
  var defaults = {
    page: 1,
    per_page: 6,
    api: {
      search: '/v1/customer/products/search',
      filter_products: '/v1/customer/home/filter_products',
      load_more: '/v1/customer/products/load_more'
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.handleSearch = function() {
    $("body").on("keypress", ".input_search", (e) => {
      if (e.keyCode == 13) {
        const keyword = $(e.target).val();
        var data = { keyword: keyword };
        $.ajax({
          url: module.settings.api.search,
          type: 'POST',
          data: data,
          dataType: 'json',
          success: function (res) {
            if (res.code === 200) {
              loadPage({ time: 200 });
              $(".features_items").replaceWith(res.html);
              $(".btn-load_more").remove();
              $("html, body").animate(
                {
                  scrollTop: $(".features_items").offset().top,
                },
                1000
              );
              // changeUrl(`/?search=${keyword}`);
            }
          },
        });
      }
    });
  };

  module.loadMoreProducts = function() {
    $('.btn-load_more').on('click', function(){
      const current_page = _.isEmpty(localStorage.getItem('current_page')) ? 1 : localStorage.getItem('current_page');
      var data = { page: current_page, per_page: module.settings.per_page };
      $.ajax({
        url: module.settings.api.load_more,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function (res) {
          if (res.status == 200) {
            if (res.page != 'error_page') {
              $('.features_items').append(res.html);
              const next_page = parseInt(current_page) + 1;
              localStorage.setItem('current_page', next_page);

              if (res.page == 'last_page') {
                $('.load_more').hide();
              } else {
                $('.load_more').show();
              }
            } else if (res.page == 'error_page') {
              $.notify('cc');
            }
            loadPage({ time: 200 });
          }
        },
      });
    });
  };

  module.loadProductsByCategory = function() {
    $('.category').on('click', ({ target }) => {
      const category_id = $(target).attr('id').split('_')[1];
      const data = { category_id: category_id };
      const category = $(target);
      $.ajax({
        url: module.settings.api.filter_products,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function (res) {
          if (res.status == 200) {
            $('.category').removeClass('active');
            category.addClass('active');

            $('.features_items').replaceWith(res.html);
            $('.btn-load_more').remove();
          } else {
            console.log(res);
          }
        },
      });
    });
  };

  module.handleCategory = () => {
    const panel = $('.panel.panel-default').find('.category.active');
    if (panel) {
      panel.closest('.panel-collapse').addClass('in');
    }
  };

  module.loadProductsByBrand = function() {
    $('.brand__item').on('click', ({ target }) => {
      const brand = $(target);
      const category_id = null;
      if(!$('.category.active').length === 0){
        category_id = $('.category.active')[0].id.split('_')[1]
      }
      const brand_id = $(target).attr('id').split('_')[1];
      const data = { category_id: category_id, brand_id: brand_id };
      $.ajax({
        url: module.settings.api.filter_products,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function (res) {
          if (res.status == 200) {
            $('.brand__item').removeClass('active');
            brand.addClass('active');

            $('.features_items').replaceWith(res.html);
            $('.btn-load_more').remove();
          }
        },
      });
    });
  };

  module.handleKeyPress = function() {
    $(window).on('load', function() {
      const itemsStorage = ['current_page']
      _.map(itemsStorage, function(el) {
        localStorage.removeItem(el);
      });
    });
  }

  module.init = function () {
    module.handleSearch();
    module.loadMoreProducts();
    module.loadProductsByCategory();
    module.loadProductsByBrand();

    module.handleCategory();
    module.handleCategory();
    module.handleKeyPress();
  };
}

$(document).ready(function () {
  var home = new CHome();
  home.init();
});
