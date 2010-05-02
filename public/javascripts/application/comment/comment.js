$(document).ready(function() { 
    var options = { 
        beforeSubmit:  showLoading,  // pre-submit callback 
        success:       showComment,  // post-submit callback 
        dataType:  'json'
    }; 
    $('#new-comment-post').ajaxForm(options); 
    $('#comment_body').focus(function () {
      $("#new-comment").remove();
    })
}); 

function showLoading(formData, jqForm, options) {
  $('#new-comment-loading').show();
  $('#new-comment-post').hide();
  return true;
}

function showComment(response_data, response_status) {
  $('#comment-errors').empty();

  if (!response_data.success) {
    for (var i=0; i<response_data.errors.length; i++) {
      $('#comment-errors').append('<div>' + response_data.errors[i] + '</div>');
    }
  } else {
    
  }
  $('#new-comment-loading').fadeOut("slow");
  $('#new-comment-post').reset();
  $('#new-comment-post').show();
  
  $("#new-comment").fadeOut("slow");
  
  var new_comment = $('<li id="comment-' + response_data.id + '">' + 
                      '<div style="margin-left: ' + 20 * (response_data.level-1) + 'px; ">' + 
                        '<p class="comment-author">' +
                          response_data.author_login + ' | ' +
                          response_data.comment_date + 
                        '</p>' +
                        '<p class="comment-body">' +
                        response_data.body +
                        '</p>' + 
                        '<p class="comment-reply">' + 
                          '(<a href="#" onclick="addCommentForm(' + response_data.id + ',' + response_data.level + ',' + response_data.post_id + ');return false;">ответить</a>)' + 
                        '</p>' +
                      '</div>' + 
                    '</li>');
   new_comment.hide();
   $('#comment-tree').append(new_comment);
   new_comment.fadeIn("slow");
}

function addCommentForm(parent_id, parent_level, post_id) {
  $("#new-comment").remove();
  var form_element     = $('<form action="/comment/create/new" id="new-comment-form" method="post"></form>');
  var parent_id_field  = $('<input type="hidden" name="comment[parent_id]" value="' + parent_id + '" />');
  var auth_field       = $('<input type="hidden" name="authenticity_token" value="' + authenticity_token + '" />');
  var post_id_field    = $('<input type="hidden" name="comment[post_id]" value="' + post_id + '" />');
  var body_textarea    = $('<textarea name="comment[body]" id="new-comment-body" cols="30" rows="5" style="height: 100px; width: 300px;"></textarea>');
  var form_submit      = $('<div class="clear" style="border:0; margin:0; padding:0;"></div><p><input type="submit" value="Отправить" class="fancy-submit" /></p>');
  
  form_element.append(parent_id_field);
  form_element.append(auth_field);
  form_element.append(post_id_field);
  form_element.append(body_textarea);
  form_element.append(form_submit);
 
  var list_element = $('<li id="new-comment" style="margin-left: ' + 20*(parent_level-1)  + 'px;"></li>').html(form_element);
  list_element.insertAfter("#comment-" + parent_id);
  $('#new-comment-body').focus();
  
  var options = {
    beforeSubmit:  showInlineLoading,  // pre-submit callback 
    success:       showInlineComment,  // post-submit callback 
    dataType:  'json'
  };
  $('#new-comment-form').ajaxForm(options);
}

function showInlineLoading(formData, jqForm, options) {
  $("#new-comment").html('<div style="text-align: center;"><img src="/images/ajax-loader.gif" /></div>');
}
function showInlineComment(response_data,response_status) {
  $("#new-comment").fadeOut("slow");
  var new_comment = $('<li id="comment-' + response_data.id + '">' + 
                      '<div style="margin-left: ' + 20 * (response_data.level-1) + 'px; ">' + 
                        '<p class="comment-author">' +
                            response_data.author_login + ' | ' +
                          response_data.comment_date + 
                        '</p>' +
                        '<p class="comment-body">' +
                        response_data.body +
                        '</p>' + 
                        '<p class="comment-reply">' + 
                          '(<a href="#" onclick="addCommentForm(' + response_data.id + ',' + response_data.level + ',' + response_data.post_id + ');return false;">ответить</a>)' + 
                        '</p>' +
                      '</div>' + 
                    '</li>');
   new_comment.hide();
   new_comment.insertAfter("#comment-" + response_data.after );
   new_comment.fadeIn("slow");
}

//subscribe/unsubscribe handler
$("[id^=subscribe_unsibscribe_comments_]").live('click', function(obj) {
  var matches = obj.currentTarget["id"].match(/^subscribe_unsibscribe_comments_(.*)/);
  var url = '/post/subscribe/';
  var checked = this.checked;
  if (!checked) {
    url = '/post/unsubscribe';
  }
  $.ajax({
    url: url,
    data: {id: matches[1]},
    type: 'post',
    success: function() {
      if (!checked) {
        $("#subscribe_status").text("");
      } else {
        $("#subscribe_status").text("(Вы подписаны)");
      }
    }
  })
});


