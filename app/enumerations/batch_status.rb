class BatchStatus < EnumerateIt::Base
  associate_values(
    created: ['created', 'Created'],
    processing: ['processing', 'Processing'],
    complete: ['complete', 'Complete'],
    complete_with_errors: ['complete_with_errors', 'Processing completed however errors were found'],
    failed: ['failed', 'Failure']
  )
end
