begin
  require 'tk'
  require 'trtl/tk_canvas'
rescue LoadError
  require 'magic_mirror'
  require 'trtl/html5_canvas'
end

module Trtl
  CANVAS_WIDTH = 800
  CANVAS_HEIGHT = 600
  HOME_X = CANVAS_WIDTH / 2
  HOME_Y = CANVAS_HEIGHT / 2
  COLORS = %w{red blue green white cyan pink yellow}
  DEG = Math::PI / 180.0

  def self.new(options = {})
    Trtl.new(options)
  end

  class Trtl
    @@canvas = nil
    @@magic_mirror = nil

    attr_accessor :heading, :x, :y
    attr_writer :color, :width
    attr_reader :canvas

    def initialize(options = {})
      @is_test = options[:is_test]

      # TODO:  Refactor
      if defined? MagicMirror
        if @@magic_mirror.nil?
          @@magic_mirror = MagicMirror.new( sinatra_root: File.expand_path('../..', __FILE__),
                                            init_servers: true)
        end
        MagicMirror.command_cache.reset
      end

      @color = options[:color] || COLORS.sample
      @interactive = options[:interactive]
      @canvas = options[:canvas] || self.class.canvas
      @width = options[:width] || 1
      @drawing = true
      home
      draw
    end


    def self.canvas
      root = Rendering.root(title: 'trtl', minsize: [CANVAS_WIDTH, CANVAS_HEIGHT])

      @@trtl_canvas = Rendering.canvas("trtlCanvas", bg: 'transparent',
        highlightthickness: 0, width: CANVAS_WIDTH, height: CANVAS_HEIGHT) if defined?(MagicMirror)

      @@canvas = Rendering.canvas(root, bg: 'black', highlightthickness: 0, width: CANVAS_WIDTH, height: CANVAS_HEIGHT)
    end

    def title(title)
      Rendering.change_title(title)
    end

    # finds root of gem, for serving assets through the MagicMirror
    def self.root
      File.expand_path '../..', __FILE__
    end

    def pen_up
      @drawing = false
    end

    def pen_down
      @drawing = true
    end

    def is_drawing?
      @drawing
    end

    def color(color)
      @color = color.to_s
    end

    def width(width)
      @width = width
    end

    def forward(amount = 20)
      new_x = (@x + dx * amount)
      new_y = (@y + dy * amount)
      move(new_x, new_y)
    end

    def back(amount = 20)
      new_x = (@x - dx * amount)
      new_y = (@y - dy * amount)
      move(new_x, new_y)
    end

    def move(new_x, new_y)
      Rendering.cLine(@canvas, @x, @y, new_x, new_y, width: @width, fill: @color) if @drawing
      @x, @y = new_x, new_y
      draw
    end

    def right(offset)
      @heading = (@heading + offset) % 360
      draw
    end

    def left(offset)
      @heading = (@heading - offset) % 360
      draw
    end

    def dot(size = nil)
      size ||= [@width + 4, @width * 2].max
      Rendering.cOval(@canvas, @x - size / 2, @y - size / 2, @x + size / 2, @y + size / 2, fill: @color, outline: @color)
    end

    # TODO / TOFIX: This is horribly wrong with the fewer steps due to circumference varying ;-)
    def circle(radius, extent = 360, steps = 360)
      circumference = (Math::PI * 2 * radius) * (extent / 360.0)
      steps.times do
        left extent / steps.to_f
        forward circumference / steps.to_f
      end
    end

    def position
      [@x, @y]
    end

    def home
      @x = HOME_X
      @y = HOME_Y
      @heading = 0
      draw
    end

    def sleep(time = 100000)
      #Tk.sleep(time)
    end

    def ensure_drawn
      sleep 30
      true
    end

    def wait
      ensure_drawn and gets
    end

    alias :run :instance_eval

    # Compatibility aliases (with turtle.py and KidsRuby primarily)
    alias :fd :forward
    alias :bk :back
    alias :rt :right
    alias :lt :left
    alias :pu :pen_up
    alias :pd :pen_down
    alias :penup :pen_up
    alias :pendown :pen_down
    alias :up :pen_up
    alias :down :pen_down
    alias :turnright :right
    alias :turnleft :left
    alias :backward :back
    alias :pencolor :color
    alias :goto :move
    alias :setpos :move
    alias :setposition :move
    alias :pos :position

    private
    def dx
      Math.cos(@heading * DEG)
    end

    def dy
      Math.sin(@heading * DEG)
    end

    def draw
      # note: because we've defined an attr_accessor, we could write @canvas OR canvas
      canvas.delete(@turtle_line) if @turtle_line and !defined?(MagicMirror)

      @turtle_line = Rendering.DrawTrtl(@@trtl_canvas, @x, @y, @x + dx * 5 , @y + dy * 5, arrow: 'last', width: 10, fill: @color)
      # Can probably just use ensure_drawn actually..
      TkTimer.new(60, 1) { Tk.update }.start.wait if @interactive and !defined?(MagicMirror)
      true
    end
  end

  #
  # You can't do include Trtl::InteractiveTurtle in a ruby script...
  # This aspect of ruby is a bit out of my legue =(
  module InteractiveTurtle
    DEG = Math::PI / 180.0

    ::Trtl::Trtl.instance_methods(false).each do |meth|
      define_method meth do |*args, &p|
        (@turtle ||= ::Trtl.new(interactive: true)).send(meth, *args, &p)
      end
    end
  end
end


include Trtl::InteractiveTurtle if %w{irb pry}.include?($0)
