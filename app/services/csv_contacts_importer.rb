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
      yield csv_contact.result_hash
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

    def contact
      @contact ||= Contact.unscoped.find_or_initialize_by(email: sanitized_email)
    end

    def save
      contact.assign_attributes(to_h.except(:email))
      if contact.new_record?
        contact.save
        self.result = 'success'
      else
        self.result = 'duplicate_found'
      end
    end

    def result_hash
      {
        id: contact.id,
        first_name: first_name,
        last_name: last_name,
        email: sanitized_email,
        result: result
      }
    end

    private

    def sanitized_email
      @sanitized_email ||= email.to_s.strip
    end
  end
end
