require 'rails_helper'

describe S3Downloader, type: :service do
  subject { described_class.new(remote_file, destination_path) }

  let(:remote_file) { instance_double('CsvUploader') }
  let(:destination_path) { File.join(Rails.root, 'tmp', 'my_file_name.csv') }

  before do
    allow(remote_file).to receive(:read) { 'some chunk' }
  end

  after do
    File.delete(destination_path)
  end

  describe '#download' do
    it 'should not return nil' do
      expect(subject.download).to_not be_falsey
    end

    context 'file_content' do
      before { subject.download }

      it 'should write the text from remote file to the created file' do
        expect(File.read(destination_path)).to eq('some chunk')
      end
    end
  end
end
