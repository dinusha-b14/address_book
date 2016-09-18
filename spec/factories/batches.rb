FactoryGirl.define do
  factory :batch do
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv')) }
    batch_type { BatchType::CONTACTS }
    status { BatchStatus::CREATED }
    results { [] }
  end
end
