FactoryBot.define do
  factory :user do
    id { 1 }
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
    admin { false }
    closed { false }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :style do
    name { "Lager" }
    description { "Great beer!" }
  end

  factory :beer do
    name { "anonymous" }
    style
    brewery
  end

  factory :rating do
    score { 10 }
    beer
    user
  end
end
