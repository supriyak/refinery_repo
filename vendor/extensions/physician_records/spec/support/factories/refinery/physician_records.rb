
FactoryGirl.define do
  factory :physician_record, :class => Refinery::PhysicianRecords::PhysicianRecord do
    sequence(:firstname) { |n| "refinery#{n}" }
  end
end

