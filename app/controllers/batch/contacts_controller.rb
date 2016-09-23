class Batch::ContactsController < ApplicationController
  decorates_assigned :batch, with: BatchDecorator
  decorates_assigned :batch_failures, with: BatchFailuresDecorator
  decorates_assigned :successful_contacts, with: ContactsDecorator

  def new
    @batch_form = BatchForm.new(Batch.new)
  end

  def create
    @batch_form = BatchForm.new(Batch.new)

    if @batch_form.validate(params[:batch])
      @success, @batch = ::Batch::BatchCreator.new(@batch_form, BatchType::CONTACTS).perform
    end

    respond_to do |format|
      if @success
        format.html { redirect_to batch_contact_path(@batch) }
        format.json { render json: { 'resource_url': batch_contact_path(@batch) }, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @batch_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @batch = Batch.find(params[:id])
    @batch_failures = @batch.batch_failures.page(params[:errors_page])
    @successful_contacts = Contact.where(id: @batch.success_ids).page(params[:success_page])
  end
end
