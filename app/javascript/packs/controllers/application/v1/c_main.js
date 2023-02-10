function CMain(options) {
  var module = this;
  var defaults = {
    api: {
      getProductCart: "/v1/customer/home/get_product_cart",
    },
    elements: {
      cart_icon: $(".count-product"),
    },
  };

  module.settings = $.extend({}, defaults, options);

  module.loadProductCart = function () {
    return $.ajax({
      url: module.settings.api.getProductCart,
      type: "GET",
      dataType: "json",
      success: function (res) {
        if (res.code === 200) {
          module.settings.elements.cart_icon.get(0).innerText =
            res.data.number_of_items > 0 ? res.data.number_of_items : "";
        } else {
          const product_ids = _.uniq(
            _.map(JSON.parse(localStorage.getItem("carts")), function (attr) {
              return attr.product_id;
            })
          );
          module.settings.elements.cart_icon.get(0).innerText =
            product_ids.length > 0 ? product_ids.length : "";
        }
      },
    });
  };

  module.init = function () {
    module.loadProductCart();
  };
}

$(document).ready(function () {
  var main = new CMain();
  main.init();
});
