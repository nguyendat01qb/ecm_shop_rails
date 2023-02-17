import '../../lib/notify';

function CComment(options) {
  var module = this;
  var defaults = {
    api: {
      comment: '/v1/customer/comments',
      get_all: '/v1/customer/products/comments'
    },
  };

  module.settings = $.extend({}, defaults, options);

  module.loadComments = function(product_id) {
    return $.ajax({
      url: module.settings.api.get_all,
      type: 'POST',
      data: { product_id: product_id },
      dataType: 'json',
      contentType: false,
      processData: false,
      success: function (res) {
        if (res.code === 200) {
          debugger
        }
      },
    });
  }

  module.handleComment = function () {
    $('#btn_send_comment').on('click', function() {
      var data = new FormData();
      var comment = $('#comment').val();
      var product_id = $('#comment').attr('pr_id');
      data.append('comment', comment);
      data.append('product_id', product_id);
      var files = $('#rv_image').get(0).files
      _.map(files, function(file) {
        data.append(file.name, file);
      })
      return $.ajax({
        url: module.settings.api.comment,
        type: 'POST',
        data: data,
        dataType: 'json',
        contentType: false,
        processData: false,
        success: function (res) {
          if (res.code === 200) {
            module.loadComments(product_id);
          } else {
            $.notify(res.message);
          }
        },
      });
    });
  };

  module.init = function () {
    // module.loadComments();
    module.handleComment();
  };
}

$(document).ready(function () {
  var comment = new CComment();
  comment.init();
});
