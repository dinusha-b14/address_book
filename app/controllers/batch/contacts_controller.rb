class Batch::ContactsController < ApplicationController
  def new
    @batch_form = BatchForm.new(Batch.new)
  end
end
