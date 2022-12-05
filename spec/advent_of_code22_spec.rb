# frozen_string_literal: true

RSpec.describe AdventOfCode22 do
  it "has a version number" do
    expect(AdventOfCode22::VERSION).not_to be nil
  end

  let(:data_dir) { Pathname.new(__FILE__) + "../data/" }

  describe "Day1" do
    let (:input_dir) { data_dir + "day1" }
    let (:example) { IO.read(input_dir + "example") }
    let (:input) { IO.read(input_dir + "test") }

    it "follows the part 1 example" do
      expect(AdventOfCode22::Day1.part_1 example).to eq(24000)
    end

    it "solves part 1" do
      expect(AdventOfCode22::Day1.part_1 input).to eq(70720)
    end

    it "follows the part 2 example" do
      expect(AdventOfCode22::Day1.part_2 example).to eq(45000)
    end

    it "solves part 2" do
      expect(AdventOfCode22::Day1.part_2 input).to eq(207148)
    end
  end
  
  describe "Day2" do
    let (:input_dir) { data_dir + "day2" }
    let (:example) { IO.read(input_dir + "example") }
    let (:input) { IO.read(input_dir + "test") }

    it "follows the part 1 example" do
      expect(AdventOfCode22::Day2.part_1 example).to eq(15)
    end

    it "solves part 1" do
      expect(AdventOfCode22::Day2.part_1 input).to eq(13682)
    end

    it "follows the part 2 example" do
      expect(AdventOfCode22::Day2.part_2 example).to eq(12)
    end

    it "solves part 2" do
      expect(AdventOfCode22::Day2.part_2 input).to eq(12881)
    end
  end
end
