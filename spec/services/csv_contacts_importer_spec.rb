require 'rails_helper'

describe CsvContactsImporter, type: :service do
  subject { described_class.new(file_path) }

  describe '#perform' do
    context 'when batch file is valid' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv') }

      context 'when contacts do not already exist' do
        it 'should increase the number of contacts' do
          expect { subject.perform {} }.to change(Contact, :count).by(3)
        end
      end

      context 'when some contacts already exist' do
        let!(:existing_contact) do
          create(
            :contact,
            first_name: 'Jane',
            last_name: 'Millers',
            email: 'test237866871237@test.com.au'
          )
        end

        it 'should only increase by the number of new contacts' do
          expect { subject.perform {} }.to change(Contact, :count).by(2)
        end

        context 'data for existing contact must remain the same' do
          before do
            subject.perform {}
            existing_contact.reload
          end

          it 'should retain the data for the existing contact' do
            expect(existing_contact.first_name).to eq('Jane')
            expect(existing_contact.last_name).to eq('Millers')
            expect(existing_contact.email).to eq('test237866871237@test.com.au')
          end
        end
      end

      describe 'data yielded' do
        let(:csv_contact) { instance_double('CsvContactsImporter::CsvContact', save: true) }

        before do
          allow(CsvContactsImporter::CsvContact).to receive(:new) { csv_contact }
        end

        it 'should yield back with contact data and a result' do
          expect { |b| subject.perform(&b) }.to yield_successive_args(csv_contact, csv_contact, csv_contact)
        end
      end
    end

    context 'when batch file is invalid' do
      context 'when headers are invalid' do
        let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'headers_invalid_test.csv') }

        it 'should raise a CsvHeadersIncorrectError' do
          expect { subject.perform }.to raise_error(CsvContactsImporter::CsvHeadersIncorrectError, 'CSV Headers Incorrect')
        end
      end

      context 'when no headers exist' do
        let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'no_headers_test.csv') }

        it 'should raise a CsvHeadersIncorrectError' do
          expect { subject.perform }.to raise_error(CsvContactsImporter::CsvHeadersIncorrectError, 'CSV Headers Incorrect')
        end
      end

      context 'when there is no content' do
        let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'no_content_test.csv') }

        it 'should raise a CsvFileNotePopulatedError' do
          expect { subject.perform }.to raise_error(CsvContactsImporter::CsvFileNotePopulatedError, 'CSV File Empty')
        end
      end
    end
  end
end

describe CsvContactsImporter::CsvContact do
  subject { described_class.new(csv_row) }

  let(:csv_row) do
    {
      first_name: 'Michael',
      last_name: 'Thomas',
      email: 'michael.thomas@test238749823.com.au   '
    }
  end

  describe '#save' do
    context 'when record does not exist' do
      it 'should increase the number of contacts' do
        expect { subject.save }.to change(Contact, :count).by(1)
        expect(subject.result).to eq(ContactImportStatus::SUCCESS)
        expect(subject.errors).to be_empty
      end
    end

    context 'when record already exists' do
      let!(:existing_contact) do
        create(:contact, first_name: 'Michael', last_name: 'Thomas', email: 'michael.thomas@test238749823.com.au')
      end

      it 'should not increase the number of contacts' do
        expect { subject.save }.to change(Contact, :count).by(0)
        expect(subject.result).to eq(ContactImportStatus::DUPLICATE_FOUND)
        expect(subject.errors).to be_empty
      end
    end

    context 'when record has errors' do
      let(:csv_row) do
        {
          first_name: 'Michael',
          last_name: '',
          email: 'michael.thomas@test238749823.com.au   '
        }
      end

      it 'should not increase the number of contacts' do
        expect { subject.save }.to change(Contact, :count).by(0)
        expect(subject.result).to eq(ContactImportStatus::ERROR)
        expect(subject.errors).to eq(['Last name can\'t be blank'])
      end
    end
  end

  describe '#failure_hash' do
    it 'should contain the correct keys' do
      expect(subject.failure_hash.keys).to match_array([:klass_id, :csv_data, :klass_errors, :result])
    end
  end
end
