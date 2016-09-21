require 'rails_helper'

describe Batch::BatchContactsImporter, type: :service do
  subject { described_class.new(batch) }

  describe '#perform' do
    let(:batch) { create(:batch) }
    let(:csv_contacts_importer) { instance_double('CsvContactsImporter') }

    let(:csv_contact_one) do
      instance_double(
        'CsvContactsImporter::CsvContact',
        result: ::ContactImportStatus::SUCCESS,
        contact_id: 3,
        failure_hash: {
          id: 3,
          csv_data: { first_name: 'Michael', last_name: 'Thomas', email: 'test78263476234@test.com.au' },
          errors: [],
          result: ::ContactImportStatus::SUCCESS
        }
      )
    end

    let(:csv_contact_two) do
      instance_double(
        'CsvContactsImporter::CsvContact',
        result: ::ContactImportStatus::DUPLICATE_FOUND,
        contact_id: 5,
        failure_hash: {
          id: 5,
          csv_data: { first_name: 'Mark', last_name: 'Thompson', email: 'test273678123@test.com.au' },
          errors: [],
          result: ::ContactImportStatus::DUPLICATE_FOUND
        }
      )
    end

    let(:csv_contact_three) do
      instance_double(
        'CsvContactsImporter::CsvContact',
        result: ::ContactImportStatus::ERROR,
        contact_id: nil,
        failure_hash: {
          id: nil,
          csv_data: { first_name: '', last_name: 'Thompson', email: 'test273678123@test.com.au' },
          errors: ['First name can\'t be blank'],
          result: ::ContactImportStatus::ERROR
        }
      )
    end

    context 'when no errors are raised by CsvContactsImporter' do
      before do
        allow(csv_contacts_importer).to receive(:perform).and_yield(csv_contact_one).and_yield(csv_contact_two).and_yield(csv_contact_three)
        allow(CsvContactsImporter).to receive(:new).with(batch.file.path) { csv_contacts_importer }
        subject.perform
      end

      it 'should update the batch record as necessary and call the importer' do
        expect(batch.status).to eq(BatchStatus::COMPLETE_WITH_ERRORS)
        expect(batch.batch_failures).to match_array(
          [
            {
              'id' => 5,
              'csv_data' => { 'first_name' => 'Mark', 'last_name' => 'Thompson', 'email' => 'test273678123@test.com.au' },
              'errors' => [],
              'result' => ::ContactImportStatus::DUPLICATE_FOUND
            },
            {
              'id' => nil,
              'csv_data' => { 'first_name' => '', 'last_name' => 'Thompson', 'email' => 'test273678123@test.com.au' },
              'errors' => ['First name can\'t be blank'],
              'result' => ::ContactImportStatus::ERROR
            }
          ]
        )
        expect(batch.success_ids).to match_array([3])
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
        expect(batch.general_failures).to eq(['CSV File Empty'])
        expect(batch.batch_failures).to eq([])
        expect(batch.success_ids).to eq([])
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
        expect(batch.general_failures).to eq(['CSV Headers Incorrect'])
        expect(batch.batch_failures).to eq([])
        expect(batch.success_ids).to eq([])
      end
    end
  end
end
