require File.dirname(__FILE__) + "/version"

require "open-uri"
require "uri"

class GChart
  URL   = "http://chart.apis.google.com/chart"
  TYPES = %w(line linexy bar pie venn scatter).collect { |t| t.to_sym }
  CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-.".split("")
  PAIRS = CHARS.collect { |first| CHARS.collect { |second| first + second } }.flatten

  class << self
    def encode_extended(number) #:nodoc:
      return "__" if number.nil?
      PAIRS[number.to_i]
    end
    
    TYPES.each do |type|
      class_eval <<-END
        def #{type}(options={}, &block)
          new(options.merge(:type => #{type.inspect}, &block))
        end
      END
    end
  end

  # An array of chart data
  attr_accessor :data
  
  # A hash of additional query params
  attr_accessor :extras
  
  # Width (in pixels)
  attr_accessor :width
  
  # Height (in pixels)
  attr_accessor :height
  
  # Orientation. Applies to bar charts
  attr_accessor :horizontal
  
  # Grouping. Applies to bar charts
  attr_accessor :grouped
  
  # Overall chart title
  attr_accessor :title
  
  attr_reader :type
  
  alias_method :horizontal?, :horizontal
  alias_method :grouped?, :grouped
  
  def initialize(options={}, &block)
    @type = :line
    @data = []
    @extras = {}
    @width = 300
    @height = 200
    @horizontal = false
    @grouped = false
    
    options.each { |k, v| send("#{k}=", v) }
    yield(self) if block_given?
  end

  def type=(type)
    unless TYPES.include?(type)
      raise ArgumentError, %Q(Invalid type #{type.inspect}. Valid types: #{TYPES.inspect}.)
    end
    
    @type = type
  end
  
  def size
    "#{width}x#{height}"
  end
  
  def size=(size)
    self.width, self.height = size.split("x").collect { |n| Integer(n) }
  end
  
  def to_url
    query = google_query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
    "#{URL}?#{query}"
  end
  
  def fetch
    open(to_url) { |data| data.read }
  end
  
  def write(io_or_file="chart.png")
    return io_or_file.write(fetch) if io_or_file.respond_to?(:write)
    open(io_or_file, "w+") { |f| f.write(fetch) }
  end
  
  private
  
  def google_query_params
    params = { "cht" => google_chart_type, "chd" => google_data, "chs" => size }
    params["chtt"] = title.tr("\n", "|").gsub(/\s+/, "+") if title
    params.merge(extras)
  end
  
  def google_chart_type
    case type
    when :line
      "lc"
    when :linexy
      "lxy"
    when :bar
      "b" + (horizontal? ? "h" : "v") + (grouped? ? "g" : "s")
    when :pie
      "p"
    when :venn
      "v"
    when :scatter
      "s"
    end
  end
  
  def google_data
    # we'll just always use the extended encoding for now
    sets = (Array === data.first ? data : [data]).collect do |set|
      max = set.max
      set.collect { |n| GChart.encode_extended(n * (PAIRS.size - 1) / max) }.join
    end
    
    "e:#{sets.join(",")}"
  end  
end
