class Batch::BatchContactsImporter
  attr_accessor :batch
  delegate :file, to: :batch
  delegate :results, to: :batch
  delegate :failures, to: :batch

  def initialize(batch)
    @batch = batch
  end

  def perform
    set_batch_status_to_processing
    begin
      CsvContactsImporter.new(file.path).perform do |result|
        update_batch_with_csv_result(result)
      end
    rescue CsvContactsImporter::CsvFileNotePopulatedError, CsvContactsImporter::CsvHeadersIncorrectError, StandardError => e
      set_batch_status_to_error(e)
    else
      set_batch_status_to_complete
    end
  end

  private

  def set_batch_status_to_processing
    batch.status = BatchStatus::PROCESSING
    batch.save
  end

  def set_batch_status_to_complete
    batch.status = BatchStatus::COMPLETE
    batch.save
  end

  def set_batch_status_to_error(error)
    existing_failures = failures
    batch.status = BatchStatus::FAILED
    batch.failures = existing_failures << error.message
    batch.save
  end

  def update_batch_with_csv_result(result)
    existing_results = results
    batch.results = existing_results << result
    batch.save
  end
end
