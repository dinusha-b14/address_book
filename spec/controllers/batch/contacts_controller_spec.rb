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

  describe 'POST #create' do
    before do
      post :create, batch: { file: csv_file }
    end

    context 'when uploaded file is valid' do
      let(:csv_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv')) }

      it 'should redirect to the show page' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'GET #show' do
    let(:batch) { create(:batch) }

    before { get :show, id: batch.id }

    it 'should render the page successfully' do
      expect(response).to be_success
      expect(response).to render_template('show')
    end
  end
end
