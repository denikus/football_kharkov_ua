# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :post do
    title "test"
    user
    tournament
  end
end