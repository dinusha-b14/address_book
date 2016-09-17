require 'rails_helper'

describe ContactDecorator, type: :decorator do
  subject { described_class.new(contact) }

  before { subject.decorate }

  describe '#full_name' do
    let(:contact) do
      create(:contact, first_name: 'Michael', last_name: 'Thomas')
    end

    it 'should display the name withe last name first' do
      expect(subject.full_name).to eq('Thomas, Michael')
    end
  end
end
