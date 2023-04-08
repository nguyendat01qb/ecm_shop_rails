import { redirect } from '../../lib/application';
import '../../lib/notify';

function CCheckout(options) {
  var module = this;
  var defaults = {
    api: {
      getOrder: '/v1/customer/checkouts/get_order',
      voucher: '/v1/customer/checkouts/voucher',
      address: '/v1/customer/checkouts/address',
      checkout: 'v1/customer/checkouts'
    },
    templates: {
      address_default: $('#address_default_template'),
      list_addresses: $('#addresses_template'),
      list_order: $('#list_order_template'),
      list_order_checkout: $('#list_order_checkout_template'),
    },
    elements: {
      address_default: $('.address_content'),
      list_addresses: $('.list-address_content'),
      list_order: $('.list_order'),
      list_order_checkout: $('.list_order_checkout'),
    },
    data: {
      public_key: 'pk_test_51MQQDqAfM8SM9VlxjUWgvgCSUpGM0IGWbzdDQcj3cPae4OdH2WyK8jG3OXAqRGBs6TYAynE44wE8RMeQvvnk09RW00eayTBSlh'
    }
  };

  module.settings = $.extend({}, defaults, options);

  module.getOrder = function () {
    return $.ajax({
      url: module.settings.api.getOrder,
      type: 'GET',
      dataType: 'json',
      success: function (res) {
        if (res.code === 200) {
          var data = res.data;
          var addressDefault = data.address_default;
          var addresses = data.addresses;
          var orderItems = data.order_item;
          module.renderAddressDefault(addressDefault);
          module.renderAddresses(addresses);
          module.renderOrderItems(orderItems);
          module.renderOrderCheckout(data);
        }
      },
    });
  };

  module.renderAddressDefault = function (addressDefault) {
    if (_.isEmpty(addressDefault)) {
      $('.address_content-name').replaceWith(
        "<div class='address_content-name' style='display:block;'><p>Please choose an address</p></div>"
      );
    } else {
      var template = _.template(
        module.settings.templates.address_default.html()
      );
      $(module.settings.elements.address_default).html(
        template({ option: addressDefault })
      );
    }
  };

  module.renderAddresses = function (addresses) {
    var template = _.template(module.settings.templates.list_addresses.html());
    $(module.settings.elements.list_addresses).html(
      template({ options: addresses })
    );
  };

  module.renderOrderItems = function (orderItems) {
    var template = _.template(module.settings.templates.list_order.html());
    $(module.settings.elements.list_order).html(
      template({ options: orderItems })
    );
  };

  module.renderOrderCheckout = function (data) {
    var template = _.template(
      module.settings.templates.list_order_checkout.html()
    );
    data.total = (
      data.total_amount +
      data.transport_fee
    ).toFixed(2);
    $(module.settings.elements.list_order_checkout).html(
      template({ option: data })
    );
  };

  module.checkVoucherCode = function () {
    $(document).on('input', '.apply_voucher', function () {
      if ($(this).val() != '') {
        $('.btn-apply_voucher').addClass('btn-apply');
      } else {
        $('.btn-apply_voucher').removeClass('btn-apply');
      }
    });
  };

  module.handleApplyVoucher = function () {
    $(document).on('click', '.btn-apply', function () {
      var voucher_code = $('input[name=apply_voucher]').val();
      if (voucher_code.length > 0) {
        module.loadVoucherByAjax({ voucher_code: voucher_code });
      }
    });
  };

  module.handleSubmitVoucher = function () {
    $(document).on('keypress', '.apply_voucher', function (e) {
      var keycode = e.keyCode ? e.keyCode : e.which;
      if (keycode == '13') {
        var voucher_code = $(this).val();
        if (voucher_code.length > 0) {
          module.loadVoucherByAjax({ voucher_code: voucher_code });
        }
      }
    });
  };

  module.loadVoucherByAjax = function (data) {
    return $.ajax({
      url: module.settings.api.voucher,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        $('input[name=apply_voucher]').val('');
        if (res.code === 200) {
          var data = res.data;
          module.renderOrderCheckout(data);
        } else {
          $.notify(res.message);
        }
      },
    });
  };

  module.changeAddress = function () {
    $(document).on('click', '#btn-confirm_address', function () {
      var address_id = $('input[name=address]').filter(':checked').val();
      var data = { id: address_id };
      return $.ajax({
        url: module.settings.api.address,
        type: 'POST',
        data: data,
        dataType: 'json',
        success: function (res) {
          if (res.code === 200) {
            var data = res.data;
            var addressDefault = data.address_default;
            var addresses = data.addresses;
            $('.address_content').toggle();
            $('.list-address_content').toggle();
            module.renderAddressDefault(addressDefault);
            module.renderAddresses(addresses);
            Swal.fire({
              position: 'center',
              icon: 'success',
              title: res.message,
              showConfirmButton: false,
              timer: 1000,
            });
          } else {
            $.notify(res.message);
          }
        },
      });
    });
  };

  module.handleInputAddress = function () {
    $(document).on('click', '#back_address, #change_address', function () {
      $('.address_content').toggle();
      $('.list-address_content').toggle();
    });
  };

  module.handlePaymentMethod = function () {
    $('input[type=radio][name="payment-selection"]').on('change', function () {
      var newActiveTabID = $('input[name="payment-selection"]:checked').val();
      $('.paymentSelectionTab').removeClass('active');
      $('#tab-' + newActiveTabID).addClass('active');
    })
  }

  module.setupStripe = function () {
    //Initialize stripe with publishable key
    module.settings.data.stripe = Stripe(module.settings.data.public_key);

    //Create Stripe credit card elements.
    var elements = module.settings.data.stripe.elements();
    module.settings.data.card = elements.create('card');

    // Mount Stripe card element in the #card-element div.
    module.settings.data.card.mount('#card-element');
  }

  module.handleSubmit = function () {
    $(document).on('click', '.into_money-btn', () => {
      module.settings.data.paymentGateway = $('input[name="payment-selection"]:checked').val();
      switch (module.settings.data.paymentGateway) {
        case 'stripe':
          module.settings.data.stripe.createToken(module.settings.data.card).then(function(res) {
            if (res.error) {
              // Inform that there was an error.
              var errorElement = document.getElementById('card-errors');
              errorElement.textContent = res.error.message;
              return
            } else {
              // Submits the order
              module.settings.data.orderToken = res.token.id
              module.handleStripeCheckout();
            }
          });
          break;
        default:
          break;
      }
    })
  }

  module.handleStripeCheckout = function () {
    var data = {
      payment_gateway: module.settings.data.paymentGateway,
      token: module.settings.data.orderToken,
      total_amount: $('#total_amount').data('total-amount'),
      transport_fee: $('#transport_fee').data('fee'),
      voucher_id: $('#voucher_code').data('voucher-id'),
      total_bill: $('#total_bill').data('total-bill')
    }
    return $.ajax({
      url: module.settings.api.checkout,
      type: 'POST',
      data: data,
      dataType: 'json',
      success: function (res) {
        if (res.code == 200) {
          $.notify('Your order created successfully', 'success');
          setTimeout(() => {
            document.location.href = '/'
          }, 2000);
        } else {
          $.notify('Your order create fail');
          setTimeout(() => {
            document.location.href = '/'
          }, 2000);
        }
      },
    });
  }

  module.init = function () {
    module.getOrder();
    module.checkVoucherCode();
    module.handleSubmitVoucher();
    module.handleApplyVoucher();
    module.changeAddress();
    module.handleInputAddress();
    module.handlePaymentMethod();
    module.setupStripe();
    module.handleSubmit();
    // module.setupPaypal();
  };
}

$(document).ready(function () {
  var checkout = new CCheckout();
  checkout.init();
});
