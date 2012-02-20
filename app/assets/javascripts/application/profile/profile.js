if (undefined == Application) {
  var Application = {};
}

Application.photo_upload = {
  init: function() {
    //assign on select event for file input
    $("input#photo-upload-field").change(function() {
      $("#photo-upload-form").submit();
      $("#photo-upload-form,.jcrop-holder, #photo-crop-form").hide();
      $(".image-loading-container").show();
    });
  }
};

Application.crop = {
  original_width: 0,
  large_width:    0,
  large_height:   0,
  crop_x_default: 0,
  crop_y_default: 0,
  crop_width_default: 200,
  crop_height_default: 200,
  ratio: 1,

  init: function(options) {
    this.original_width       = parseFloat(options.original_width);
    this.large_width          = parseFloat(options.large_width);
    this.large_height         = parseFloat(options.large_height);
    this.crop_x_left          = parseInt(options.x_left);
    this.crop_y_top           = parseInt(options.y_top);
    this.crop_x_right         = parseInt(options.x_right);
    this.crop_y_bottom        = parseInt(options.y_bottom);

    this.ratio                = this.original_width / this.large_width;

    $('#cropbox').Jcrop({
      onChange: this.updateCrop,
      onSelect: this.updateCrop,
      setSelect: [ Math.floor(this.crop_x_left / this.ratio), Math.floor(this.crop_y_top / this.ratio), Math.floor(this.crop_x_right / this.ratio), Math.floor(this.crop_y_top / this.ratio)],
      aspectRatio: 1
    });
  },

  updateCrop: function(coords) {
    $('#crop_x').val(Math.floor(coords.x * Application.crop.ratio));
    $('#crop_y').val(Math.floor(coords.y * Application.crop.ratio));
    $('#crop_w').val(Math.floor(coords.w * Application.crop.ratio));
    $('#crop_h').val(Math.floor(coords.h * Application.crop.ratio));
  }
};