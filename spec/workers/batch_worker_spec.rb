require 'rails_helper'

describe BatchWorker, type: :worker do
  subject { described_class.new }

  describe '#perform' do
    context 'when batch type is Contacts' do
      let(:batch) { create(:batch, batch_type: BatchType::CONTACTS) }
      let(:batch_contacts_importer) { instance_double('Batch::BatchContactsImporter', perform: true) }

      before do
        allow(Batch::BatchContactsImporter).to receive(:new).with(batch) { batch_contacts_importer }
      end

      it 'should send the batch record to the contacts importer and run the perform action' do
        expect(batch_contacts_importer).to receive(:perform)
        subject.perform(batch.id)
      end
    end
  end
end
