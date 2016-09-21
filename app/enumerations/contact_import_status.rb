class ContactImportStatus < EnumerateIt::Base
  associate_values(
    success: ['success', 'Success'],
    duplicate_found: ['duplicate_found', 'Duplicate Found'],
    error: ['error', 'Error']
  )
end
