# -*- encoding : utf-8 -*-
Factory.define :tag do |f|
  f.sequence(:name) {|n| "tag#{n}" }
end
