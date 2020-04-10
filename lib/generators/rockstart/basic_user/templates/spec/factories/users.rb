# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }

    trait :admin do
      admin { true }
    end
  end
end
