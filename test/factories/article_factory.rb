Factory.define :article do |f|
  f.sequence(:body) {|u| "body#{u}" }
#  f.association :resource, :factory=>:post
end