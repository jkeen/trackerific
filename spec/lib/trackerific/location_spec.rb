require 'spec_helper'

describe Trackerific::Location do
  
  before { @location = Trackerific::Location.new(:city => "Austin", :state => "TX", :postal_code => "78745") }
  subject { @location.to_s }
  specify { should == "Austin TX 78745" }
  
end
