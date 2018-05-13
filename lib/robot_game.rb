# frozen_string_literal: true

require_relative 'robot.rb'

class RobotGame
  # Table Dimensions are 5x5
  TABLE_LIMIT_X = 5
  TABLE_LIMIT_Y = 5
  MISSING_PARAMS_ERROR = 'Please provide x, y and direction in the PLACE instruction'

  def start
    file_name = ask_for_instructions_file
    # Read all instructions for the Robot from a file
    File.open("tests/#{file_name}.txt", 'r').readlines.each do |line|
      @instruction = line.chomp.downcase
      if !robot_initialized? && @instruction.start_with?('place ')
        place_robot
      elsif robot_initialized? && @robot.respond_to?(@instruction)
        @robot.send(@instruction.to_s)
      else
        raise "Unknown/unvalid instruction: #{@instruction}"
      end
    end
    puts @robot.report
  end

  private

  def ask_for_instructions_file
    puts 'Enter the file to test (1, 2, 3, 4, 5, 6 or 7):'
    gets.chomp
  end

  # extract the placement params to initialize the robot
  # input format is 'PLACE x,y,direction'
  def placement_params
    params = @instruction.split(' ').last
    x, y, direction = params.split(',')

    raise MISSING_PARAMS_ERROR if missing_parameters?(x, y, direction)

    [x.to_i, y.to_i, direction]
  end

  def missing_parameters?(x, y, direction)
    x.nil? || y.nil? || direction.nil?
  end

  def place_robot
    x, y, direction = placement_params
    @robot = Robot.new(x, y, direction, TABLE_LIMIT_X, TABLE_LIMIT_Y)
  end

  # A robot needs to be on the table before any other operation can be applied
  def robot_initialized?
    @robot.nil? ? false : true
  end
end

game = RobotGame.new
game.start
