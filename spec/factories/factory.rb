FactoryGirl.define do

  factory :user do
    email "test@test.com"
    password "12345678"
    first_name "Alice"
    last_name "In"
  end

  factory :category do
    name "Categ"
    user_id 1
    description "This is a FactoryGirl category"
  end

  factory :task do
    name "Tisket"
    category_id 1
    complete false
    duedate DateTime.now
    priority 0
  end

end
