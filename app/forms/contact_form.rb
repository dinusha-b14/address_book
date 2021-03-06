class ContactForm < Reform::Form
  property :first_name, validates: { presence: true }
  property :last_name, validates: { presence: true }
  property :email, validates: { presence: true }
  property :failure_id, virtual: true
end
