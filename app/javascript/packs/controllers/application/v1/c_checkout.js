import "../../lib/notify";

function CCheckout(options) {
  var module = this;
  var defaults = {
    api: {
      getOrder: "/v1/customer/checkouts/get_order",
      voucher: "/v1/customer/checkouts/voucher",
      address: '/v1/customer/checkouts/address'
    },
    templates: {
      address_default: $("#address_default_template"),
      list_addresses: $("#addresses_template"),
      list_order: $("#list_order_template"),
      list_order_checkout: $("#list_order_checkout_template"),
    },
    elements: {
      address_default: $(".address_content"),
      list_addresses: $(".list-address_content"),
      list_order: $(".list_order"),
      list_order_checkout: $(".list_order_checkout"),
    },
  };

  module.settings = $.extend({}, defaults, options);

  module.getOrder = function () {
    return $.ajax({
      url: module.settings.api.getOrder,
      type: "GET",
      dataType: "json",
      success: function (res) {
        if (res.code === 200) {
          var data = res.data;
          data.voucher_id = res.data.voucher.id;
          data.voucher_cost = res.data.voucher.cost;
          data.voucher_code = res.data.voucher.code;
          delete data.voucher;
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
      $(".address_content-name").replaceWith(
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
      data.transport_fee -
      data.voucher_cost
    ).toFixed(2);
    $(module.settings.elements.list_order_checkout).html(
      template({ option: data })
    );
  };

  module.checkVoucherCode = function () {
    $(document).on("input", ".apply_voucher", function () {
      if ($(this).val() != "") {
        $(".btn-apply_voucher").addClass("btn-apply");
      } else {
        $(".btn-apply_voucher").removeClass("btn-apply");
      }
    });
  };

  module.handleApplyVoucher = function () {
    $(document).on("click", ".btn-apply", function () {
      var voucher_code = $("input[name=apply_voucher]").val();
      if (voucher_code.length > 0) {
        module.loadVoucherByAjax({ voucher_code: voucher_code });
      }
    });
  };

  module.handleSubmitVoucher = function () {
    $(document).on("keypress", ".apply_voucher", function (e) {
      var keycode = e.keyCode ? e.keyCode : e.which;
      if (keycode == "13") {
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
      type: "POST",
      data: data,
      dataType: "json",
      success: function (res) {
        $("input[name=apply_voucher]").val('')
        if (res.code === 200) {
          var data = res.data;
          data.voucher_id = res.data.voucher.id;
          data.voucher_cost = res.data.voucher.cost;
          data.voucher_code = res.data.voucher.code;
          delete data.voucher;
          module.renderOrderCheckout(data);
        } else {
          $.notify(res.message);
        }
      },
    });
  };

  module.changeAddress = function() {
    $(document).on('click', '#btn-confirm_address', function() {
      var address_id = $("input[name=address]").filter(":checked").val();
      var data = { id: address_id }
      return $.ajax({
        url: module.settings.api.address,
        type: "POST",
        data: data,
        dataType: "json",
        success: function (res) {
          if(res.code === 200) {
            var data = res.data;
            var addressDefault = data.address_default;
            var addresses = data.addresses;
            $(".address_content").toggle();
            $(".list-address_content").toggle();
            module.renderAddressDefault(addressDefault);
            module.renderAddresses(addresses);
            Swal.fire(
              {
                position: "center",
                icon: "success",
                title: res.message,
                showConfirmButton: false,
                timer: 1000,
              }
            );
          } else {
            $.notify(res.message);
          }
        },
      });
    })
  }

  module.handleInputAddress = function() {
    $(document).on("click", "#back_address, #change_address", function() {
      $(".address_content").toggle();
      $(".list-address_content").toggle();
    })
  };

  module.init = function () {
    module.getOrder();
    module.checkVoucherCode();
    module.handleSubmitVoucher();
    module.handleApplyVoucher();
    module.changeAddress();
    module.handleInputAddress();
  };
}

$(document).ready(function () {
  var checkout = new CCheckout();
  checkout.init();
});
