class Batch::ContactsController < ApplicationController
  def new
    @batch_form = BatchForm.new(Batch.new)
  end

  def create
    @batch_form = BatchForm.new(Batch.new)

    if @batch_form.validate(params[:batch])
      @success, @batch = ::Batch::BatchCreator.new(@batch_form, BatchType::CONTACTS).perform
    end

    if @success
      respond_to do |format|
        format.html { redirect_to batch_contact_path(@batch) }
        format.json { render json: { 'resource_url': batch_contact_path(@batch) } }
      end
    else
      render :new
    end
  end

  def show
    @batch = Batch.find(params[:id])
  end
end
