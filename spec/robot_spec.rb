# frozen_string_literal: true

require_relative '../lib/robot.rb'

RSpec.describe Robot do
  let(:robot) { described_class.new(1, 1, :north, 5, 5) }

  describe '#initialize' do
    let(:x) { 1 }
    let(:y) { 1 }
    let(:direction) { :left }
    let(:max_x) { 5 }
    let(:max_y) { 5 }

    context 'when parameters are valid' do
      it 'creates a robot without errors' do
        expect { robot }.not_to raise_error
      end
    end

    context 'when x is invalid' do
      it 'raises an error' do
        expect { described_class.new(-1, y, direction, max_x, max_y) }
          .to raise_error.with_message('Please place the Robot in a valid position')
      end
    end

    context 'when y is invalid' do
      it 'raises an error' do
        expect { described_class.new(x, -1, direction, max_x, max_y) }
          .to raise_error.with_message('Please place the Robot in a valid position')
      end
    end

    context 'when max_x is invalid' do
      it 'raises an error' do
        expect { described_class.new(x, y, direction, 0, max_y) }
          .to raise_error.with_message('Please place the Robot in a valid position')
      end
    end

    context 'when max_y is invalid' do
      it 'raises an error' do
        expect { described_class.new(x, y, direction, max_x, 0) }
          .to raise_error.with_message('Please place the Robot in a valid position')
      end
    end
  end

  context 'when the robot changes directions' do
    describe '#left' do
      before do
        robot.left
      end

      it { expect(robot.direction).to eq(:west) }
    end

    describe '#right' do
      before do
        robot.right
      end

      it { expect(robot.direction).to eq(:east) }
    end
  end

  describe '#report' do
    it 'comunicates current position and direction' do
      expect(robot.report).to eq('Report: Hi, I am placed at [1,1], facing north')
    end
  end

  describe '#move' do
    context 'when robot can move to any position' do
      context 'when direction is west' do
        before do
          robot.direction = :west
        end

        it { expect { robot.move }.to change { robot.x }.from(1).to(0) }
        it { expect { robot.move }.not_to change { robot.y }.from(1) }
      end

      context 'when direction is east' do
        before do
          robot.direction = :east
        end

        it { expect { robot.move }.to change { robot.x }.from(1).to(2) }
        it { expect { robot.move }.not_to change { robot.y }.from(1) }
      end

      context 'when direction is north' do
        before do
          robot.direction = :north
        end

        it { expect { robot.move }.to change { robot.y }.from(1).to(2) }
        it { expect { robot.move }.not_to change { robot.x }.from(1) }
      end

      context 'when direction is south' do
        before do
          robot.direction = :south
        end

        it { expect { robot.move }.to change { robot.y }.from(1).to(0) }
        it { expect { robot.move }.not_to change { robot.x }.from(1) }
      end
    end

    context 'when robot cannot move further west' do
      let(:robot) { described_class.new(0, 0, :west, 5, 5) }

      it { expect { robot.move }.not_to change { robot.x }.from(0) }
    end

    context 'when robot cannot move further east' do
      let(:robot) { described_class.new(4, 0, :east, 5, 5) }

      it { expect { robot.move }.not_to change { robot.x }.from(4) }
    end

    context 'when robot cannot move further north' do
      let(:robot) { described_class.new(0, 4, :north, 5, 5) }

      it { expect { robot.move }.not_to change { robot.y }.from(4) }
    end

    context 'when robot cannot move further south' do
      let(:robot) { described_class.new(0, 0, :south, 5, 5) }

      it { expect { robot.move }.not_to change { robot.y }.from(0) }
    end
  end
end
