class BatchWorker
  include Sidekiq::Worker

  BATCH_IMPORTER_MAPPING = {
    BatchType::CONTACTS => Batch::BatchContactsImporter
  }

  def perform(batch_id)
    batch = Batch.find(batch_id)
    importer = importer_for_batch_type(batch)
    importer.new(batch).perform
  end

  def importer_for_batch_type(batch)
    BATCH_IMPORTER_MAPPING[batch.batch_type]
  end
end
