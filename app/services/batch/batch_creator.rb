class Batch::BatchCreator
  attr_accessor :form
  delegate :model, to: :form

  def initialize(form)
    @form = form
  end

  def perform
    form.save
  end
end
