require 'cgi'

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
  URL_MAXIMUM_LENGTH = 2074 # Google does not document this -- obtained by trial and error

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
        ((((n/max.to_f) * 1000.0).round)/10.0).to_s
      when :extended
        return "__" if n.nil?
        EXTENDED_PAIRS[max.zero? ? 0 : ((n/max.to_f) * (EXTENDED_PAIRS.size - 1)).round]
      else
        raise ArgumentError, "unsupported encoding: #{encoding.inspect}"
      end
    end
    
    # Decode +encoded_data_groups+ automatically based on the prepended
    # encoding identifier.
    def decode(encoded_data_string)
      encoding = encoded_data_string.first[0..0]
      encoded_data_groups = encoded_data_string.first[2..-1]
      
      encoded_data_groups.split(',').collect do |encoded_data|
        case encoding
        when 'e'
          values = []
          (encoded_data.size / 2).times do |index|
            chars = encoded_data[(index * 2)..(index * 2 + 1)]
            if chars == '__'
              values << nil
            else
              values << EXTENDED_PAIRS.index(chars)
            end
          end
          values
        when 's'
          encoded_data.split(//).collect do |char|
            if char == '_'
              nil
            else
              SIMPLE_CHARS.index(char)
            end
          end
        when 't'
          encoded_data
        else
          raise ArgumentError, "unsupported encoding: #{encoding.inspect}"
        end
      end
    end
    
    # Turn a Google Chart API url into the chart representing it. +extras+
    # places any unparsable query parameters into the :extras option of a
    # chart.
    def parse(url, extras = true)
      url = url.strip
      raise "Unparsable" unless url.index(URL) == 0
      
      params = CGI.parse(url[(URL.size + 1)..-1])
      data = decode(params.delete('chd'))
        
      chart_type = params.delete('cht').first
      type = GChart.charts.detect do |chart|
        chart.new.send(:render_chart_type) == chart_type
      end

      options = { 
        :data => data,
        :size => params.delete('chs').first
      }
      options[:label] = params.delete('chl').first if params['chl'].first
      options[:title] = params.delete('chtt').first if params['chtt'].first
      options[:legend] = params.delete('chdl').first.split('|') if params['chdl'].first
      options[:colors] = params.delete('chco').first.split('|') if params['chco'].first
      if params['chxt'].first
        axises = params.delete('chxt').first
        current_axis = nil
        chxl = {}
        params.delete('chxl').first.split('|').each do |value|
          if match = value.scan(/^(\d):$/).first
            current_axis = match.first.to_i
            chxl[current_axis] = []
          else
            chxl[current_axis] << value
          end
        end
        index = 0
        axises.split(',').each do |axis|
          axis_name = Base::AXIS_NAMES.keys.detect { |n| Base::AXIS_NAMES[n] == axis }
          options[axis_name] = chxl[index] || true
          index += 1
        end
      end
      
      if extras
        options[:extras] = params.keys.inject({}) do |memo, key|
          memo[key] = params[key].first
          memo
        end
      end
      
      type.new(options)
    end
  end
end
