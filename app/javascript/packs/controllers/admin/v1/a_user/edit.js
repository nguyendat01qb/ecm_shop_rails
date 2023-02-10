
function AUserEdit() {
  var module = this;
  // var defaults = {
  //   pagination_template: $('#pagination-template'),
  //   pagination_content: $('#paginate'),
  //   page: 1,
  //   per_page: 10,
  //   api: {
  //     get_all: '/v1/admin/load_users',
  //   },
  //   data: {
  //     list_users: {},
  //   },
  // };

  module.handleImageInput = function() {
    $('#user_avatar').on('change', () => {
      const preview = $('.preview');
      const file = $('#user_avatar')[0].files[0];
      const reader = new FileReader();

      $(reader).on('load', ({ target }) => {
        preview.empty();
        preview.append(
          $('<img/>', {
            src: target.result,
            class: 'preview img-thumbnail',
          })
        );
      });

      reader.readAsDataURL(file);
    });
  }

  module.init = function () {
    module.handleImageInput();
  };
}

$(document).ready(function () {
  var user_edit = new AUserEdit();
  user_edit.init();
});
