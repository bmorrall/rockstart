# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    name { Faker::Name.name }

    trait :admin do
      admin { true }
    end

    trait :soft_deleted do
      deleted_at { Time.zone.now }
    end
  end
end
