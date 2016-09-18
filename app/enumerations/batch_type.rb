class BatchType < EnumerateIt::Base
  associate_values(
    contacts: ['contacts', 'Contacts']
  )
end
