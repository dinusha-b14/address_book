class ContactUpdater
  attr_accessor :form
  delegate :model, to: :form
  delegate :batch, to: :batch_failure, allow_nil: true

  def initialize(form)
    @form = form
  end

  def perform
    form.save
    if batch_failure
      batch.success_ids << model.id
      batch.save
      batch_failure.destroy
    end
  end

  private

  def batch_failure
    @batch_failure ||= BatchFailure.find_by(id: form.failure_id)
  end
end
