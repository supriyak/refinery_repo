
FactoryGirl.define do
  factory :small_business, :class => Refinery::SmallBusinesses::SmallBusiness do
    sequence(:firstname) { |n| "refinery#{n}" }
  end
end

