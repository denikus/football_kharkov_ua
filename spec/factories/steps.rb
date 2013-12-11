# -*- encoding : utf-8 -*-

FactoryGirl.define do

  factory :season do
    type "StepSeason"
    name Faker::Name.name
  end

  factory :stage do
    type "StepStage"
    name Faker::Name.name
  end

end