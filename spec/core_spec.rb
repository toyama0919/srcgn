require 'spec_helper'
require 'srcgn'

describe Srcgn::Core do
  before do
    @core = Core.new
  end

  it "core not nil" do
    expect(@core).not_to eq(nil)
  end

  it "private method" do
    @core.send(:sample, []).should == []
  end

  after do
  end
end
