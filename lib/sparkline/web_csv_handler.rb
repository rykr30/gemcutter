require 'rack-sparklines/handlers/abstract_data'

# Reads sparkline data from a URL.  Expect CSV data like "1,2,3".  Requests 
# for "/sparks/stats.csv" will pass a data_path of "stats.csv"
class Sparkline::WebCsvHandler < Rack::Sparklines::Handlers::AbstractData
  attr_accessor :root

  def initialize(root)
    @root = root
    @exists, @updated_at, @data = nil
  end

  def data_path=(s)
    @data_path = s ? "#{@root}/#{s}" : nil
  end

  def exists?
    @exists.nil? ? process(:@exists) : @exists
  end

  def updated_at
    @updated_at.nil? ? process(:@updated_at) : @updated_at
  end

  def data
    @data.nil? ? process(:@data) : @data
  end

  def fetch
    yield data
  end

private
  def process(ivar)
    uri  = URI.parse(@data_path)
    http = Net::HTTP.new(uri.host, uri.port)
    resp = http.get(uri.path)
    @exists     = resp.code =~ /^2/
    @updated_at = Time.parse(resp['date'])
    @data       = resp.body.split(",").map! { |n| n.to_i }
    instance_variable_get(ivar)
  rescue EOFError, Timeout::Error
    @exists     = false
    @updated_at = Time.now.utc
    @data       = [0]
    instance_variable_get(ivar)
  end
end