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

  describe 'GET #edit' do
    let!(:contact) { create(:contact) }

    before { get :edit, id: contact.id }

    it 'should render the page successully' do
      expect(response).to be_success
      expect(response).to render_template('edit')
    end
  end

  describe 'PUT #update' do
    let!(:contact) { create(:contact) }

    before do
      put :update, id: contact.id, contact: { first_name: first_name, last_name: 'Jefferson' }, format: response_format
    end

    context 'when valid params' do
      let(:first_name) { 'Thomas' }
      let(:response_format) { :html }

      context 'when response is HTML' do
        it 'should update the contact details' do
          expect(contact.reload.first_name).to eq('Thomas')
          expect(contact.reload.last_name).to eq('Jefferson')
          expect(response).to redirect_to(contacts_path)
        end
      end

      context 'when response is JSON' do
        let(:response_format) { :json }

        it 'should respond with json data' do
          expect(response).to be_success
          expect(response.body).to eq(contact.reload.to_json)
        end
      end
    end

    context 'when invalid params' do
      let(:first_name) { '' }
      let(:response_format) { :html }

      context 'when response is HTML' do
        it 'should not update the contact details' do
          expect(contact.reload.first_name).to_not eq('Thomas')
          expect(contact.reload.first_name).to_not eq('Jefferson')
          expect(response).to render_template('edit')
        end
      end

      context 'when response is JSON' do
        let(:response_format) { :json }

        it 'should respond with json data' do
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.body).to eq({first_name: ['can\'t be blank']}.to_json)
        end
      end
    end
  end
end
