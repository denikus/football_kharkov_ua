# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :user, aliases: [:author] do
    username "denis"
    email { "#{username}@example.com".downcase }
    password { "#{username}123"}
  end

  factory :confirmed_user, parent: :user do
    confirmed_at 2.days.ago
  end

  factory :tournament do
    name "IT-Лига"
    url "itleague"
  end


  factory :post do
    title "test"
    user
    tournament
  end

  factory :article do
    body "test body"
  end

end