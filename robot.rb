
class RobotGame

  # Table Dimensions are 5x5
  TABLE_LIMIT_X = 5
  TABLE_LIMIT_Y = 5

  def start
    # Ask for instructions to apply
    puts "Enter the file to test (1, 2, 3, 4, 5, 6 or 7):"
    file_name = gets.chomp
    # Read all instructions for the Robot from a file
    File.open("tests/#{file_name}.txt", "r").readlines.each do |line|
      @instruction = line.chomp.downcase
      if !robot_is_there && @instruction.start_with?("place ")
        x, y, direction = placement_params
        @robot = Robot.new(x, y, direction, TABLE_LIMIT_X, TABLE_LIMIT_Y)
      elsif robot_is_there && @robot.respond_to?(@instruction)
        @robot.send("#{@instruction}")
      else
        raise "Unknown/unvalid instruction: #{@instruction}"
      end
    end
  end

  private

  # extract the placement params to initialize the robot
  # input format is 'PLACE x,y,direction'
  def placement_params
    params = @instruction.split(" ").last
    params = params.split(",")
    x = params.shift.to_i
    y = params.shift.to_i
    direction = params.shift
    if x.nil? || y.nil? || direction.nil?
      raise 'Please provide x, y and direction in the PLACE instruction'
    else
      return x, y, direction
    end
  end

  # A robot is needed on the table before any operation rather than 'place' can run
  def robot_is_there
    @robot.nil? ? false : true
  end
end

class Robot

  attr_accessor :x, :y, :direction, :max_x, :max_y

  # Sorted list of possible orientations
  ORIENTATIONS = [:west, :north, :east, :south]

  def initialize(x, y, direction, max_x, max_y)
    if ensure_correct_placement(x,y, max_x, max_y)
      @x         = x
      @y         = y
      @direction = direction.downcase.to_sym
      @max_x     = max_x
      @max_y     = max_y
    else
      raise "Please place the Robot in a valid position"
    end
  end

  def move
    if possible_movements.include?(@direction)
      move_forward
    end
    # otherwise ignore
  end

  # find next position to the Left on ORIENTATIONS list
  def left
    index = ORIENTATIONS.index(@direction)
    @direction = if index == 0
                   ORIENTATIONS.last
                 else
                   ORIENTATIONS[index - 1]
                 end
  end

  # find next position to the Right on ORIENTATIONS list
  def right
    index = ORIENTATIONS.index(@direction)
    @direction = if index == ORIENTATIONS.length - 1
                   ORIENTATIONS.first
                 else
                   ORIENTATIONS[index + 1]
                 end
  end

  def report
    puts "Report:"
    puts "Hi, I am placed at [#{@x},#{@y}], facing #{@direction}"
  end

  private

  def move_forward
    case @direction
      when :west
        @x -= 1
      when :east
        @x += 1
      when :south
        @y -= 1
      when :north
        @y += 1
    end
  end

  def possible_movements
    movements = []
    movements << :west if @x > 0
    movements << :east if @x < @max_x - 1
    movements << :south if @y > 0
    movements << :north if @y < @max_y - 1
    movements
  end

  def ensure_correct_placement(x,y, max_x, max_y)
    x < 0 || y < 0 || x > (max_x - 1) || y > (max_y - 1) ? false : true
  end

end

game = RobotGame.new
game.start
