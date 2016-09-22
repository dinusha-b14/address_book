require 'rails_helper'

describe BatchFailureDecorator, type: :decorator do
  subject { described_class.new(batch_failure) }
end
