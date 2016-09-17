class Batch < ActiveRecord::Base
  mount_uploader :file, CsvUploader
end
