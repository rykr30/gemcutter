require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Gemcutter API" do
  describe "on POST to /gems" do
    it "should accept a built gem" do
      post '/gems', :gem => Rack::Test::UploadedFile.new(File.join(File.dirname(__FILE__), *%w[gems test-0.0.0.gem]), 'application/rubygem', :binary)
      @response.status.should == 200
    end
  end

  it "should work" do
    get '/'
    @response.should =~ /gemcutter/
  end
end