# frozen_string_literal: true
require "parslet"
require "pp"

module AdventOfCode22
  class Day1Input < Parslet::Parser
    rule(:integer) { match('[0-9]').repeat(1) }
    rule(:newline) { match('\n') }
    rule(:inventory_line) { integer.as(:calorie_value) >> newline }
    rule(:inventory) { inventory_line.repeat.as(:inventory) }
    rule(:inventories) { inventory >> (newline >> inventory).repeat }

    root :inventories
  end

  class Day1Transform < Parslet::Transform
    rule(:calorie_value => simple(:x)) { Integer(x) }
    rule(:inventory => sequence(:x)) { x }
  end

  class Day1
    def self.parse input
      parse_tree = Day1Input.new.parse(input)
      Day1Transform.new.apply(parse_tree)
    end

    def self.part_1 input
      inventories = self.parse input
      inventories.map {|i| i.sum }.max
    end

    def self.part_2 input
      inventories = self.parse input
      inventories.map {|i| i.sum }.max(3).sum
    end
  end
end