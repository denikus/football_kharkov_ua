var my_upload;
$(function () {  
	my_upload = $('#upload-link').upload({
        action: '/article/upload_image',
        params: {authenticity_token: authenticity_token},
		onSubmit: function() {
			$('#image-loading-container').show();
            $('#upload-link-container').fadeOut("normal");
            //setFilename();
		},
		onComplete: function(response) {
            json_response = eval('(' + response + ')');
            if (json_response.result=='success') {
                $('#image-loading-container').fadeOut("normal");
                setPicturePreview(json_response.path);
    }}});

if (''!=$('#article_image_file').val()) {
    $('#upload-link-container').hide();
        setPicturePreview(uploaded_file_path + $('#article_image_file').val());
    }
});

function setPicturePreview(picture) {
    if (my_upload.filename()!='') {
        $('#article_image_file').val(my_upload.filename());
    }
    $('#preview-container').html('<div style="text-align:center;width:200px;float:left;">' +
                                        '<img src="' + picture + '" width="200" />' +
                                        '<a href="#" onClick="deletePicturePreview();">удалить</a>' +
                                    '</div>' +
                                    '<div style="float:left;text-align:left;margin-left: 20px;">' +
                                        '<label for="article_image_title">Подпись:</label>' +
                                        '<input type="text" id="article_image_title" name="article_image[title]" class="text" value="' + article_image_article + '" />' +
                                  '</div>');
    $('#preview-container').fadeIn('normal');
}
function deletePicturePreview() {
    $('#article_image_file').val('');
    $('#preview-container').fadeOut('normal');
    $('#upload-link-container').fadeIn("normal");
}
