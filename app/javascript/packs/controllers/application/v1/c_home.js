import '../../lib/notify';
import { loadPage } from '../../lib/application';

function CHome(options) {
  var module = this;
  var defaults = {
    page: 1,
    per_page: 6,
    api: {
      category: '/v1/customer/home/categories',
      brand: '/v1/customer/home/brands',
      search: '/v1/customer/products/search',
      filter_products: '/v1/customer/home/filter_products',
      load_default_products: '/v1/customer/home/load_default_products',
      load_more: '/v1/customer/products/load_more',
    },
    templates: {
      category: $('#list_categories_template'),
      brand: $('#list_brands_template'),
      list_products: $('#list_products_template')
    },
    elements: {
      category: $('#list_categories'),
      brand: $('#list_brands'),
      product: $('#list_products')
    },
    data: {},
  };

  module.settings = $.extend({}, defaults, options);

  module.loadCategories = function () {
    return $.ajax({
      url: module.settings.api.category,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code == 200) {
          module.renderCategories(res.data);
        }
      },
    });
  };

  module.renderCategories = function (data) {
    var template = _.template(module.settings.templates.category.html());
    module.settings.elements.category.html(template({ options: data }));
    $(document).on('click', '.category-heading', function () {
      $('.category').removeClass('active');
      $('.badge').removeClass('active');
      $('.panel-collapse').removeClass('in');
      $(this).find('.category').toggleClass('active');
      $(this).find('.badge').toggleClass('active');
      $(this).siblings().toggleClass('in');
    });
    $(document).on('click', '.sub-category', function () {
      module.settings.data.category_id = parseInt($(this).attr('category_id'));
      $('.sub-category').removeClass('active');
      $(this).toggleClass('active');
      module.filterProducts();
    });
  };

  module.loadBrands = function () {
    return $.ajax({
      url: module.settings.api.brand,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code == 200) {
          module.renderBrand(res.data.brands);
        }
      },
    });
  };

  module.renderBrand = function (data) {
    var template = _.template(module.settings.templates.brand.html());
    module.settings.elements.brand.html(template({ options: data }));
    $(document).on('click', '.brand-heading', function () {
      module.settings.data.brand_id = parseInt($(this).attr('brand_id'));
      $('.brand__item').removeClass('active');
      $('.pull-right').removeClass('active');
      $(this).find('.brand__item').toggleClass('active');
      $(this).find('.pull-right').toggleClass('active');
      module.filterProducts();
    });
  };

  module.handleSearch = function () {
    $('body').on('keypress', '.input_search', (e) => {
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
              $('.features_items').replaceWith(res.html);
              $('.btn-load_more').remove();
              $('html, body').animate(
                {
                  scrollTop: $('.features_items').offset().top,
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

  module.loadMoreProducts = function () {
    $('.btn-load_more').on('click', function () {
      module.filterProducts(parseInt(localStorage.getItem('home-per-page')) + 6);
    });
  };

  module.loadDefaultProducts = function() {
    return $.ajax({
      url: module.settings.api.load_default_products,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code == 200) {
          localStorage.setItem('home-per-page', res.data.per_page)
          localStorage.removeItem('home-category-id');
          localStorage.removeItem('home-brand-id');
          module.renderProducts(res.data);
          module.handleLoadMore(res.data.is_load_more);
        }
      },
    });
  }

  module.filterProducts = function (per_page) {
    var category_id = module.settings.data.category_id || localStorage.getItem('home-category-id');
    var brand_id = module.settings.data.brand_id || localStorage.getItem('home-brand-id');
    const data = {
      category_id: category_id,
      brand_id: brand_id,
      per_page: per_page
    };
    localStorage.setItem('home-category-id', data.category_id);
    localStorage.setItem('home-brand-id', data.brand_id);
    return $.ajax({
      url: module.settings.api.filter_products,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code == 200) {
          localStorage.setItem('home-per-page', res.data.per_page)
          module.renderProducts(res.data);
          module.handleLoadMore(res.data.is_load_more);
        } else {
          module.settings.elements.product.html(`<h4 class='error_message'>${res.message}</h4>`);
          $('.load_more').hide();
        }
      },
    });
  };

  module.renderProducts = function (data) {
    var template = _.template(module.settings.templates.list_products.html());
    module.settings.elements.product.html(template({ option: data }));
  };

  module.handleLoadMore = function (is_load_more) {
    if(is_load_more){
      $('.load_more').show();
    }else{
      $('.load_more').hide();
    }
  }

  module.handleKeyPress = function () {
    $(window).on('load', function () {
      const itemsStorage = ['current_page'];
      _.map(itemsStorage, function (el) {
        localStorage.removeItem(el);
      });
    });
  };

  module.init = function () {
    module.loadCategories();
    module.loadBrands();
    module.loadDefaultProducts();
    module.handleSearch();
    module.loadMoreProducts();

    module.handleKeyPress();
  };
}

$(document).ready(function () {
  var home = new CHome();
  home.init();
});
