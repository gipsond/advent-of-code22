# frozen_string_literal: true

require "parslet"
require "pp"
require "set"

module AdventOfCode22
  class Day6
    def self.num_chars_to_unique_window input, window_size
      s = input.rstrip!
      s.each_char
       .each_cons(window_size)
       .find_index {|cs| cs == cs.uniq} + window_size
    end

    def self.part_1 input
      Day6.num_chars_to_unique_window input, 4
    end

    def self.part_2 input
      Day6.num_chars_to_unique_window input, 14
    end
  end
end