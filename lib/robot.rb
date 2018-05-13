# frozen_string_literal: true

class Robot
  attr_accessor :x, :y, :direction, :max_x, :max_y

  # Sorted list of possible orientations
  ORIENTATIONS = %i[north east south west].freeze

  def initialize(x, y, direction, max_x, max_y)
    unless valid_robot_placement?(x, y, max_x, max_y)
      raise 'Please place the Robot in a valid position'
    end

    @x         = x
    @y         = y
    @direction = direction.downcase.to_sym
    @max_x     = max_x
    @max_y     = max_y
  end

  def move
    move_forward if possible_movements.include?(@direction)
  end

  # turns to the Left
  def left
    index = ORIENTATIONS.index(@direction)
    @direction = index.zero? ? ORIENTATIONS.last : ORIENTATIONS[index - 1]
  end

  # turns to the Right
  def right
    index = ORIENTATIONS.index(@direction)
    @direction = if index == ORIENTATIONS.length - 1
                   ORIENTATIONS.first
                 else
                   ORIENTATIONS[index + 1]
                 end
  end

  def report
    "Report: Hi, I am placed at [#{@x},#{@y}], facing #{@direction}"
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

  def valid_robot_placement?(x, y, max_x, max_y)
    x < 0 || y < 0 || x > (max_x - 1) || y > (max_y - 1) ? false : true
  end
end
