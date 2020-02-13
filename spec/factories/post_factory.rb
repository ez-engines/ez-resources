# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title      { |n| "test-title-#{n}" }
    body       { FFaker::Lorem.sentence  }
    published  { true  }
  end
end
