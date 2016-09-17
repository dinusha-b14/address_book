require 'rails_helper'

describe ContactsController, type: :controller do
  render_views

  describe 'GET #index' do
    before { get :index }

    it 'should render the page successfully' do
      expect(response).to be_success
      expect(response).to render_template('index')
    end
  end
end
