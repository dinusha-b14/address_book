require 'rails_helper'

describe Batch::BatchContactsImporter, type: :service do
  subject { described_class.new(batch) }

  describe '#perform' do
    let(:batch) { create(:batch) }
    let(:csv_contacts_importer) { instance_double('CsvContactsImporter') }

    let(:result_one) { { id: 3, first_name: 'John', last_name: 'Michaels', email: 'test892378923@test.com.au', result: 'success' } }
    let(:result_two) { { id: 5, first_name: 'Mark', last_name: 'Thompson', email: 'test273678123@test.com.au', result: 'duplicate_found' } }

    context 'when no errors are raised by CsvContactsImporter' do
      before do
        allow(csv_contacts_importer).to receive(:perform).and_yield(result_one).and_yield(result_two)
        allow(CsvContactsImporter).to receive(:new).with(batch.file.path) { csv_contacts_importer }
        subject.perform
      end

      it 'should update the batch record as necessary and call the importer' do
        expect(batch.status).to eq(BatchStatus::COMPLETE)
        expect(batch.failures).to eq([])
        expect(batch.results.map(&:symbolize_keys)).to eq([result_one, result_two])
      end
    end

    context 'when CsvFileNotePopulatedError is raised' do
      before do
        allow(csv_contacts_importer).to receive(:perform).and_raise(CsvContactsImporter::CsvFileNotePopulatedError, 'CSV File Empty')
        allow(CsvContactsImporter).to receive(:new).with(batch.file.path) { csv_contacts_importer }
        subject.perform
      end

      it 'should update the batch record as necessary and call the importer' do
        expect(batch.status).to eq(BatchStatus::FAILED)
        expect(batch.failures).to eq(['CSV File Empty'])
        expect(batch.results).to eq([])
      end
    end

    context 'when CsvHeadersIncorrectError is raised' do
      before do
        allow(csv_contacts_importer).to receive(:perform).and_raise(CsvContactsImporter::CsvHeadersIncorrectError, 'CSV Headers Incorrect')
        allow(CsvContactsImporter).to receive(:new).with(batch.file.path) { csv_contacts_importer }
        subject.perform
      end

      it 'should update the batch record as necessary and call the importer' do
        expect(batch.status).to eq(BatchStatus::FAILED)
        expect(batch.failures).to eq(['CSV Headers Incorrect'])
        expect(batch.results).to eq([])
      end
    end
  end
end
