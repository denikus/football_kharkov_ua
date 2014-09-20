class Ckeditor::Picture < Ckeditor::Asset
  has_attached_file :data,
                    :url  => "/ckeditor_assets/pictures/:id/:style_:basename.:extension",
                    :path => ":rails_root/public/ckeditor_assets/pictures/:id/:style_:basename.:extension",
	                  :styles => { :content => '575>', :thumb => '80x80#' }
	
	validates_attachment_size :data, :less_than => 3.megabytes
  validates_attachment_content_type :data, :content_type => %w(image/jpeg image/jpg image/png)
	validates_attachment_presence :data
	
	def url_content
	  url(:content)
	end
end
