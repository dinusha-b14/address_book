FactoryGirl.define do
  factory :batch_failure do
    batch nil
    klass_id 1
    csv_data ""
    klass_errors "MyText"
    result "MyString"
  end
end
