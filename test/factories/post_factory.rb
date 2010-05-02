Factory.define :post do |f|
  f.sequence(:title) {|u| "title#{u}"}
  f.sequence(:url) {|u| "url#{u}"}
  f.association :resource, :factory => :article 
  f.association :user

end