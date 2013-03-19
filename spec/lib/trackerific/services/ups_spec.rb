require 'spec_helper'
require 'fakeweb'
require 'pry'
UPS_TRACK_URL = 'https://wwwcie.ups.com/ups.app/xml/Track'

describe "Trackerific::UPS" do
  include Fixtures
  
  specify("it should descend from Trackerific::Service") {
    Trackerific::UPS.superclass.should be Trackerific::Service
  }
  
  describe :required_parameters do
    subject { Trackerific::UPS.required_parameters }
    it { should include(:key) }
    it { should include(:user_id) }
    it { should include(:password) }
  end
  
  describe :valid_options do
    it "should include required_parameters" do
      valid = Trackerific::UPS.valid_options
      Trackerific::UPS.required_parameters.each do |opt|
        valid.should include opt
      end
    end
  end
  
  describe :package_id_matchers do
    subject { Trackerific::UPS.package_id_matchers }
    it("should be an Array of Regexp") { should each { |m| m.should be_a Regexp } }
  end
  
  describe :track_package do
    before(:all) do
      @package_id = '1Z12345E0291980793'
      @ups = Trackerific::UPS.new :key => 'testkey', :user_id => 'testuser', :password => 'secret'
    end
    
    context "with a successful response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:post, UPS_TRACK_URL, :body => load_fixture(:ups_success_response))
      end
      
      before(:each) do
        @tracking = @ups.track_package(@package_id)
      end
      
      subject { @tracking }
      it("should return a Trackerific::Details") { should be_a Trackerific::Details }

      describe "origin" do
        subject { @tracking.origin }
        it("should be a location object") { should be_a Trackerific::Location }
      end
      
      describe "destination" do
        subject { @tracking.destination }
        it("should be a location object") { should be_a Trackerific::Location }
      end
      
      describe "events.length" do
        subject { @tracking.events.length }
        it { should >= 1 }
      end
      
      describe :summary do
        subject { @tracking.summary }
        it { should_not be_empty }
      end
      
    end
    
    context "with an error response from the server" do
      
      before(:all) do
        FakeWeb.register_uri(:post, UPS_TRACK_URL, :body => load_fixture(:ups_error_response))
      end
      
      specify { lambda { @ups.track_package("invalid package id") }.should raise_error(Trackerific::Error) }
      
    end
    
    pending "when server returns corrupted xml"
    
  end
  
end
