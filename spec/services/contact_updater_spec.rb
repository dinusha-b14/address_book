require 'rails_helper'

describe ContactUpdater, type: :service do
  subject { described_class.new(form) }

  let(:contact) { create(:contact) }
  let(:form) { ContactForm.new(contact) }

  before { form.validate(params) }

  describe '#perform' do
    before { subject.perform }

    context 'when batch failure does not exist' do
      let(:params) do
        {
          first_name: 'David',
          last_name: 'Jefferys',
          email: 'test9827349823@test.com.au'
        }
      end

      it 'should update the contact record' do
        expect(contact.reload.first_name).to eq('David')
        expect(contact.reload.last_name).to eq('Jefferys')
        expect(contact.reload.email).to eq('test9827349823@test.com.au')
      end
    end

    context 'when batch failure exists' do
      let!(:batch) { create(:batch) }
      let!(:batch_failure) { create(:batch_failure, batch: batch) }
      let(:params) do
        {
          first_name: 'David',
          last_name: 'Jefferys',
          email: 'test9827349823@test.com.au',
          failure_id: batch_failure.id
        }
      end

      it 'should add the contact id to the success_ids array' do
        expect(batch.reload.success_ids).to include(contact.id)
        expect{ batch_failure.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
