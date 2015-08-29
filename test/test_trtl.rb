require_relative 'helper'

# Note: Only very simple high level tests here. Just stretching
#       some of the public API. One day I may care to stub out Tk ;-)

describe Trtl do
  before do
    @trtl = Trtl.new(is_test: true)
  end

  it "will bind" do
    # MagicMirror.sinatra_root = File.expand_path('../..', __FILE__)
    # m = MagicMirror.new
    # m.init_servers

    # ok, now test you can mutate the command cache...
    # binding.pry
    # @trtl = Trtl.new(is_test: true)

  end

  it "does easy example" do
    skip "this test is for visually inspecting outputs"

    t = Trtl.new

    10.times do
      t.left(24)
      t.forward(30)
      t.dot
      t.ensure_drawn
    end

    gets
  end

  it "draws the tree" do
    # skip "this test is for visually inspecting outputs"

    puts "\nctrl + D to begin drawing tree (refresh browser if you don't see a plain turtle)"
    binding.pry

    beginning = Time.now

    Trtl.new(:width => 2, :color => 'brown').run do
      def tree(_size)
        if _size < 10
          forward _size; back _size; return
        end
        color 'brown'
        forward _size / 3
        color %w{green darkgreen darkolivegreen}.sample
        left 30; tree _size * 2 / 3; right 30
        forward _size / 6
        right 25; tree _size / 2; left 25
        forward _size / 3
        width rand(2) + 1
        right 25; tree _size / 2; left 25
        forward _size / 6
        back _size
        ensure_drawn
      end

      left 90
      back 180
      pen_down
      tree 300.0

      ending = Time.now

      puts "that took #{ending-beginning} seconds, tree should be complete"
      # wait
      binding.pry

      MagicMirror.command_cache.reset
    end

  end

  it "gets a default canvas when none is provided" do
    #@trtl.canvas.must_be_instance_of TkCanvas
  end

  it "has pen down by default" do
    @trtl.is_drawing?.must_equal true
  end

  it "can have pen moved up" do
    @trtl.pen_up
    @trtl.is_drawing?.must_equal false
  end

  it "has default X and Y set" do
    @trtl.x.must_equal Trtl::CANVAS_WIDTH / 2
    @trtl.y.must_equal Trtl::CANVAS_HEIGHT / 2
  end

  it "can report its position" do
    @trtl.position.must_equal [@trtl.x, @trtl.y]
  end

  it "can rotate and change heading" do
    @trtl.left 20
    @trtl.heading.must_equal 340
    @trtl.right 40
    @trtl.heading.must_equal 20
  end

  it "can move in straight lines" do
    start_x, start_y = @trtl.position
    @trtl.heading = 0
    @trtl.forward 50
    @trtl.x.must_equal start_x + 50
    @trtl.heading = 90
    @trtl.forward 50
    @trtl.y.must_equal start_y + 50
    @trtl.back 50
    @trtl.y.must_equal start_y
  end

  it "can move at angles" do
    start_x, start_y = @trtl.position
    @trtl.heading = 45
    @trtl.forward 100
    @trtl.x.must_be_close_to start_x + 100 / Math.sqrt(2)
    @trtl.y.must_be_close_to start_y + 100 / Math.sqrt(2)
  end

  it "can be moved absolutely" do
    @trtl.move(310, 201)
    @trtl.position.must_equal [310, 201]
  end
end
