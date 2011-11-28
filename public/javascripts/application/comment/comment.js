/*

"Харьков Футбольный"
Comments functionality

Author: "Харьков Футбольный"
Copyright: 2011, "Харьков Футбольный". All rights resevered

-----------------------------------------------------------------------*/

if (!FHU) var FHU = {};

(function ($) {

  // document ready
  $(document).ready(function () {

    new FHU.postComment();
    new FHU.writeComment();

  });

  // ============================================================
  // WRITE COMMENT
  // ============================================================
  FHU.writeComment = function () {
    var postComment = new FHU.postComment();

    // constructor
    this.writeComment = function () {
      mention();
    };
    var mention = function () {
      var nickToMention = '.commentAuthor .username';

      $(nickToMention).live('click', function () {
        var self = $(this);
        
        if (!postComment.isReplyOpened()) {
          self.parents('.comment').find('a.commentReply').click();
        }

        currentForm = postComment.getReplyBox();
        var txtArea = currentForm.find('textarea'),
            currCommentText = txtArea.text();
        txtArea.text(currCommentText + ' ' + self.text() + ',');
        txtArea.focus();
        $.scrollTo('#' + currentForm.attr('id'), 200);

        return false;
      });
    };
    this.writeComment();
  };

  // ============================================================
  // POST COMMENT
  // ============================================================
  FHU.postComment = function () {
    var maxCommentLevel = 8,
        selectors = {
          newComment: {
            form: '#newComment',
            txtArea: '#comment_body',
            loader: '.newComment .loader'
          },
          newReply: {
            holder: '#newReply',
            link: '.comments a.commentReply',
            formId: 'newReplyForm',
            txtAreaId: 'newReplyTxtArea'
          }
        };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // CONSTRUCTOR
    // // // // // // // // // // // //
    this.postComment = function () {
      var options = {
        beforeSubmit: beforeCommentSubmit,  // pre-submit callback 
        success: afterCommentSubmit,  // post-submit callback 
        dataType: 'json'
      };
      $(selectors.newComment.form).ajaxForm(options);

      $(selectors.newComment.txtArea).focus(function () {
        $(selectors.newReply.holder).remove();
      });

      // user clicked on a "Reply" button
      $(selectors.newReply.link).live('click', function () {
        var self = $(this),
            opts = self.data("options");

        $(selectors.newReply.link).show();
        self.hide();
        addReply(opts.id, opts.level, opts.postId);
        return false;
      });

    };


    this.getReplyBox = function () {
      return $(selectors.newReply.holder);
    };

    this.isReplyOpened = function () {
      return $(selectors.newReply.holder).length ? true : false;
    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // before a comment submit actions
    // // // // // // // // // // // //
    var beforeCommentSubmit = function (formData, jqForm, options) {
      return beforeSubmitAction($(selectors.newComment.form), $(selectors.newComment.loader));
    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // before a reply submit actions
    // // // // // // // // // // // //
    var beforeReplySubmit = function (formData, jqForm, options) {
      return beforeSubmitAction($('#' + selectors.newReply.formId), $(selectors.newReply.holder).find('.loader'));
    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // before submit
    // @formToHide - this form will be hidden
    // @loader - loader will be shown instead of form
    // // // // // // // // // // // //
    var beforeSubmitAction = function (formToHide, loader) {
      if($.trim(formToHide.find('textarea').val()) == '') {
        errorShakeForm();
        return false;
      }
      formToHide.css('visibility', 'hidden');
      loader.show();

      return true;

      function errorShakeForm() {
        var currTxtArea = formToHide.find('.txtAreaBox');
        currTxtArea.css('border-color', '#fcc1c1');
        currTxtArea.animate({'left': '-10px'}, 200)
                   .animate({'left': '0'}, 200, function(){
                      currTxtArea.css('border-color', '#eee');
                    });
      }

    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // actions when comment submit has been done successfully 
    // // // // // // // // // // // //
    var afterCommentSubmit = function (response_data, response_status) {
      $('#comment-errors').empty();
      if (!response_data.success) {
        for (var i = 0; i < response_data.errors.length; i++) {
          $('#comment-errors').append('<div>' + response_data.errors[i] + '</div>');
        }
      }

      $(selectors.newComment.loader).fadeOut("slow");
      $(selectors.newComment.form).each(function () {
        this.reset();
      });
      $(selectors.newComment.form).css('visibility', 'visible');

      var new_comment = $(getCommentHtml(response_data));
      new_comment.hide();
      $('#comment-tree').append(new_comment);
      new_comment.fadeIn("slow");
    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // adding a reply to comment
    // @parent_id - parent comment id
    // @parent_level - parent comment level
    // @post_id - current post id
    // // // // // // // // // // // //
    var addReply = function (parent_id, parent_level, post_id) {
      $(selectors.newReply.holder).remove();

      var addReplyBox = '<div class="postCommentBox">' +
                          '<form action="/comment/create/new" id="' + selectors.newReply.formId + '" method="post">' +
                            '<input type="hidden" name="comment[parent_id]" value="' + parent_id + '" />' +
                            '<input type="hidden" name="comment[post_id]" value="' + post_id + '" />' +
                            '<div class="txtAreaBox"><textarea name="comment[body]" id="' + selectors.newReply.txtAreaId + '"></textarea></div>' +
                            '<div class="btnSubmitHolder"><input type="submit" value="Отправить" class="button primary" /></div>' +
                          '</form>' +
                          '<div class="loader"></div>' +
                        '</div>';

      var list_element = $('<li id="newReply" style="margin-left: ' + 20 * (parent_level) + 'px;"></li>').html(addReplyBox);
      list_element.insertAfter("#comment-" + parent_id);
      $('#' + selectors.newReply.txtAreaId).focus();

      var options = {
        beforeSubmit: beforeReplySubmit,  // pre-submit callback 
        success: successReplySubmit,  // post-submit callback 
        dataType: 'json'
      };
      $('#' + selectors.newReply.formId).ajaxForm(options);
    }

    // // // // // // // // // // // // // // // // // // // // // // // //
    // actions when a reply has been submitted successfully
    // // // // // // // // // // // //
    var successReplySubmit = function (response_data, response_status) {
      $(selectors.newReply.holder).fadeOut("slow");
      var new_comment = $(getCommentHtml(response_data));
      new_comment.hide()
                 .insertAfter("#comment-" + response_data.after)
                 .fadeIn("slow");
      $(selectors.newReply.link).show();
    };

    // // // // // // // // // // // // // // // // // // // // // // // //
    // gets html for a just added comment
    // @data - added comment data
    // returns: html of added comment
    // // // // // // // // // // // //
    var getCommentHtml = function (data) {
      var shiftComment = (data.level > maxCommentLevel) ? maxCommentLevel : data.level;

      return '<li id="comment-' + data.id + '" class="comment">' +
                '<div class="commentContent" style="margin-left: ' + 20 * (shiftComment - 1) + 'px; ">' +
                  '<div class="avatar"></div>' +
                  '<dl class="commentInfo">' +
                    '<dt class="commentAuthor">' +
                      '<a class="username" href="#">' + data.author_login + '</a>' +
                    '</dt>' +
                    '<dd class="datetime">' + data.comment_date + '</dd>' +
                  '</dl>' +
                  '<div class="commentBody">' +
                    '<p>' + data.body + '</p>' +
                  '</div>' +
                '</div>' +
                '<a href="#" class="button commentReply" data-options=\'{"id": "' + data.id + '", "level": "' + shiftComment + '", "postId": "' + data.post_id + '"}\'>ответить</a>' +
              '</li>';
    }

    // call constructor
    this.postComment();
  }


  //subscribe/unsubscribe handler
  $("[id^=subscribe_unsibscribe_comments_]").live('click', function (obj) {
    var matches = obj.currentTarget["id"].match(/^subscribe_unsibscribe_comments_(.*)/);
    var url = '/post/subscribe/';
    var checked = this.checked;
    if (!checked) {
      url = '/post/unsubscribe';
    }
    $.ajax({
      url: url,
      data: { id: matches[1] },
      type: 'post',
      success: function () {
        if (!checked) {
          $("#subscribe_status").text("");
        } else {
          $("#subscribe_status").text("(Вы подписаны)");
        }
      }
    });
  });

})(jQuery);