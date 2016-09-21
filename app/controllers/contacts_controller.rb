class ContactsController < ApplicationController
  decorates_assigned :contacts

  def index
    @contacts = Contact.last_name_alphabetical.page(params[:page])
  end

  def update
    
  end
end
