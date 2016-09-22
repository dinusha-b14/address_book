class Batch < ActiveRecord::Base
  extend EnumerateIt
  mount_uploader :file, CsvUploader

  has_many :batch_failures

  has_enumeration_for :status, with: BatchStatus, create_helpers: { prefix: true }
  has_enumeration_for :batch_type, with: BatchType, create_helpers: { prefix: true }
end
