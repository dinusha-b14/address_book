require 'rails_helper'

describe Batch::BatchContactsImporter, type: :service do
  subject { described_class.new(batch) }

  describe '#perform' do
    let(:batch) { create(:batch) }
    let(:csv_contacts_importer) { instance_double('CsvContactsImporter') }

    before do
      allow(csv_contacts_importer).to receive(:perform) { true }
      allow(CsvContactsImporter).to receive(:new).with(batch.file) { csv_contacts_importer }
    end

    it 'should update the batch record as necessary and call the importer' do
      expect(batch).to receive(:update).with(status: BatchStatus::PROCESSING)
      expect(csv_contacts_importer).to receive(:perform)
      expect(batch).to receive(:update).with(status: BatchStatus::COMPLETE)
      subject.perform
    end
  end
end
