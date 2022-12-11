
# frozen_string_literal: true
require "parslet"
require "pp"
require "set"

module AdventOfCode22
  class Day3Input < Parslet::Parser
    rule(:newline) { match('\n') }
    rule(:rucksack) { match('[a-zA-Z]').repeat(1).as(:rucksack) >> newline }
    rule(:rucksacks) { rucksack.repeat }

    root :rucksacks
  end

  class Rucksack
    include Enumerable

    def initialize compartments
      @compartments = compartments
    end

    def [] i
      @compartments[i]
    end

    def each
      yield self[0]
      yield self[1]
    end

    def all_item_types
      self.reduce(:|)
    end
  end

  class Day3Transform < Parslet::Transform
    def self.compartments rucksack_s
        midpoint = rucksack_s.length / 2
        [rucksack_s[0, midpoint], rucksack_s[midpoint, rucksack_s.length]]
    end

    rule(:rucksack => simple(:x)) { 
        Rucksack.new Day3Transform.compartments(String(x)).map {|c| Set.new c.chars}
    }
  end

  class Day3
    def self.parse input
      parse_tree = Day3Input.new.parse input
      Day3Transform.new.apply parse_tree
    end

    def self.shared_priority sets
      c = sets.reduce(:&).to_a[0]
      if c.match /[[:lower:]]/
        c.ord - 'a'.ord + 1
      else
        c.ord - 'A'.ord + 27
      end
    end

    def self.part_1 input
      rucksacks = Day3.parse input
      rucksacks.sum {|r| Day3.shared_priority r}
    end

    def self.part_2 input
      rucksacks = Day3.parse input
      groups = rucksacks.each_slice(3).to_a
      groups
        .sum do |g|
          item_sets = g.map(&:all_item_types)
          Day3.shared_priority item_sets
        end
    end

  end
end