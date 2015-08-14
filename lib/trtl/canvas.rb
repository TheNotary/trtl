module Trtl

  def init

  end

  def root

  end

  # This *would* represent the DOM, but instead it will represent a cleared
  # MagicMirror.command_cache and a setTitle command for the window
  # returns the ID of that canvas
  class RenderingRoot
    # :title => 'trtl', :minsize => [CANVAS_WIDTH, CANVAS_HEIGHT]
    def initialize(options)
      MagicMirror.command_cache.clear
      MagicMirror.command_cache << "MagicMirror.setTitle('#{options[:title]}');"
      TkRoot.new(options) unless options[:is_test]
    end

    def to_s
      "myCanvas"
    end

  end

  # This represents our HTML5 canvas element
  # returns "myCanvas"
  class RenderingCanvas
    # root, bg: 'black', highlightthickness: 0, width: CANVAS_WIDTH, height: CANVAS_HEIGHT, is_test: is_test
    def initialize(root, options)
      @root = root

      class_name = self.class.name.sub(/(^.*::)/, "")
      args = method(__method__).parameters.map do |arg|
        v = eval("#{arg[1]}");
        v.to_json.gsub("\"", "'")
      end[0...-1].join(",")
      options_hash = options.to_json.gsub("\"", "'")
      cmd = "#{class_name}.new(#{args}, #{options_hash});"
      MagicMirror.command_cache << cmd

      @_canvas = TkCanvas.new(root, options) unless options[:is_test]
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

  class RenderingcLine
    attr_accessor :x1, :y1, :x2, :y2, :width

    # options:  @x, @y, @x + dx * 5 , @y + dy * 5, :arrow => 'last', :width => 10, :fill => @color
    def initialize(canvas, x1, y1, x2, y2, options)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
      @width = options[:width]

      class_name = self.class.name.sub(/(^.*::)/, "")
      args = method(__method__).parameters.map do |arg|
        v = eval("#{arg[1]}");
        v.to_json.gsub("\"", "'")
      end[0...-1].join(",")
      options_hash = options.to_json.gsub("\"", "'")
      cmd = "#{class_name}.new(#{args}, #{options_hash});"
      MagicMirror.command_cache << cmd

      TkcLine.new(canvas, x1, y1, x2, y2, options) unless options[:is_test]
    end
  end

  class RenderingcOval
    def initialize(canvas, x1, y1, x2, y2, options)
      class_name = self.class.name.sub(/(^.*::)/, "")
      args = method(__method__).parameters.map do |arg|
        v = eval("#{arg[1]}");
        v.to_json.gsub("\"", "'")
      end[0...-1].join(",")
      options_hash = options.to_json.gsub("\"", "'")
      cmd = "#{class_name}.new(#{args}, #{options_hash});"
      MagicMirror.command_cache << cmd

      TkcOval.new(canvas, x1, y1, x2, y2, options) unless options[:is_test]
    end
  end

  class RenderingDrawTrtl
    def initialize(canvas, x1, y1, x2, y2, options)
      class_name = self.class.name.sub(/(^.*::)/, "")
      args = method(__method__).parameters.map do |arg|
        v = eval("#{arg[1]}");
        v.to_json.gsub("\"", "'")
      end[0...-1].join(",")
      options_hash = options.to_json.gsub("\"", "'")
      cmd = "#{class_name}.new(#{args}, #{options_hash});"
      MagicMirror.command_cache << cmd

      # Old way
      # canvas.delete(@turtle_line) if @turtle_line
      # @turtle_line = RenderingcLine.new(canvas, x1, y1, x2, y2, options)
    end
  end

end
