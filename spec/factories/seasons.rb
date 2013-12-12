# -*- encoding : utf-8 -*-

FactoryGirl.define do

  factory :season do
    type "StepSeason"
    name Faker::Name.name
    url { "#{name}"}
  end

end