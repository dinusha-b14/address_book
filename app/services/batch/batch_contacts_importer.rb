class Batch::BatchContactsImporter
  attr_accessor :batch, :success_ids, :general_failures, :batch_failures, :status
  delegate :file, to: :batch

  def initialize(batch)
    @batch = batch
    @success_ids = []
    @general_failures = []
    @batch_failures = []
  end

  def perform
    update_batch_status_to_processing
    begin
      CsvContactsImporter.new(file.path).perform do |csv_contact|
        set_attributes_with_csv_contact_result(csv_contact)
      end
    rescue CsvContactsImporter::CsvFileNotePopulatedError, CsvContactsImporter::CsvHeadersIncorrectError, StandardError => e
      set_batch_status_to_error(e)
    end
    update_batch
  end

  private

  def update_batch_status_to_processing
    batch.update(status: BatchStatus::PROCESSING)
  end

  def set_batch_status_to_error(error)
    self.status = BatchStatus::FAILED
    self.general_failures << error.message
  end

  def set_attributes_with_csv_contact_result(csv_contact)
    self.status = BatchStatus::COMPLETE
    if csv_contact.result.in?([ContactImportStatus::ERROR, ContactImportStatus::DUPLICATE_FOUND])
      self.batch_failures << csv_contact.failure_hash
      self.status = BatchStatus::COMPLETE_WITH_ERRORS
    else
      self.success_ids << csv_contact.contact_id
    end
  end

  def update_batch
    batch.update_attributes(
      status: status,
      batch_failures: batch_failures,
      success_ids: success_ids,
      general_failures: general_failures
    )
  end
end
