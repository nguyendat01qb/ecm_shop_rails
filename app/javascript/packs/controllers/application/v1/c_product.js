import '../../lib/notify';
import '../../lib/slick';
import '../../lib/jquery.cookie';
import { popupFire } from '../../lib/application';
import { flatten } from 'underscore';

function CProduct(options) {
  var module = this;
  var url = window.location.href.split('/');
  var product_id = url[url.length - 1];
  var defaults = {
    page: 1,
    per_page: 6,
    headers: { 'Api-Token': $.cookie('api_token') },
    api: {
      get_attributes: '/v1/customer/products/select_attribute',
      add_to_cart: '/v1/customer/products/add_to_cart',
      images: `/v1/customer/products/${product_id}/images`,
      detail: `/v1/customer/products/${product_id}`,
    },
    templates: {
      images: $('#product_images_template'),
      detail: $('#product_detail_template')
    },
    elements: {
      images: $('#product_images'),
      detail: $('#product_detail')
    },
    data: {
      starClicked: false
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.getImages = function () {
    return $.ajax({
      url: module.settings.api.images,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        module.renderImage(res.data.image_urls);
      }
    })
  };

  module.renderImage = function (image_urls) {
    var template = _.template(module.settings.templates.images.html());
    module.settings.elements.images.html(template({ image_urls: image_urls }));
  };

  module.getProductDetail = function () {
    return $.ajax({
      url: module.settings.api.detail,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        var data = res.data;
        var results = []
        _.each(data.attr_values, function (attr_value, key) {
          var key = JSON.parse(key);
          var obj = {};
          obj.id = key[0];
          obj.name = key[1];
          obj.values = flatten(attr_value);
          results.push(obj);
        })
        data.attr_values = results
        module.renderProductDetail(data);
      }
    })
  };

  module.renderProductDetail = function (data) {
    var template = _.template(module.settings.templates.detail.html());
    module.settings.elements.detail.html(template({ option: data }));
  };

  module.handleAttribute = function () {
    $(document).on('click', '.attribute_item', ({ target }) => {
      const attribute = $(target);
      const product_id = attribute.attr('product_id');
      const attributeOld = $(target).closest('.select__items').find('.active');
      const attributeDanger = $('.attribute_error');

      if (attribute.hasClass('active') == false) attribute.addClass('active');
      else attribute.removeClass('active');

      if (attributeOld.length != 0) attributeOld.removeClass('active');

      if (attributeDanger.length != 0) {
        attributeDanger.remove();
        $('.attribute_product').css('background-color', '#fff');
      }

      if ($('.select__items').length == 2) {
        if ($('.select__items').find('.active').length == 2) {
          const data = {
            id_attr1: $('.item_1.active').data('attribute'),
            value_attr1: $('.item_1.active').html().trim(),
            id_attr2: $('.item_2.active').data('attribute'),
            value_attr2: $('.item_2.active').html().trim(),
          };

          $.ajax({
            url: module.settings.api.get_attributes,
            type: 'POST',
            data: data,
            dataType: 'json',
            success: function (res) {
              if (res.code == 200) {
                $('.price_new').replaceWith(
                  `<span class='price_new'><sup>$</sup>${res.data.attribute_value.discount}</span>`
                );
                if (parseInt(res.data.attribute_value.quantity) > 0) {
                  $('.out-of-stock').replaceWith(`
                    <a class='btn btn-fefault cart' id='add-to-cart' product_id=${product_id} name='add-to-cart-detail'>
                      <i class='fa fa-shopping-cart'></i>
                      Add to cart
                    </a>
                  `);
                  $('.product__stock').replaceWith(`
                    <div class='product__stock'><b>Quantity in stock: </b><span id='stock' value='${res.data.attribute_value.quantity}'>${res.data.attribute_value.quantity}</span></div>
                  `);
                  $('#pd_quantity_input').attr(
                    'max',
                    res.data.attribute_value.quantity
                  );
                  if (
                    parseInt($('#pd_quantity_input').val()) >
                    res.data.attribute_value.quantity
                  ) {
                    $('#pd_quantity_input').attr(
                      'value',
                      res.data.attribute_value.quantity
                    );
                  }
                  $('.quantity').attr(
                    'stock',
                    res.data.attribute_value.quantity
                  );
                } else {
                  $('.product__stock').replaceWith(`
                    <div class='product__stock'><b>Quantity in stock: </b><span id='stock' value='0'>0</span></div>
                  `);
                  $('.add-to-cart').replaceWith(`
                    <a class='btn btn-danger out-of-stock' href='javascript:void(0)'>Out of stock</a>
                  `);
                }
              }
            },
          });
        }
      }
    });
  };

  module.handleAddCart = function () {
    $(document).on('click', '#add-to-cart', () => {
      const p_id = $(this).data('product_id') || product_id;
      const quantity = parseInt($('#pd_quantity_input').val());
      const id_attr1 = $('.item_1.active').data('attribute');
      const value_attr1 = $('.item_1.active').html() ? $('.item_1.active').html().trim() : '';
      const id_attr2 = $('.item_2.active').data('attribute');
      const value_attr2 = $('.item_2.active').html() ? $('.item_2.active').html().trim() : '';
      var item_1_name = $('#item_1').children().attr('name');
      var item_2_name = $('#item_2').children().attr('name');
      if (!_.isEmpty(item_1_name) && _.isEmpty(value_attr1) && !_.isEmpty(item_2_name) && _.isEmpty(value_attr2)) {
        $.notify(item_1_name + ' is empty');
        $.notify(item_2_name + ' is empty');
        return
      } else if (!_.isEmpty(item_1_name) && _.isEmpty(value_attr1)) {
        return $.notify(item_1_name + ' is empty');
      } else if (!_.isEmpty(item_2_name) && _.isEmpty(value_attr2)) {
        return $.notify(item_2_name + ' is empty');
      }
      const data = {
        id_attr1: id_attr1,
        value_attr1: value_attr1,
        id_attr2: id_attr2,
        value_attr2: value_attr2,
      };
      module.getAttributes(data, p_id, quantity);
      if (!_.isEmpty(module.settings.headers['Api-Token'])) {
        data.product_id = p_id;
        data.quantity = quantity;
        module.handleUpdateCart(data);
      }
    });
  };

  module.getAttributes = function (data, product_id, amount) {
    return $.ajax({
      url: module.settings.api.get_attributes,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          const attr_val_id = res.data.attribute_value.id;
          let carts = JSON.parse(localStorage.getItem('carts'));
          const cart_params = {
            product_id: product_id,
            amount: amount,
            attr_val_id: attr_val_id,
          };
          if (_.isEmpty(module.settings.headers['Api-Token'])) {
            let cart_present = false;
            if (_.isEmpty(carts)) {
              carts = [cart_params];
            } else {
              _.map(carts, function (cart) {
                if (
                  cart.product_id === cart_params.product_id &&
                  cart.attr_val_id === cart_params.attr_val_id
                ) {
                  cart_present = true;
                  cart.amount += cart_params.amount;
                  return cart;
                }
              });
              if (cart_present === false) {
                carts.push(cart_params);
              }
            }
            localStorage.setItem('carts', JSON.stringify(carts));
            popupFire(
              'top-right',
              'success',
              'The product has been added successfully',
              2000
            );
          }
        }
      },
    });
  };

  module.handleUpdateCart = function (data) {
    return $.ajax({
      url: module.settings.api.add_to_cart,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          $('#pd_quantity_input').attr('value', res.data.cart_item.quantity);
          popupFire(
            'top-right',
            'success',
            res.message,
            2000
          );
        } else if (res.code === 500) {
          popupFire(
            'top-right',
            'error',
            res.message,
            2000
          );
        }
      },
      error: function (e) {
        $.notify(e.message);
      }
    });
  };

  module.handleSliderSlick = function () {
    $('.pro-dec-big-img-slider').slick({
      slidesToShow: 1,
      slidesToScroll: 1,
      arrows: false,
      draggable: false,
      fade: false,
      asNavFor: '.product-dec-slider-small',
    });

    $('.product-dec-slider-small').slick({
      slidesToShow: 3,
      slidesToScroll: 1,
      asNavFor: '.pro-dec-big-img-slider',
      dots: false,
      focusOnSelect: true,
      fade: false,
      prevArrow:
        "<a class='left item-control'><i class='fa fa-angle-left'></i></a>",
      nextArrow:
        "<a class='right item-control'><i class='fa fa-angle-right'></i></a>",
    });

    $('.item-control:not(.slick-arrow)')
      .closest('.slick-slide:not(.slick-cloned)')
      .remove();
  };

  module.handleIncrement = function () {
    $(document).on('click', '#pd_quantity_up', function () {
      var input = $(this).siblings('#pd_quantity_input');
      var stock = input.attr('max');
      var quantity = parseInt(input.attr('value'));
      if (quantity < stock) {
        input.attr('value', quantity + 1);
      } else {
        input.attr('value', stock);
        $.notify('Out of stock quantity');
      }
    });
  };

  module.handleDecrement = function () {
    $(document).on('click', '#pd_quantity_down', function () {
      var input = $(this).siblings('#pd_quantity_input');
      var quantity = parseInt(input.attr('value'));
      if (quantity > 0) {
        input.attr('value', quantity - 1);
      } else {
        $.notify('Quantity cannot be continue down');
      }
    });
  };

  module.handleStar = function () {
    $('.star').on('click', function () {
      $(this).children('.selected').addClass('is-animated');
      $(this).children('.selected').addClass('pulse');
      var target = this;
      setTimeout(function() {
        $(target).children('.selected').removeClass('is-animated');
        $(target).children('.selected').removeClass('pulse');
      }, 1000);
      module.settings.data.starClicked = true;
    });

    $('.half').on('click', function () {
      debugger
      if (module.settings.data.starClicked) {
        module.setHalfStarState(this);
      }
      $(this).closest('#rating').find('.js-score').text($(this).data('value'));
      $(this).closest('#rating').data('vote', $(this).data('value'));
      module.calculateAverage();
      console.log(parseInt($(this).data('value')));
    })

    $('.full').on('click', function() {
      debugger
      if (module.settings.data.starClicked) {
        module.setFullStarState(this);
      }
      $(this).closest('#rating').find('.js-score').text($(this).data('value'));
      $(this).find('js-average').text(parseInt($(this).data('value')));
      $(this).closest('#rating').data('vote', $(this).data('value'));
      module.calculateAverage();
      console.log(parseInt($(this).data('value')));
    })
  }

  module.updateStarState = function (target) {
    $(target).parent().prevAll().addClass('animate');
    $(target).parent().prevAll().children().addClass('star-colour');

    $(target).parent().nextAll().removeClass('animate');
    $(target).parent().nextAll().children().removeClass('star-colour');
  }

  module.setHalfStarState = function (target) {
    $(target).addClass('star-colour');
    $(target).siblings('.full').removeClass('star-colour');
    module.updateStarState(target)
  }

  module.setFullStarState = function (target) {
    $(target).addClass('star-colour');
    $(target).parent().addClass('animate');
    debugger
    $(target).siblings('.half').addClass('star-colour');
    module.updateStarState(target)
  }

  module.calculateAverage = function () {
    var average = 0
    $('#rating').each(function() {
      average += $(this).data('vote')
    })
    $('.js-average').text((average/ $('#rating').length).toFixed(1))
  }

  module.init = function () {
    $.when(module.getImages()).done(function () {
      module.handleSliderSlick();
    })
    module.getProductDetail();
    module.handleAttribute();
    module.handleAddCart();

    // module.handleIncrement();
    // module.handleDecrement();
    module.handleStar();
  };
}

$(document).ready(function () {
  var product = new CProduct();
  product.init();
});
