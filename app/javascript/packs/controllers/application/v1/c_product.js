import '../../lib/notify';
import '../../lib/slick';
// import '../../lib/jquery.cookie';
import { popupFire } from '../../lib/application';

function CProduct(options) {
  var module = this;
  var defaults = {
    page: 1,
    per_page: 6,
    // headers: { 'Api-Token': $.cookie("api_token") },
    api: {
      get_attributes: '/v1/customer/products/select_attribute'
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.handleAttribute = function() {
    $('body').on('click', '.attribute_item', ({ target }) => {
      const attribute = $(target);
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
            id_attr1: $('.item1.active').data('attribute'),
            value_attr1: $('.item1.active').html(),
            id_attr2: $('.item2.active').data('attribute'),
            value_attr2: $('.item2.active').html(),
          };

          $.ajax({
            url: module.settings.api.get_attributes,
            type: 'POST',
            // headers: module.settings.headers,
            data: data,
            dataType: 'json',
            success: function (res) {
              if (res.code == 200) {
                $('.price_new').replaceWith(
                  `<span class='price_new'><sup>$</sup>${res.data.attribute_value.discount}</span>`
                );
                if (parseInt(res.data.attribute_value.quantity) > 0) {
                  $('.out-of-stock').replaceWith(`
                    <a class='btn btn-fefault cart add-to-cart' name='add-to-cart-detail'>
                      <i class='fa fa-shopping-cart'></i>
                      Add to cart
                    </a>
                  `);
                  $('.product__stock').replaceWith(`
                    <div class='product__stock'><b>Quantity in stock: </b><span id='stock' value='${res.data.attribute_value.quantity}'>${res.data.attribute_value.quantity}</span></div>
                  `);
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
      } else if ($('.select__items').length == 1) {
        const data = {
          id_attr1: $('.item1.active').data('attribute'),
          value_attr1: $('.item1.active').html(),
        };

        $.ajax({
          url: module.settings.api.get_attributes,
          type: 'POST',
          data: data,
          dataType: 'json',
          success: function (res) {
            if (res.status == 200) {
              $('.product__stock').replaceWith(`
                <p class='product__stock'><b>Quantity in stock: </b>${res.value.stock}</p>
              `);

              $('.price_new').replaceWith(
                `<span class='price_new'>${res.value.price_attribute_product}</span>`
              );
            }
          },
        });
      }
    });
  };

  module.handleAddCart = function() {
    $('.add-to-cart').on('click', ({ target }) => {
      const product_id = $(target).closest('.add_product').attr('id').split(' ')[0];
      const amount = parseInt($('.numberInput').val());
      const id_attr1 = $('.item1.active').data('attribute');
      const value_attr1 = $('.item1.active').html();
      const id_attr2 =  $('.item2.active').data('attribute');
      const value_attr2 =  $('.item2.active').html();
      var item_1_name = $('#item_1').children().attr('name');
      var item_2_name = $('#item_2').children().attr('name');
      if(!_.isEmpty(item_1_name) && _.isEmpty(value_attr1)) { return $.notify(item_1_name + " is empty") }
      if(!_.isEmpty(item_2_name) && _.isEmpty(value_attr2)) { return $.notify(item_2_name + " is empty") }
      const data = {
        id_attr1: id_attr1,
        value_attr1: value_attr1,
        id_attr2: id_attr2,
        value_attr2: value_attr2
      };
      $.ajax({
        url: module.settings.api.get_attributes,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function (res) {
          if (res.code === 200) {
            const attr_val_id = res.data.attribute_value.id;
            let carts = JSON.parse(localStorage.getItem('carts'));
            const cart_params = { product_id: product_id, amount: amount, attr_val_id: attr_val_id }
            const cart_present = false;
            if(_.isEmpty(carts)){
              carts = [cart_params];
            } else {
              _.map(carts, function(cart) {
                if (cart.product_id === cart_params.product_id && cart.attr_val_id === cart_params.attr_val_id) {
                  cart_present = true;
                  cart.amount += cart_params.amount;
                  return cart;
                }
              })
              if(cart_present === false){
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
        },
      });
    });
  }

  module.handleSliderSlick = function() {
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
  }

  module.init = function () {
    module.handleAttribute();
    module.handleAddCart();
    module.handleSliderSlick();
  };
}

$(document).ready(function () {
  var product = new CProduct();
  product.init();
});
