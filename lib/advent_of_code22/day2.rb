# frozen_string_literal: true
require "parslet"
require "pp"

module AdventOfCode22
  class Loss
    SCORE = 0
  end

  class Draw
    SCORE = 3
  end

  class Win
    SCORE = 6
  end

  class Rock
    SCORE = 1
    OUTCOME_VS_ROCK = Draw
    OUTCOME_VS_PAPER = Loss
    OUTCOME_VS_SCISSORS = Win

    def self.contest_with shape
      shape::OUTCOME_VS_ROCK
    end

    def self.how_to_achieve outcome
      outcome::HOW_TO_ACHIEVE_WITH_ROCK
    end
  end

  class Paper
    SCORE = 2
    OUTCOME_VS_ROCK = Win
    OUTCOME_VS_PAPER = Draw
    OUTCOME_VS_SCISSORS = Loss

    def self.contest_with shape
      shape::OUTCOME_VS_PAPER
    end

    def self.how_to_achieve outcome
      outcome::HOW_TO_ACHIEVE_WITH_PAPER
    end
  end

  class Scissors
    SCORE = 3
    OUTCOME_VS_ROCK = Loss
    OUTCOME_VS_PAPER = Win
    OUTCOME_VS_SCISSORS = Draw

    def self.contest_with shape
      shape::OUTCOME_VS_SCISSORS
    end

    def self.how_to_achieve outcome
      outcome::HOW_TO_ACHIEVE_WITH_SCISSORS
    end
  end

  class Loss
    HOW_TO_ACHIEVE_WITH_ROCK = Scissors
    HOW_TO_ACHIEVE_WITH_PAPER = Rock
    HOW_TO_ACHIEVE_WITH_SCISSORS = Paper
  end

  class Draw
    HOW_TO_ACHIEVE_WITH_ROCK = Rock
    HOW_TO_ACHIEVE_WITH_PAPER = Paper
    HOW_TO_ACHIEVE_WITH_SCISSORS = Scissors
  end

  class Win
    HOW_TO_ACHIEVE_WITH_ROCK = Paper
    HOW_TO_ACHIEVE_WITH_PAPER = Scissors
    HOW_TO_ACHIEVE_WITH_SCISSORS = Rock
  end

  class StrategyX
    SHAPE = Rock
    OUTCOME = Loss
  end

  class StrategyY
    SHAPE = Paper
    OUTCOME = Draw
  end

  class StrategyZ
    SHAPE = Scissors
    OUTCOME = Win
  end

  class Day2Input < Parslet::Parser
    rule(:shape) { match('[ABC]').as(:shape) }
    rule(:strategy) { match('[XYZ]').as(:strategy) }
    rule(:space) { match('\s').repeat(1) }
    rule(:newline) { match('\n') }
    rule(:round) { shape.as(:opponent_shape) >> space >> strategy.as(:strategy) >> newline}
    rule(:strategy_guide) { round.repeat }

    root :strategy_guide
  end

  class Day2Transform < Parslet::Transform
    rule(:shape => simple(:x)) { 
      case x
      when 'A'
        Rock
      when 'B'
        Paper
      when 'C'
        Scissors
      else
        raise "invalid shape"
      end
    }
    rule(:strategy => simple(:x)) { 
      case x
      when 'X'
        StrategyX
      when 'Y'
        StrategyY
      when 'Z'
        StrategyZ
      else
        raise "invalid strategy"
      end
    }
  end

  class Day2
    def self.parse input
      parse_tree = Day2Input.new.parse input
      Day2Transform.new.apply parse_tree
    end

    def self.score_part_1 round
      my_shape = round[:strategy]::SHAPE
      outcome = round[:opponent_shape].contest_with my_shape
      my_shape::SCORE + outcome::SCORE
    end

    def self.score_part_2 round
      outcome = round[:strategy]::OUTCOME
      shape = round[:opponent_shape].how_to_achieve outcome
      shape::SCORE + outcome::SCORE
    end

    def self.part_1 input
      strategy_guide = Day2.parse input
      strategy_guide.sum {|round| Day2.score_part_1 round}
    end

    def self.part_2 input
      strategy_guide = Day2.parse input
      strategy_guide.sum {|round| Day2.score_part_2 round}
    end
  end
end