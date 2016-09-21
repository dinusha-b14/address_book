require 'rails_helper'

describe BatchDecorator, type: :decorator do
  subject { described_class.new(batch) }

  let(:batch) do
    build_stubbed(:batch, status: status)
  end

  before { subject.decorate }

  describe '#iconified_status' do
    context 'when status is PROCESSING' do
      let(:status) { BatchStatus::PROCESSING }

      it 'should render the processing partial' do
        expect(subject.iconified_status).to eq(
          "<i class='fa fa-refresh fa-spin fa-5x fa-fw pull-left text-warning'></i>\n"\
          "<h2 class='margin-top-10px'>Processing</h2>\n"
        )
      end
    end

    context 'when status is COMPLETE' do
      let(:status) { BatchStatus::COMPLETE }

      it 'should render the complete partial' do
        expect(subject.iconified_status).to eq(
          "<i class='fa fa-check-circle fa-5x pull-left text-success'></i>\n"\
          "<h2 class='margin-top-10px'>Complete</h2>\n"
        )
      end
    end

    context 'when status is COMPLETE_WITH_ERRORS' do
      let(:status) { BatchStatus::COMPLETE_WITH_ERRORS }

      it 'should render the complete with errors partial' do
        expect(subject.iconified_status).to eq(
          "<i class='fa fa-exclamation-circle fa-5x pull-left text-warning'></i>\n"\
          "<h2 class='margin-top-10px'>Processing completed however errors were found</h2>\n"
        )
      end
    end

    context 'when status is FAILED' do
      let(:status) { BatchStatus::FAILED }

      it 'should render the failed partial' do
        expect(subject.iconified_status).to eq(
          "<i class='fa fa-times-circle fa-5x pull-left text-danger'></i>\n"\
          "<h2 class='margin-top-10px'>Failure</h2>\n"
        )
      end
    end

    context 'when status is CREATED' do
      let(:status) { BatchStatus::CREATED }

      it 'should render the created partial' do
        expect(subject.iconified_status).to eq(
          "<i class='fa fa-info-circle fa-5x pull-left text-info'></i>\n"\
          "<h2 class='margin-top-10px'>Created</h2>\n"
        )
      end
    end
  end
end
