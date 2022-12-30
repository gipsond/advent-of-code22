# frozen_string_literal: true
RSpec.shared_context "test data dir", :shared_context => :metadata do 
  let (:data_dir) { Pathname.new(__FILE__) + "../data/" }
end

RSpec.shared_examples "a day's solution" do |input_dirname, part_1_ex_exp, part_1_exp, part_2_ex_exp, part_2_exp|
  include_context "test data dir" do
    let (:input_dir) { data_dir + input_dirname }
    let (:example) { IO.read(input_dir + "example") }
    let (:input) { IO.read(input_dir + "test") }
  end

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

  describe described_class::Day4 do
    it_behaves_like "a day's solution", "day4", 2, 536, 4, 845
  end

  describe described_class::Day5 do
    it_behaves_like "a day's solution", "day5", "CMZ", "PTWLTDSJV", "MCD", "WZMFVGGZP"
  end

  describe described_class::Day6 do
    include_context "test data dir" do
      let (:data_dir) { Pathname.new(__FILE__) + "../data/" }
      let (:input_dir) { data_dir + "day6" }
      let (:example2) { IO.read(input_dir + "example2") }
      let (:example3) { IO.read(input_dir + "example3") }
      let (:example4) { IO.read(input_dir + "example4") }
      let (:example5) { IO.read(input_dir + "example5") }
    end

    it_behaves_like "a day's solution", "day6", 7, 1598, 19, 2414

    describe "#part_1" do
      it "follows example 2" do
        expect(described_class.part_1 example2).to eq(5)
      end

      it "follows example 3" do
        expect(described_class.part_1 example3).to eq(6)
      end

      it "follows example 4" do
        expect(described_class.part_1 example4).to eq(10)
      end

      it "follows example 5" do
        expect(described_class.part_1 example5).to eq(11)
      end
    end

    describe "#part_2" do
      it "follows example 2" do
        expect(described_class.part_2 example2).to eq(23)
      end

      it "follows example 3" do
        expect(described_class.part_2 example3).to eq(23)
      end

      it "follows example 4" do
        expect(described_class.part_2 example4).to eq(29)
      end

      it "follows example 5" do
        expect(described_class.part_2 example5).to eq(26)
      end
    end
  end
end
