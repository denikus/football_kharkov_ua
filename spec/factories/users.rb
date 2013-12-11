# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :user, aliases: [:author] do
    username Faker::Name.name
    email Faker::Internet.email
    #email { "#{username}@example.com".downcase }
    password { "#{username}123"}
  end

  factory :confirmed_user, parent: :user do
    confirmed_at 2.days.ago
  end

end