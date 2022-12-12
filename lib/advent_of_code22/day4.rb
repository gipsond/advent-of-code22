# frozen_string_literal: true

require "parslet"
require "pp"
require "set"

module AdventOfCode22
  class Day4Input < Parslet::Parser
    rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
    rule(:newline) { match('\n') }
    rule(:dash) { str('-') }
    rule(:comma) { str(',') }
    rule(:assignment) { (integer.as(:minId) >> dash >> integer.as(:maxId)).as(:assignment) }
    rule(:assignment_pair) { assignment.as(0) >> comma >> assignment.as(1) >> newline }
    rule(:assignment_pairs) { assignment_pair.repeat }

    root :assignment_pairs
  end

  class Assignment
    def initialize minId, maxId
      @minId = minId
      @maxId = maxId
    end

    attr_reader :minId, :maxId

    def contains id
      @minId <= id && id <= @maxId
    end

    def overlaps other
      contains(other.minId) || contains(other.maxId) || other.fully_contains(self)
    end

    def fully_contains other
      @minId <= other.minId && other.maxId <= @maxId
    end

    def fully_contains_or_is_fully_contained_by other
      fully_contains(other) || other.fully_contains(self)
    end

    def inspect
      "Assignment<#{@minId}-#{@maxId}>"
    end
  end

  class Day4Transform < Parslet::Transform
    rule(:assignment => subtree(:x)) { Assignment.new(x[:minId], x[:maxId]) }
    rule(:integer => simple(:x)) { Integer(x) }
  end

  class Day4
    def self.parse input
      parse_tree = Day4Input.new.parse input
      Day4Transform.new.apply parse_tree
    end

    def self.part_1 input
      assignment_pairs = Day4.parse input
      assignment_pairs.count {|ap| ap[0].fully_contains_or_is_fully_contained_by ap[1]}
    end

    def self.part_2 input
      assignment_pairs = Day4.parse input
      assignment_pairs.count {|ap| ap[0].overlaps ap[1]}
    end

  end
end