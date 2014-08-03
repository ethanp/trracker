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
    priority 0
  end

  factory :interval do
    start DateTime.now - 1.hour
    self.end DateTime.now
    task_id 1
  end

end
