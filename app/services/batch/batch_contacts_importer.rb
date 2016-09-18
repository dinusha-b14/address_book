class Batch::BatchContactsImporter
  attr_accessor :batch
  delegate :file, to: :batch

  def initialize(batch)
    @batch = batch
  end

  def perform
    update_batch_status_to_processing
    CsvContactsImporter.new(file).perform
    update_batch_status_to_complete
  end

  private

  def update_batch_status_to_processing
    batch.update(status: BatchStatus::PROCESSING)
  end

  def update_batch_status_to_complete
    batch.update(status: BatchStatus::COMPLETE)
  end
end
