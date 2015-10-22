# -*- encoding : utf-8 -*-
module ProfileHelper
  def crop_data(profile)
    if profile.cropped?
      {x: profile.crop_x, y: profile.crop_y, width: profile.crop_w, height: profile.crop_h}
    else
      nil
    end
  end
end
