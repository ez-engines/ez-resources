# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test-user-#{n}@ez.test" }
    sequence(:name)  { |n| "test-user-#{n}-name" }
    age              { rand(18..65) }
    active           { true }
    gender           { %w[Male Female Other].sample }
    notes            { FFaker::Lorem.sentence }
  end
end
