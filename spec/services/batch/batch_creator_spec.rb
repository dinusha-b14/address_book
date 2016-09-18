require 'rails_helper'

describe Batch::BatchCreator, type: :service do
  subject { described_class.new(batch_form, batch_type) }

  describe '#perform' do
    context 'when batch type is for Contacts' do
      let(:batch) { Batch.new }
      let(:batch_form) { BatchForm.new(batch) }
      let(:batch_type) { BatchType::CONTACTS }
      let(:uploaded_file) { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv')) }

      let(:batch_params) do
        {
          file: uploaded_file
        }
      end

      before { batch_form.validate(batch_params) }

      it 'should create a new batch record' do
        expect { subject.perform }.to change(Batch, :count).by(1)
      end

      describe 'batch data' do
        before { subject.perform }

        it 'should set the correct data for the batch record' do
          expect(batch.batch_type).to eq(BatchType::CONTACTS)
          expect(batch.status).to eq(BatchStatus::CREATED)
          expect(batch.file).to be_an_instance_of(CsvUploader)
        end
      end

      describe 'batch scheduling' do
        before do
          allow(batch_form.model).to receive(:save) { batch_form.model.id = 1 }
        end

        it 'should schedule the batch worker' do
          expect(BatchWorker).to receive(:perform_async).with(1)
          subject.perform
        end
      end
    end
  end
end
