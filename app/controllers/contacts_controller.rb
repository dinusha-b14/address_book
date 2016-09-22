class ContactsController < ApplicationController
  decorates_assigned :contacts

  def index
    @contacts = Contact.last_name_alphabetical.page(params[:page])
  end

  def edit
    @contact = Contact.find(params[:id])
    @contact_form = ContactForm.new(@contact)
  end

  def update
    @contact = Contact.find(params[:id])
    @contact_form = ContactForm.new(@contact)

    respond_to do |format|
      if @contact_form.validate(params[:contact])
        ContactUpdater.new(@contact_form).perform
        format.html { redirect_to contacts_path }
        format.json { render json: @contact_form.model, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @contact_form.errors, status: :unprocessable_entity }
      end
    end
  end
end
