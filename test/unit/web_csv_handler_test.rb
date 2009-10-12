require File.dirname(__FILE__) + '/../test_helper'

class WebCsvHandlerTest < ActiveSupport::TestCase
  context "valid request" do
    setup do
      @http, @resp = stub_net_http
      stub(@http).get("/stats") { @resp }
      stub(Net::HTTP).new       { @http }
      @handler = Sparkline::WebCsvHandler.new("http://foo.com")
      @handler.data_path = "stats"
    end

    should "check response code for #exists?" do
      assert @handler.exists?
    end

    should "parse the Last-Modified header for #updated_at" do
      assert_equal Time.utc(2009, 10, 12, 5, 34, 37), @handler.updated_at
    end

    should "parse the body for #data" do
      assert_equal [0, 1], @handler.data
    end
  end

  context "invalid request" do
    setup do
      @http, @resp = stub_net_http
      @resp.code = '300'
      stub(@http).get("/stats") { @resp }
      stub(Net::HTTP).new       { @http }
      @handler = Sparkline::WebCsvHandler.new("http://foo.com")
      @handler.data_path = "stats"
    end
  
    should "check response code for #exists?" do
      assert !@handler.exists?
    end
  
    should "parse the Last-Modified header for #updated_at" do
      assert_equal Time.utc(2009, 10, 12, 5, 34, 37), @handler.updated_at
    end
  
    should "parse the body for #data" do
      assert_equal [0, 1], @handler.data
    end
  end

  context "erroring request" do
    setup do
      @http, @resp = stub_net_http
      stub(@http).get("/stats") { timeout(0.1) { sleep 5 } }
      stub(Net::HTTP).new       { @http }
      @handler = Sparkline::WebCsvHandler.new("http://foo.com")
      @handler.data_path = "stats"
    end
  
    should "not exist" do
      assert !@handler.exists?
    end
  
    should "fill in an updated_at timestamp" do
      assert_not_nil @handler.updated_at
    end
  
    should "return empty data" do
      assert_equal [0], @handler.data
    end
  end

  def stub_net_http
    http = Object.new
    resp = Object.new
    class << resp
      attr_accessor :host, :port, :code, :body, :headers
      def [](key) @headers[key] end
    end
    resp.code    = '200'
    resp.headers = {'date' => "Mon, 12 Oct 2009 05:34:37 GMT"}
    resp.body    = "0,1"
    [http, resp]
  end
end
