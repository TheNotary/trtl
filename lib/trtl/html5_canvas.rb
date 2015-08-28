module Trtl


  # Below is the straight forward approach to this algo... it's a bit slow
  # doing it the DRY way
  #
  # class_name = self.class.name.sub(/(^.*::)/, "")
  # argsz = method(__method__).parameters.map do |arg|
  #   v = eval("#{arg[1]}")
  #   v.to_json.gsub("\"", "'")
  # end[0...-1].join(",")
  # options_hash = options.to_json.gsub("\"", "'")
  # cmd = "#{class_name}.new(#{argsz}, #{options_hash});"
  module Reflectable
    def class_name
      # self.class.name.sub(/(^.*::)/, "")
      self.class.name.sub("Trtl::", "")
    end

    def meta_args(m)
      args = method(m).parameters.map do |arg|
        v = instance_variable_get("@#{arg[1]}");
        v.to_json.tr("\"", "'")
      end[0...-1].join(",")

      args
    end

    def meta_merrily_lookup_cmd(m)
      cmd = "#{class_name}.new(#{meta_args(m)}, #{options_hash});"
    end

    def options_hash
      @options.to_json.tr("\"", "'")
    end

  end

  class Rendering

    class << self

      # This *would* represent the DOM, but instead it will represent a cleared
      # MagicMirror.command_cache and a setTitle command for the window
      # returns the ID of that canvas
      def root(options)
        MagicMirror.command_cache.reset
        MagicMirror.command_cache << "MagicMirror.setTitle('#{options[:title]}');"
        "myCanvas"

        # TkRoot.new(options)
      end

      def change_title(title)
        MagicMirror.command_cache << "MagicMirror.setTitle('#{title}');"

        # TkRoot.new(title: title)
      end

      def canvas(root, options)
        RenderingCanvas.new(root, options)

        # @@canvas = TkCanvas.new(root, options) unless options[:is_test]
        # @@canvas.pack(fill: 'both', expand: 1)
      end

      def cLine(canvas, x1, y1, x2, y2, options)
        # RenderingcLine.new(canvas, x1, y1, x2, y2, options)
        MagicMirror.command_cache << "cLine('#{canvas}',#{x1},#{y1},#{x2},#{y2},#{options.to_json.tr("\"", "'")});"
      end

      def cOval(canvas, x1, y1, x2, y2, options)
        RenderingcOval.new(canvas, x1, y1, x2, y2, options)
      end

      def DrawTrtl(canvas, x1, y1, x2, y2, options)
        RenderingDrawTrtl.new(canvas, x1, y1, x2, y2, options)
      end

    end

  end


  # This represents our HTML5 canvas element
  # returns "myCanvas"
  class RenderingCanvas
    include Reflectable

    def initialize(root, options)
      @root = root
      @options = options

      cmd = meta_merrily_lookup_cmd(__method__)

      MagicMirror.command_cache << cmd
    end


    def pack(options)
      "???"
    end

    def delete(line)
      "???"
    end

    def to_s
      @root
    end

    def to_json
      @root.to_json
    end

  end

  class RenderingcOval
    include Reflectable
    # point1: upper left corner
    # point2: lower right corner
    def initialize(canvas, x1, y1, x2, y2, options)
      @canvas = canvas
      @options = options
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2

      cmd = meta_merrily_lookup_cmd(__method__)
      MagicMirror.command_cache << cmd
    end
  end

  class RenderingDrawTrtl
    include Reflectable
    def initialize(canvas, x1, y1, x2, y2, options)
      @canvas = canvas
      @options = options
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2

      cmd = meta_merrily_lookup_cmd(__method__)
      MagicMirror.command_cache << cmd
    end
  end

  # this class has been optimized away from
  class RenderingcLine
    include Reflectable
    attr_accessor :x1, :y1, :x2, :y2, :width

    # REMOVED in favor of optimizations
    # options:  @x, @y, @x + dx * 5 , @y + dy * 5, :arrow => 'last', :width => 10, :fill => @color
    def initialize(canvas, x1, y1, x2, y2, options)
      cmd = "RenderingcLine.new('#{canvas}',#{x1},#{y1},#{x2},#{y2},#{options.to_json.tr("\"", "'")});"
      MagicMirror.command_cache << cmd
    end
  end




end
