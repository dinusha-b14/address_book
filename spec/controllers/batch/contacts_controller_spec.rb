require 'rails_helper'

describe Batch::ContactsController, type: :controller do
  render_views

  describe 'GET #new' do
    before { get :new }

    it 'should render the page successfully' do
      expect(response).to be_success
      expect(response).to render_template('new')
    end
  end
end
