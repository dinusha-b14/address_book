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

  describe '#create' do
    context 'HTTP' do
      before do
        post :create, batch: { file: csv_file }
      end

      context 'when uploaded file is valid' do
        let(:csv_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv')) }

        it 'should redirect to the show page' do
          expect(response).to have_http_status(:redirect)
        end
      end

      context 'when uploaded file is invalid' do
        let(:csv_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'resume.pdf'), content_type: 'application/pdf') }

        it 'should redirect to the show page' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'JSON' do
      before do
        post :create, batch: { file: csv_file }, format: :json
      end

      context 'when uploaded file is valid' do
        let(:csv_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv')) }

        it 'should redirect to the show page' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'when uploaded file is invalid' do
        let(:csv_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'resume.pdf'), content_type: 'application/pdf') }

        it 'should redirect to the show page' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq({ file: ['only application/csv, application/vnd.ms-excel, text/csv, text/plain are allowed']}.to_json)
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:contact_one) { create(:contact) }
    let!(:contact_two) { create(:contact) }

    let(:error_csv_data) {
      {
        'first_name' =>'Michael',
        'last_name' => 'Thomas',
        'email' => 'test983748923@test.com.au'
      }
    }

    let!(:batch_failure) do
      create(
        :batch_failure,
        batch: batch,
        klass_id: 3,
        csv_data: error_csv_data,
        klass_errors: [],
        result: ContactImportStatus::DUPLICATE_FOUND
      )
    end

    let!(:batch) do
      create(
        :batch,
        status: BatchStatus::COMPLETE,
        success_ids: [contact_one.id, contact_two.id],
        general_failures: []
      )
    end

    before { get :show, id: batch.id }

    it 'should render the page successfully' do
      expect(response).to be_success
      expect(response).to render_template('show')
    end
  end
end
