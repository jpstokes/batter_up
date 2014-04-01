require 'spec_helper'
require_relative '../models/statistic.rb'

describe Statistic do
  let(:statistic) { FactoryGirl.build(:statistic) }

  describe '#new' do
    it { expect(statistic).to be_a_kind_of Statistic }
  end
end
