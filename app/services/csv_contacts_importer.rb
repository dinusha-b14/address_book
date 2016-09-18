require 'csv'

class CsvContactsImporter
  attr_accessor :file_path

  def initialize(file_path)
    @file_path = file_path
  end

  def perform
    csv_contacts do |csv_contact|
      csv_contact.save!
    end
  end

  private

  def csv_contacts
    ::CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|
      yield CsvContact.new(row.to_hash)
    end
  end

  class CsvContact < ::OpenStruct
    def contact
      @contact ||= Contact.unscoped.find_or_initialize_by(email: email)
    end

    def save!
      unless contact.persisted?
        contact.assign_attributes(to_h)
        contact.save!
      end
    end
  end
end
