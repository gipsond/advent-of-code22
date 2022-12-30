
# frozen_string_literal: true

require "parslet"
require "pp"
require "set"

module AdventOfCode22

  class Directory
    attr_accessor :parent_dir

    def initialize parent_dir, dirname
      @parent_dir = parent_dir
      @name = dirname
      @contents = {}
    end

    def add_file file
      @contents[file.name] = file
    end

    def add_directory dirname
      dir = Directory.new(self, dirname)
      @contents[dirname] = dir
    end

    def add_contents contents
      for item in contents
        item.add_to_dir self
      end
    end

    def item dirname
      @contents[dirname]
    end

    def size
      @size ||= @contents.values.sum(&:size)
    end

    def is_directory?
      true
    end

    def directories
      @contents.values
        .select(&:is_directory?)
        .collect_concat(&:directories)
        .push(self)
    end

    def dir_sizes
      directories.map(&:size)
    end
    
  end

  class FilesystemReconstructor
    def add_to_working_dir contents
      @wd.add_contents contents
    end

    def cd_root
      @wd = @root
    end

    def cd_up_one_level
      @wd = @wd.parent_dir
    end

    def cd_dirname dirname
      @wd = @wd.item dirname
    end

    def reconstruct_filesystem terminal_output
      @root = Directory.new nil, "/"
      for item in terminal_output
        item.reconstruct self
      end
      @root
    end
  end

  class DirectoryTarget
    def initialize dirname:
      @name = String(dirname)
    end

    def reconstruct reconstructor
      reconstructor.cd_dirname @name
    end
  end

  class UpOneLevelTarget
    def self.reconstruct reconstructor
      reconstructor.cd_up_one_level
    end
  end

  class RootTarget
    def self.reconstruct reconstructor
      reconstructor.cd_root
    end
  end

  class File
    attr_accessor :name, :size

    def initialize file_size:, filename:
      @size = file_size
      @name = String(filename)
    end

    def add_to_dir dir
      dir.add_file self
    end

    def is_directory?
      false
    end
  end

  class Dirname
    def initialize dirname:
      @value = String(dirname)
    end

    def add_to_dir dir
      dir.add_directory @value
    end
  end

  class DirectoryContents
    def initialize contents
      @contents = contents
    end

    def reconstruct fr
      fr.add_to_working_dir @contents
    end
  end

  class Day7Input < Parslet::Parser
    rule(:integer) { match('[0-9]').repeat(1).as(:integer) }
    rule(:dirname) { match('[a-z]').repeat(1).as(:dirname) }
    rule(:filename) { match('[a-z\.]').repeat(1).as(:filename) }
    rule(:newline) { match('\n') }
    rule(:single_space) { str(' ') }

    rule(:cd_dest) { str('/').as(:root) | str('..').as(:up_one_level) | dirname.as(:dir_target) }
    rule(:cd) { str('$ cd ') >> cd_dest.as(:cd_target) >> newline }
    rule(:ls) { str('$ ls') >> newline >> ls_result.repeat }
    rule(:ls_result) { (listed_dir.as(:dir) | listed_file.as(:file)) >> newline }
    rule(:listed_dir) { str('dir ') >> dirname }
    rule(:listed_file) { integer.as(:file_size) >> single_space >> filename }

    rule(:line) { cd | ls.as(:ls) | listed_dir | listed_file }
    rule(:terminal_output) { line.repeat }

    root :terminal_output
  end

  class Day7Transform < Parslet::Transform
    rule(:dir_target => subtree(:x)) { DirectoryTarget.new **x }
    rule(:up_one_level => simple(:x)) { UpOneLevelTarget }
    rule(:root => simple(:x)) { RootTarget }
    rule(:integer => simple(:x)) { Integer(x) }
    rule(:dir => subtree(:x)) { Dirname.new **x }
    rule(:file => subtree(:x)) { File.new **x }
    rule(:ls => subtree(:x)) { DirectoryContents.new x }
    rule(:cd_target => subtree(:x)) { x }
  end

  class Day7
    def self.parse input
      parse_tree = Day7Input.new.parse input
      Day7Transform.new.apply parse_tree
    end

    def self.part_1 input
      terminal_output = Day7.parse input
      fr = FilesystemReconstructor.new
      fs = fr.reconstruct_filesystem terminal_output
      fs.dir_sizes
        .select {|size| size <= 100000 }
        .sum
    end

    def self.part_2 input
      terminal_output = Day7.parse input
      fr = FilesystemReconstructor.new
      fs = fr.reconstruct_filesystem terminal_output
      free_space = 70000000 - fs.size
      required_to_free = 30000000 - free_space
      fs.dir_sizes
        .select {|size| size >= required_to_free }
        .min
    end

  end
end