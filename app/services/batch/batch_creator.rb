class Batch::BatchCreator
  attr_accessor :form, :batch_type
  delegate :model, to: :form

  def initialize(form, batch_type)
    @form = form
    @batch_type = batch_type
  end

  def perform
    form.sync
    model.batch_type = batch_type
    success = form.save
    BatchWorker.perform_async(model.id) if success
    [success, model]
  end
end
