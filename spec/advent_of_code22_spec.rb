# frozen_string_literal: true

RSpec.describe AdventOfCode22 do
  it "has a version number" do
    expect(AdventOfCode22::VERSION).not_to be nil
  end

  describe "Day1" do
    let(:input_dir) { Pathname.new(__FILE__) + "../data/day1/" }

    it "follows the part 1 example" do
      example = IO.read(input_dir + "example")
      expect(AdventOfCode22::Day1.part_1 example).to eq(24000)
    end

    it "solves part 1" do
      input = IO.read(input_dir + "test")
      expect(AdventOfCode22::Day1.part_1 input).to eq(70720)
    end

    it "follows the part 2 example" do
      example = IO.read(input_dir + "example")
      expect(AdventOfCode22::Day1.part_2 example).to eq(45000)
    end

    it "solves part 2" do
      input = IO.read(input_dir + "test")
      expect(AdventOfCode22::Day1.part_2 input).to eq(207148)
    end
  end
end
