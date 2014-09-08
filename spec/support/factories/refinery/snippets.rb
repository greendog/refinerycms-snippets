
FactoryGirl.define do
  factory :snippet, :class => Refinery::Snippets::Snippet do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

