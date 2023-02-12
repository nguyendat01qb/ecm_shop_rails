import "../../lib/notify";

function ACategory(options) {
  var module = this;
  var defaults = {
    pagination_template: $("#pagination-template"),
    pagination_content: $("#paginate"),
    page: 1,
    per_page: 10,
    api: {
      get_all: "/v1/admin/load_categories",
    },
    data: {
      list_categories: {},
    },
  };

  var elements = {
    container: $("#categories_list"),
    list_categories: $("#admin_category_template"),
  };

  module.settings = $.extend({}, defaults, options);

  module.loadCategories = function (callback) {
    return $.ajax({
      url: module.settings.api.get_all + "?page=" + module.settings.page,
      type: "GET",
      dataType: "json",
      success: function (res) {
        if (res.code === 200) {
          module.settings.data.list_categories = res.data.categories;
          module.settings.total_page = res.data.total_page;
          module.settings.total = res.data.total;
          module.settings.per_page = res.data.per_page;
          if (module.settings.total_page > 1) {
            $("#paginate").show();
            module.initPaginate();
          } else {
            $("#paginate").hide();
          }
          if (callback) {
            callback();
          }
        }
      },
    });
  };

  module.renderCategories = function () {
    var categories = module.settings.data.list_categories;
    var template = _.template(elements.list_categories.html());
    _.each(categories, (category, idx) => {
      category.idx =
        (module.settings.page - 1) * module.settings.per_page + idx + 1;
    });
    $(elements.container).html(template({ options: categories }));
    module.eventGoPage();
  };

  module.eventGoPage = function () {
    $(".pagination span a").on("click", function () {
      if ($(this).closest(".page").hasClass("current")) return;
      module.settings.page = $(this).data("page");
      module.loadCategories(module.renderCategories);
    });
  };

  module.initPaginate = function () {
    var pagination = _.template(module.settings.pagination_template.html());
    var totalpage_info =
      1 + (module.settings.page - 1) * module.settings.per_page;
    module.settings.pagination_content.html("");
    module.settings.pagination_content.append(pagination(module.settings));
    totalpage_info += " - ";
    if (module.settings.per_page == module.settings.data.list_categories.length)
      totalpage_info += module.settings.per_page * module.settings.page;
    else
      totalpage_info +=
        module.settings.per_page * (module.settings.page - 1) +
        module.settings.data.list_categories.length;

    $(".totalpage_info").html(totalpage_info);
  };

  module.init = function () {
    module.loadCategories(module.renderCategories);
  };
}

$(document).ready(function () {
  var category = new ACategory();
  category.init();
});
