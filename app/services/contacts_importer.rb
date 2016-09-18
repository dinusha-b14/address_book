require 'csv'

class ContactsImporter
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

  def update_batch_status_to_processing
    batch.update(status: BatchStatus::PROCESSING)
  end

  def update_batch_status_to_complete
    batch.update(status: BatchStatus::COMPLETE)
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
