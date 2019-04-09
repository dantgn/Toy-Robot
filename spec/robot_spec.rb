# frozen_string_literal: true

require_relative '../lib/robot.rb'

RSpec.shared_examples 'it handles invalid initialization' do
  it 'raises an error' do
    expect { subject }
      .to raise_error.with_message('Please place the Robot in a valid position')
  end
end

RSpec.describe Robot do
  subject { described_class.new(x, y, direction, max_x, max_y) }
  let(:x) { 1 }
  let(:y) { 1 }
  let(:direction) { :north }
  let(:max_x) { 5 }
  let(:max_y) { 5 }

  describe '#initialize' do
    context 'when parameters are valid' do
      it 'places a robot without errors' do
        expect { subject }.not_to raise_error
      end
    end

    context 'when x is invalid' do
      let(:x) { -1 }

      it_behaves_like 'it handles invalid initialization'
    end

    context 'when y is invalid' do
      let(:y) { -1 }

      it_behaves_like 'it handles invalid initialization'
    end

    context 'when max_x is invalid' do
      let(:max_x) { -1 }

      it_behaves_like 'it handles invalid initialization'
    end

    context 'when max_y is invalid' do
      let(:max_y) { -1 }

      it_behaves_like 'it handles invalid initialization'
    end
  end

  context 'when the robot changes directions' do
    describe '#left' do
      it { expect { subject.left }.to change { subject.direction }.from(:north).to(:west) }
    end

    describe '#right' do
      it { expect { subject.right }.to change { subject.direction }.from(:north).to(:east) }
    end
  end

  describe '#report' do
    it 'comunicates current position and direction' do
      expect(subject.report)
        .to eq('Report: Hi, I am placed at [1,1], facing north')
    end
  end

  describe '#move' do
    context 'when robot can move to any position' do
      context 'when direction is west' do
        let(:direction) { :west }

        it { expect { subject.move }.to change { subject.x }.from(1).to(0) }
        it { expect { subject.move }.not_to change { subject.y }.from(1) }
      end

      context 'when direction is east' do
        let(:direction) { :east }

        it { expect { subject.move }.to change { subject.x }.from(1).to(2) }
        it { expect { subject.move }.not_to change { subject.y }.from(1) }
      end

      context 'when direction is north' do
        let(:direction) { :north }

        it { expect { subject.move }.to change { subject.y }.from(1).to(2) }
        it { expect { subject.move }.not_to change { subject.x }.from(1) }
      end

      context 'when direction is south' do
        let(:direction) { :south }

        it { expect { subject.move }.to change { subject.y }.from(1).to(0) }
        it { expect { subject.move }.not_to change { subject.x }.from(1) }
      end
    end

    context 'when robot cannot move further west' do
      let(:x) { 0 }

      it { expect { subject.move }.not_to change { subject.x }.from(0) }
    end

    context 'when robot cannot move further east' do
      let(:x) { 4 }

      it { expect { subject.move }.not_to change { subject.x }.from(4) }
    end

    context 'when robot cannot move further north' do
      let(:y) { 4 }

      it { expect { subject.move }.not_to change { subject.y }.from(4) }
    end

    context 'when robot cannot move further south' do
      let(:y) { 0 }
      let(:direction) { :south }

      it { expect { subject.move }.not_to change { subject.y }.from(0) }
    end
  end
end
