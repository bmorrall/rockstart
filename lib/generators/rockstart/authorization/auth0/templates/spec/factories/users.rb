# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uid { SecureRandom.uuid }

    name { [nickname, Faker::Name.last_name].join(" ") }
    nickname { Faker::Name.first_name }
    image { "https://s.gravatar.com/avatar/55502f40dc8b7c769880b10874abc9d0?s=480" }

    skip_create
    initialize_with do
      new(
        "provider" => "factory_bot",
        "uid" => attributes[:uid],
        "info" => attributes.except(:uid).stringify_keys
      )
    end

    trait :admin do
      # TODO: Add admin mode
    end
  end
end
