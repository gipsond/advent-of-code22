# frozen_string_literal: true

require "parslet"
require "pp"
require "set"

module AdventOfCode22
  class Day5Input < Parslet::Parser
    rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
    rule(:newline) { match('\n') }

    rule(:crate_space) { str('   ').as(:crate_space) }
    rule(:crate) { str('[') >> match('[A-Z]').as(:crate_letter) >> str(']') }
    rule(:stacked_crate) { crate_space | crate }

    rule(:single_space) { str(' ') }
    rule(:row) { stacked_crate >> (single_space >> stacked_crate).repeat >> newline }
    rule(:stack_number) { single_space >> integer >> single_space }
    rule(:stack_numbers) { stack_number >> (single_space >> stack_number).repeat >> newline }
    rule(:stacks) { row.as(:row).repeat.as(:rows) >> stack_numbers.as(:numbers) }

    # Rearrangement Procedure
    rule(:rp_step) { str('move ') >> integer.as(:count) >> str(' from ') >> integer.as(:src) >> str(' to ') >> integer.as(:dest) >> newline }
    rule(:rp) { rp_step.as(:step).repeat }

    rule(:stacks_and_rp) { stacks.as(:stacks) >> newline >> rp.as(:rearrangement_procedure) }

    root :stacks_and_rp
  end

  class Day5Transform < Parslet::Transform
    rule(:crate_letter => simple(:x)) { String(x) }
    rule(:crate_space => simple(:x)) { nil }
    rule(:integer => simple(:x)) { Integer(x) }
    rule(:row => subtree(:x)) { x }
    rule(:rows => subtree(:x)) { x }
    rule(:step => subtree(:x)) { x }
  end

  class Day5
    def self.parse input
      parse_tree = Day5Input.new.parse input
      stacks_and_rp = Day5Transform.new.apply parse_tree
      stacks_and_rp => { stacks:, rearrangement_procedure: }
      {
        numbers: stacks[:numbers],
        stacks: Day5.create_stacks(**stacks),
        rearrangement_procedure:,
      }
    end

    def self.create_stacks(rows:, numbers:)
      numbers.each_with_index
        .collect {|n, i| 
          [n, rows.collect {|row| row[i]}.reverse!.compact]
        }
        .to_h
    end

    def self.solve input, move_one_by_one
      stacks_and_rp = Day5.parse input
      stacks_and_rp => { numbers:, stacks:, rearrangement_procedure: }

      rearrangement_procedure.each {|step| 
        step => { count:, src:, dest:, }
        if move_one_by_one
          count.times do
            stacks[dest].push(stacks[src].pop)
          end
        else 
          stacks[dest].push(*(stacks[src].pop count))
        end
      }

      numbers.collect {|n| stacks[n].last}.join
    end

    def self.part_1 input
      Day5.solve input, true
    end

    def self.part_2 input
      Day5.solve input, false
    end

  end
end