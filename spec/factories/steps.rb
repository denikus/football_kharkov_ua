# -*- encoding : utf-8 -*-

FactoryGirl.define do

  factory :stage do
    type "StepStage"
    name Faker::Name.name
  end

end