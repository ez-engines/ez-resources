# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title      { FFaker::Lorem.sentence }
    body       { FFaker::Lorem.sentence }
    published  { true }
  end
end
