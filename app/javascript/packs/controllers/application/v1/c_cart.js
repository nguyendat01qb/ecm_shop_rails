import '../../lib/notify';
import '../../lib/jquery.cookie';
import { loadPage } from '../../lib/application';
import _ from 'underscore';

function CCart(options) {
  var module = this;
  var defaults = {
    headers: { 'Api-Token': $.cookie("api_token") },
    api: {
      default: '/v1/customer/carts/get_all',
    },
    templates: {
      cart: $('#template-cart')
    },
    elements: {
      cart: $('#a_list_cart_items'),
      decrease: $('cart_quantity_down'),
      increase: $('#cart_quantity_up'),
      quantityItem: $('#cart_quantity_input'),
      deleteBtn: $('#cart_quantity_delete'),
      totalAmount: $('#total_amount')
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.loadDefaultData = function() {
    const data = { cart: JSON.parse(localStorage.getItem('carts')) };
    return $.ajax({
      url: module.settings.api.default,
      type: 'POST',
      headers: module.settings.headers,
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.renderCart(res.data.products_cart);
        } else {
          $('.list-cart').hide();
          $('.sum_total').hide();
          $('.cart_menu').hide();
          $('.cart_info').append("<h2 class='cart_empty'>" + res.message + '</h2>');
        }
      },
    });
  };

  module.renderCart = function(cart_items) {
    var template = _.template(module.settings.templates.cart.html());
    $(module.settings.elements.cart).html(template({ options: cart_items }));
  }

  module.handleIncrement = function() {
    $(document).on('click', '#cart_quantity_up', function() {
      var stock = parseInt($(this).parent().attr('stock'));
      var input = $(this).siblings('#cart_quantity_input');
      var quantity = parseInt(input.attr('value'));
      if(quantity < stock) {
        input.attr('value', (quantity + 1));
      } else {
        $.notify('Out of stock quantity');
      }
    })
  }

  module.handleDecrement = function() {
    $(document).on('click', '#cart_quantity_down', function() {
      var input = $(this).siblings('#cart_quantity_input');
      var quantity = parseInt(input.attr('value'));
      if(quantity > 0) {
        input.attr('value', (quantity - 1));
      } else {
        $.notify('Quantity cannot be continue down');
      }
    })
  }

  module.handleDelete = function() {
    $(document).on('click', '#cart_quantity_delete', function() {
      var cart_id = $(this).attr('cart_id');
      var product_id = parseInt($(this).attr('product_id'));
      var attr_id = parseInt($(this).attr('attr_id'));
      if(_.isEmpty(cart_id)) {
        var results = [];
        var cart_items = JSON.parse(localStorage.getItem('carts'));
        $.map(cart_items, function(cart_item) {
          if (parseInt(cart_item.product_id) !== product_id || cart_item.attr_val_id !== attr_id){
            results.push(cart_item)
          }
        })
        localStorage.setItem('carts' ,JSON.stringify(results));
        module.loadDefaultData();
        $.notify('Cart item deleted successfully', 'success')
      }
    })
  }

  module.init = function () {
    module.loadDefaultData();
    module.handleIncrement();
    module.handleDecrement();
    module.handleDelete();
  };
}

$(document).ready(function () {
  var cart = new CCart();
  cart.init();
});
