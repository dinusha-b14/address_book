require 'rails_helper'

describe ContactsImporter, type: :service do
  subject { described_class.new(file_path) }

  describe '#perform' do
    context 'when batch file is valid' do
      let(:file_path) { File.join(Rails.root, 'spec', 'fixtures', 'valid_test.csv') }

      context 'when contacts do not already exist' do
        it 'should increase the number of contacts' do
          expect { subject.perform }.to change(Contact, :count).by(3)
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
          expect { subject.perform }.to change(Contact, :count).by(2)
        end

        context 'data for existing contact must remain the same' do
          before do
            subject.perform
            existing_contact.reload
          end

          it 'should retain the data for the existing contact' do
            expect(existing_contact.first_name).to eq('Jane')
            expect(existing_contact.last_name).to eq('Millers')
            expect(existing_contact.email).to eq('test237866871237@test.com.au')
          end
        end
      end
    end
  end
end
