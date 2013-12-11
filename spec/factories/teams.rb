# -*- encoding : utf-8 -*-

FactoryGirl.define do
  factory :team do
    name Faker::Name.name
  end
end