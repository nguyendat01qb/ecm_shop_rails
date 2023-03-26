import '../../lib/notify';

function CCart(options) {
  var module = this;
  var defaults = {
    api: {
      default: '/v1/customer/carts/get_all',
      update: '/v1/customer/carts',
      delete: '/v1/customer/carts/delete',
    },
    templates: {
      cart: $('#template-cart'),
    },
    elements: {
      cart: $('#a_list_cart_items'),
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.loadDefaultData = function () {
    const data = { cart: JSON.parse(localStorage.getItem('carts')) };
    return $.ajax({
      url: module.settings.api.default,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.renderCart(res.data);
          if (res.data.is_current === true) {
            localStorage.removeItem('carts');
          }
        } else {
          $('.list-cart').hide();
          $('.sum_total').hide();
          $('.cart_menu').hide();
          $('.cart_info').append(
            `<h2 class='cart_empty'>${res.message}</h2>`
          );
        }
      },
    });
  };

  module.renderCart = function (res) {
    var template = _.template(module.settings.templates.cart.html());
    $(module.settings.elements.cart).html(
      template({ options: res.products_cart })
    );
    $('#total_amount').replaceWith(
      `<div id='total_amount'><sup>$</sup>${res.total_amount}</div>`
    );
  };

  module.handleIncrement = function () {
    $(document).on('click', '#cart_quantity_up', function () {
      var input = $(this).siblings('#cart_quantity_input');
      var stock = parseInt(input.attr('max'));
      var quantity = parseInt(input.attr('value'));
      var cart_item_id = parseInt(input.attr('cart_id'));
      var product_id = parseInt(input.attr('product_id'));
      var attr_id = parseInt(input.attr('attr_id'));
      var price = parseFloat($('.cart_price').attr('price'));
      var discount = parseInt($('.cart_discount').attr('discount'));
      if (quantity < stock) {
        quantity = quantity + 1;
        input.attr('value', quantity);
        if (cart_item_id >= 0) {
          module.handleUpdate(cart_item_id, quantity);
        } else {
          let carts = JSON.parse(localStorage.getItem('carts'));
          var cart_present = false;
          if (_.isEmpty(carts)) {
            carts = [
              {
                product_id: product_id,
                amount: quantity,
                attr_val_id: attr_id,
              },
            ];
          } else {
            _.map(carts, function (cart) {
              if (
                parseInt(cart.product_id) === product_id &&
                cart.attr_val_id === attr_id
              ) {
                cart_present = true;
                cart.amount += 1;
                return cart;
              }
            });
            if (cart_present === false) {
              carts.push({
                product_id: product_id,
                amount: quantity,
                attr_val_id: attr_id,
              });
            }
          }
          localStorage.setItem('carts', JSON.stringify(carts));
        }
        var totalAmount = parseFloat((price * discount * quantity) / 100).toFixed(2);
        $('.cart_total_price_' + attr_id).replaceWith(
          `<p class='cart_total_price cart_total_price_${attr_id}' id='${totalAmount}'><sup>$</sup>${totalAmount}</p>`
        );
        module.updateTotalAmount();
      } else {
        $.notify('Out of stock quantity');
      }
    });
  };

  module.handleDecrement = function () {
    $(document).on('click', '#cart_quantity_down', function () {
      var input = $(this).siblings('#cart_quantity_input');
      var quantity = parseInt(input.attr('value'));
      var cart_item_id = parseInt(input.attr('cart_id'));
      var product_id = parseInt(input.attr('product_id'));
      var attr_id = parseInt(input.attr('attr_id'));
      var price = parseFloat($('.cart_price').attr('price'));
      var discount = parseInt($('.cart_discount').attr('discount'));
      if (quantity > 1) {
        quantity = quantity - 1;
        input.attr('value', quantity);
        if (cart_item_id >= 0) {
          module.handleUpdate(cart_item_id, quantity);
        } else {
          let carts = JSON.parse(localStorage.getItem('carts'));
          var cart_present = false;
          if (_.isEmpty(carts)) {
            carts = [
              {
                product_id: product_id,
                amount: quantity,
                attr_val_id: attr_id,
              },
            ];
          } else {
            _.map(carts, function (cart) {
              if (
                parseInt(cart.product_id) === product_id &&
                cart.attr_val_id === attr_id
              ) {
                cart_present = true;
                cart.amount -= 1;
                return cart;
              }
            });
            if (cart_present === false) {
              carts.push({
                product_id: product_id,
                amount: quantity,
                attr_val_id: attr_id,
              });
            }
          }
          localStorage.setItem('carts', JSON.stringify(carts));
        }
        var totalAmount = parseFloat((price * discount * quantity) / 100).toFixed(2);
        $('.cart_total_price_' + attr_id).replaceWith(
          `<p class='cart_total_price cart_total_price_${attr_id}' id='${totalAmount}'><sup>$</sup>${totalAmount}</p>`
        );
        return module.updateTotalAmount();
      } else {
        $.notify('Quantity cannot be continue down');
      }
    });
  };

  module.updateTotalAmount = function () {
    if ($('.cart_total_price').length === 0) return;
    var totalAmount = 0;
    _.each($('.cart_total_price'), function (e) {
      totalAmount = totalAmount + parseFloat(e.id);
    });
    $('#total_amount').replaceWith(
      `<div id='total_amount'><sup>$</sup>${totalAmount.toFixed(2)}</div>`
    );
  }

  module.handleUpdate = function (cart_item_id, quantity) {
    var data = { cart_item_id: cart_item_id, quantity: quantity };
    return $.ajax({
      url: module.settings.api.update,
      type: 'PUT',
      data: data,
      dataType: 'json',
      success: function (res) { },
    });
  };

  module.handleDelete = function () {
    $(document).on('click', '#cart_quantity_delete', function () {
      var cart_item_id = $(this).attr('cart_id');
      var product_id = parseInt($(this).attr('product_id'));
      var attr_id = parseInt($(this).attr('attr_id'));
      if (_.isEmpty(cart_item_id)) {
        var results = [];
        var cart_items = JSON.parse(localStorage.getItem('carts'));
        $.map(cart_items, function (cart_item) {
          if (
            parseInt(cart_item.product_id) !== product_id ||
            cart_item.attr_val_id !== attr_id
          ) {
            results.push(cart_item);
          }
        });
        localStorage.setItem('carts', JSON.stringify(results));
        module.loadDefaultData();
        $.notify('Cart item deleted successfully', 'success');
      } else {
        module.deleteCartItem(cart_item_id);
      }
    });
  };

  module.deleteCartItem = function (cart_item_id) {
    var data = { cart_item_id: cart_item_id };
    return $.ajax({
      url: module.settings.api.delete,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          module.loadDefaultData();
          $.notify(res.message, 'success');
        } else {
          $.notify(res.message);
        }
      },
    });
  };

  module.init = function () {
    module.loadDefaultData();
    module.handleIncrement();
    module.handleDecrement();
    module.handleDelete();
    module.updateTotalAmount();
  };
}

$(document).ready(function () {
  var cart = new CCart();
  cart.init();
});
