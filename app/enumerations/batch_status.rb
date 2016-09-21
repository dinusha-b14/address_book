class BatchStatus < EnumerateIt::Base
  associate_values(
    created: ['created', 'Created'],
    processing: ['processing', 'Processing'],
    complete: ['complete', 'Complete'],
    complete_with_errors: ['complete_with_errors', 'Completed with errors'],
    failed: ['failed', 'Failure']
  )
end
