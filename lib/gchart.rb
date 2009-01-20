require File.expand_path(File.dirname(__FILE__) + "/version")
require File.expand_path(File.dirname(__FILE__) + "/gchart/colors")
require File.expand_path(File.dirname(__FILE__) + "/gchart/axis")

%w(base bar line map meter pie pie_3d scatter sparkline venn xy_line).each do |type|
  require File.expand_path(File.dirname(__FILE__) + "/gchart/#{type}")
end

%w(horizontal vertical top right bottom left).each do |type|
  require File.expand_path(File.dirname(__FILE__) + "/gchart/axis/#{type}_axis")
end

module GChart
  URL   = "http://chart.apis.google.com/chart"
  SIMPLE_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  EXTENDED_CHARS = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a + %w[- .]
  EXTENDED_PAIRS = EXTENDED_CHARS.collect { |first| EXTENDED_CHARS.collect { |second| first + second } }.flatten

  class << self
    # Convenience constructor for GChart::Line.
    def line(*args, &block); Line.new(*args, &block) end
    
    # Convenience constructor for GChart::XYLine.
    def xyline(*args, &block); XYLine.new(*args, &block) end
    
    # Convenience constructor for GChart::Bar.
    def bar(*args, &block); Bar.new(*args, &block) end    
    
    # Convenience constructor for GChart::Map.
    def map(*args, &block); Map.new(*args, &block) end    

    # Convenience constructor for GChart::Meter.
    def meter(*args, &block); Meter.new(*args, &block) end    

    # Convenience constructor for GChart::Pie.
    def pie(*args, &block); Pie.new(*args, &block) end    
    
    # Convenience constructor for GChart::Pie3D.
    def pie3d(*args, &block); Pie3D.new(*args, &block) end    
    
    # Convenience constructor for GChart::Scatter.
    def scatter(*args, &block); Scatter.new(*args, &block) end
    
    # Convenience constructor for GChart::Sparkline.
    def sparkline(*args, &block); Sparkline.new(*args, &block) end

    # Convenience constructor for GChart::Venn.
    def venn(*args, &block); Venn.new(*args, &block) end    

    def encoding=(new_encoding)
      @encoding = new_encoding if [:text, :simple, :extended].include? new_encoding
    end

    def encode_datasets(sets, force_max=nil)
      max = force_max || sets.collect { |s| s.max }.max

      join_character = @encoding == :text ? ',' : ''

      output = sets.collect do |set|
        set.collect { |n| GChart.encode(@encoding || :extended, n, max) }.join(join_character)
      end

      if @encoding == :text
        "t:#{output.join('|')}"
      else
        "e:#{output.join(',')}"
      end
    end

    # Encode +n+ as a string. +n+ is normalized based on +max+.
    # +encoding+ can currently only be :extended.
    def encode(encoding, n, max)
      encoding = @encoding if @encoding

      case encoding
      when :simple
        return "_" if n.nil?
        SIMPLE_CHARS[((n/max.to_f) * (SIMPLE_CHARS.size - 1)).round]
      when :text
        return "-1" if n.nil?
        n.to_f.to_s
      when :extended
        return "__" if n.nil?
        EXTENDED_PAIRS[max.zero? ? 0 : ((n/max.to_f) * (EXTENDED_PAIRS.size - 1)).round]
      else
        raise ArgumentError, "unsupported encoding: #{encoding.inspect}"
      end
    end
  end
end
