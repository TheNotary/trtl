module Canvas

  def init

  end

  def root

  end

  class RenderingRoot
    # :title => 'trtl', :minsize => [CANVAS_WIDTH, CANVAS_HEIGHT]
    def initialize(options)
      TkRoot.new(options) unless options[:is_test]
    end

  end

  class RenderingCanvas
    def initialize(root, options)
      @_canvas = TkCanvas.new(root, options) unless options[:is_test]
    end

    def pack(options)
      "???"
    end

    def delete(line)
      "???"
    end

  end

  class RenderingcLine
    # options:  @x, @y, @x + dx * 5 , @y + dy * 5, :arrow => 'last', :width => 10, :fill => @color
    def initialize(canvas, x1, y1, x2, y2, options)
      TkcLine.new(canvas, x1, y1, x2, y2, options) unless options[:is_test]
    end
  end

  class RenderingcOval
    def initialize(canvas, x1, y1, x2, y2, options)
      TkcOval.new(canvas, x1, y1, x2, y2, options) unless options[:is_test]
    end
  end

end
