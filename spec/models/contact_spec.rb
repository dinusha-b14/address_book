require 'rails_helper'

describe Contact, type: :model do
  describe '.last_name_alphabetical' do
    let!(:contact_one) do
      create(:contact, first_name: 'Michael', last_name: 'Thompson')
    end

    let!(:contact_two) do
      create(:contact, first_name: 'Jane', last_name: 'Levinson')
    end
    it 'should return the contacts with their last name in alphabetical order' do
      expect(described_class.last_name_alphabetical.to_a).to eq([contact_two, contact_one])
    end
  end
end
