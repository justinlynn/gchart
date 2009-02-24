module GChart
  class Bar < GChart::Base
    ORIENTATIONS = [:horizontal, :vertical]
    
    attr_accessor :grouped
    alias_method :grouped?, :grouped
    
    attr_reader :orientation
    
    attr_reader :thickness
    attr_reader :spacing
    
    def initialize(*args, &block)
      @grouped = false
      @orientation = :horizontal
      super
    end
    
    def orientation=(orientation)
      unless ORIENTATIONS.include?(orientation)
        raise ArgumentError, "Invalid orientation: #{orientation.inspect}. " +
          "Valid orientations: #{ORIENTATIONS.inspect}"
      end
      
      @orientation = orientation
    end
    
    def horizontal?
      @orientation == :horizontal
    end

    def vertical?
      @orientation == :vertical
    end
    
    # sets the thickness of the bars, can be either :automatic or a number of pixels
    # Google's default is 23 pixels
    def thickness=(thickness)
      if thickness.nil? || (thickness != :automatic && thickness < 1)
        raise ArgumentError, "Invalid thickness: #{thickness.inspect}"
      end
      @thickness = thickness
    end
    
    def spacing=(spacing)
      raise ArgumentError, "Invalid spacing: #{spacing.inspect}" if spacing.nil? || spacing < 1
      @spacing = spacing
    end

    # overrides GChart::Base#query_params
    def query_params(params={}) #:nodoc:
      values = []
      if thickness == :automatic
        values << "a"
      elsif thickness
        values << thickness
        values << spacing if spacing
      end
      
      params["chbh"] = values.join(",") unless values.empty?
      super(params)
    end
  
    def render_chart_type #:nodoc:
      "b#{@orientation.to_s[0..0]}#{grouped? ? "g" : "s"}"
    end
  end
end
