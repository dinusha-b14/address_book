class BatchStatus < EnumerateIt::Base
  associate_values(
    created: ['created', 'Created'],
    processing: ['processing', 'Processing'],
    complete: ['complete', 'Complete'],
    failed: ['failed', 'Failed']
  )
end
