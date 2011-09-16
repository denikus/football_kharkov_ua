require 'rubygems'
require 'mechanize'

a = Mechanize.new

a.get('http://www.kharkovforum.com/') do |home_page|

  my_page = form_with(:action => 'login.php?do=login') do |form|
    form.login  = 'denix'
    form.passwd = 'U7sYJ15VVxwzJbbriPyR'
  end.submit

  my_page = a.click("")

  # Click the upload link
  upload_page = a.click(my_page.link_with(:text => /Upload/))

  # We want the basic upload page.
  upload_page = a.click(upload_page.link_with(:text => /basic Uploader/))

  # Upload the file
  upload_page.form_with(:method => 'POST') do |upload_form|
    upload_form.file_uploads.first.file_name = ARGV[2]
  end.submit
end