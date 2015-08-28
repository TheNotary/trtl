module Trtl

  class Rendering

    class << self

      def root(options)
        TkRoot.new(options)
      end

      def change_title(title)
        TkRoot.new(title: title)
      end

      def canvas(root, options)
        @canvas = TkCanvas.new(root, options) unless options[:is_test]
        @canvas.pack(fill: 'both', expand: 1)
        @canvas
      end

      def cLine(canvas, x1, y1, x2, y2, options)
        TkcLine.new(canvas, x1, y1, x2, y2, options)
      end

      def cOval(canvas, x1, y1, x2, y2, options)
        TkcOval.new(canvas, x1, y1, x2, y2, options)
      end

      def DrawTrtl(canvas, x1, y1, x2, y2, options)
        @turtle_line = TkcLine.new(canvas, @x, @y, @x + dx * 5 , @y + dy * 5, :arrow => 'last', :width => 10, :fill => @color)

    
      end

    end

  end

end
