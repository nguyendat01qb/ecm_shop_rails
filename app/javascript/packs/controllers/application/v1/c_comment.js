import '../../lib/notify';

function CComment(options) {
  var module = this;
  var defaults = {
    api: {
      comment: '/v1/customer/comments',
    },
    templates: {
      list_comments: $('#list_comments_template')
    },
    elements: {
      list_comments: $('#list_comment')
    },
    data: {}
  };

  module.settings = $.extend({}, defaults, options);

  module.loadComments = function(callback) {
    return $.ajax({
      url: `/v1/customer/products/${module.settings.data.product_id}/comments`,
      type: 'GET',
      dataType: 'json',
      contentType: false,
      processData: false,
      success: function (res) {
        if (res.code === 200) {
          if (callback) {
            callback(res.data.comments);
          }
        }
      },
    });
  }

  module.handleComment = function () {
    $('#btn_send_comment').on('click', function() {
      var data = new FormData();
      var comment = $('#comment').val();
      data.append('comment', comment);
      data.append('product_id', module.settings.data.product_id);
      // var files = $('#rv_image').get(0).files
      // _.map(files, function(file) {
      //   data.append(file.name, file);
      // })
      module.ajaxComment(data);
    });
  };

  module.handleChangeTabComment = function () {
    $('.reviews').on('click', function () {
      module.loadComments(module.renderComments);
    })
  }

  module.renderComments = function (res) {
    var template = _.template(module.settings.templates.list_comments.html());
    module.settings.elements.list_comments.html(template({ options: res }));
  }

  module.handleReplyComment = function () {
    $(document).on('click', '.reply-comment', function () {
      $(document).find('.form-reply').hide();
      $(this).closest('.item_comment-user').find('.form-reply').toggle();
    });

    $(document).on('click', '#btn_reply_comment', function () {
      var data = new FormData();
      var comment = $('#reply_comment').val();
      var comment_id = $('#reply_comment').data('comment-id')
      data.append('comment', comment);
      data.append('product_id', module.settings.data.product_id);
      data.append('comment_id', comment_id);
      module.ajaxComment(data);
    })
  }

  module.ajaxComment = function (data) {
    return $.ajax({
      url: module.settings.api.comment,
      type: 'POST',
      data: data,
      dataType: 'json',
      contentType: false,
      processData: false,
      success: function (res) {
        if (res.code === 200) {
          module.loadComments(module.renderComments);
        } else {
          $.notify(res.message);
        }
        $('#comment').val('');
      },
    });
  }

  module.deleteComment = function () {
    $(document).on('click', '#delete_comment', function () {
      var comment_id = $(this).data('comment-id');
      return $.ajax({
        url: '/v1/customer/comments/' + comment_id,
        type: 'DELETE',
        dataType: 'json',
        success: function (res) {
          if (res.code === 200) {
            module.loadComments(module.renderComments);
          } else {
            $.notify(res.message);
          }
          $('#comment').val('');
        },
      });
    })
  }

  module.init = function () {
    module.settings.data.product_id = $('#product_id').val();
    module.handleChangeTabComment();
    module.handleComment();
    module.handleReplyComment();

    module.deleteComment();
  };
}

$(document).ready(function () {
  var comment = new CComment();
  comment.init();
});
