class BatchForm < Reform::Form
  property :file

  validates :file, presence: true, file_size: { less_than_or_equal_to: 5.megabytes },
                   file_content_type: { allow: ['text/csv', 'text/plain'] }
end
