class Batch::ContactsController < ApplicationController
  def new
    @batch = BatchForm.new(Batch.new)
  end
end
