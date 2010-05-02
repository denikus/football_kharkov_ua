Factory.define :user do |f|
  f.username  "testuser"
  f.email "denix@test.ru"
  f.password "password"
  f.password_confirmation { |u| u.password }  
end