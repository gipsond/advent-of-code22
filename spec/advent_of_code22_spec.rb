# frozen_string_literal: true

RSpec.shared_examples "a day's solution" do |input_dirname, part_1_ex_exp, part_1_exp, part_2_ex_exp, part_2_exp|
  let (:data_dir) { Pathname.new(__FILE__) + "../data/" }
  let (:input_dir) { data_dir + input_dirname }
  let (:example) { IO.read(input_dir + "example") }
  let (:input) { IO.read(input_dir + "test") }

  describe "#part_1" do
    it "follows the example" do
      expect(described_class.part_1 example).to eq(part_1_ex_exp)
    end

    it "solves part 1" do
      expect(described_class.part_1 input).to eq(part_1_exp)
    end
  end

  describe "#part_2" do
    it "follows the example" do
      expect(described_class.part_2 example).to eq(part_2_ex_exp)
    end

    it "solves part 2" do
      expect(described_class.part_2 input).to eq(part_2_exp)
    end
  end
end

RSpec.describe AdventOfCode22 do
  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe described_class::Day1 do
    it_behaves_like "a day's solution", "day1", 24000, 70720, 45000, 207148
  end

  describe described_class::Day2 do
    it_behaves_like "a day's solution", "day2", 15, 13682, 12, 12881
  end

  describe described_class::Day3 do
    it_behaves_like "a day's solution", "day3", 157, 8185, 70, 2817
  end
end
