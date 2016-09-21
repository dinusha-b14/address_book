require 'csv'

class CsvContactsImporter
  class CsvFileNotePopulatedError < StandardError; end;
  class CsvHeadersIncorrectError < StandardError; end;

  attr_accessor :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def perform
    raise CsvFileNotePopulatedError, 'CSV File Empty' unless file_populated?
    raise CsvHeadersIncorrectError, 'CSV Headers Incorrect' unless headers_valid?
    csv_contacts do |csv_contact|
      csv_contact.save
      yield csv_contact
    end
  end

  private

  def csv_contacts
    csv_enumerator.each do |row|
      yield CsvContact.new(row.to_hash)
    end
  end

  def csv_enumerator
    @csv_enumerator ||= ::CSV.foreach(file_path, headers: true, header_converters: :symbol)
  end

  def csv_headers
    csv_enumerator.first.headers
  end

  def headers_valid?
    csv_headers == [:first_name, :last_name, :email]
  end

  def file_populated?
    csv_enumerator.first.present?
  end

  class CsvContact < ::OpenStruct
    attr_accessor :result
    delegate :model, to: :contact_form, allow_nil: true, prefix: true
    delegate :id, to: :contact, allow_nil: true, prefix: true

    def contact
      # used the .unscoped scope here to ensure that all contacts are searched
      @contact ||= Contact.unscoped.find_or_initialize_by(email: sanitized_email)
    end

    def contact_form
      @contact_form ||= ContactForm.new(contact)
    end

    def save
      if contact_form.validate(import_hash)
        if contact_form_model.new_record?
          contact_form.save
          self.result = ::ContactImportStatus::SUCCESS
        else
          self.result = ::ContactImportStatus::DUPLICATE_FOUND
        end
      else
        self.result = ::ContactImportStatus::ERROR
      end
    end

    def errors
      @errors ||= contact_form.errors.full_messages
    end

    def failure_hash
      {
        id: contact_id,
        csv_data: to_h,
        errors: errors,
        result: result
      }
    end

    private

    def sanitized_email
      @sanitized_email ||= email.to_s.strip
    end

    def import_hash
      to_h.except(:email)
    end
  end
end
