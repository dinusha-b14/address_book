class Batch::ContactsController < ApplicationController
  decorates_assigned :batch, with: BatchDecorator

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
        format.json { render json: { 'resource_url': batch_contact_path(@batch) } }
      else
        format.html { render :new }
        format.json { render json: { 'resource_url': '#' } }
      end
    end
  end

  def show
    @batch = Batch.find(params[:id])
    @results = Kaminari.paginate_array(@batch.results).page(params[:page])
  end
end
