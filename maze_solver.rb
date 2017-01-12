require 'byebug'
class Maze
  attr_accessor :grid, :start, :finish, :wall, :path

  def initialize(file_name, key)
    @grid = load_maze(file_name)
    @start = key[:start]
    @finish = key[:finish]
    @wall = key[:wall]
    @path = key[:path]
  end

  def load_maze(file_name)
    array = File.readlines(file_name)
    array.map { |string| string.chomp.split("") }
  end

  def display()
    @grid.each do |line|
      acc = ""
      line.each do |el|
        acc << el
      end
      puts acc
    end
  end

  def [](x,y)
    @grid[y][x]
  end

  def []=(x,y,val)
    @grid[y][x] = val
  end
end

class MazeSolver
  DIRECTIONS = [
    [-1,0],
    [1,0],
    [0,-1],
    [0,1]
  ]

  def initialize(file_name, key)
    @maze = Maze.new(file_name, key)
    @maze.display
  end

  def solve()
    #finds start and finish positions
    start = nil
    finish = nil
    @maze.grid.each_with_index do |line, y|
      line.each_with_index do |el, x|
        start = [x,y] if el == @maze.start
        finish = [x,y] if el == @maze.finish
      end
    end

    throw "no start" unless start
    throw "no finish" unless finish

    visited1 = {}
    visited2 = {}
    queue1 = [start]
    queue2 = [finish]

    until queue1.empty? || queue2.empty?
      current1 = queue1.shift
      current2 = queue2.shift

      DIRECTIONS.each do |direction|
        new_pos1 = add_vector(current1, direction)
        new_pos2 = add_vector(current2, direction)

        if @maze[*new_pos1] != @maze.wall && visited1[new_pos1].nil?
          queue1 << new_pos1
          visited1[new_pos1] = current1
          if visited2[new_pos1] || @maze[*new_pos1] == @maze.finish
            draw_solution(visited1,visited2,new_pos1)
            return
          end
        end

        if @maze[*new_pos2] != @maze.wall && visited2[new_pos2].nil?
          queue2 << new_pos2
          visited2[new_pos2] = current2
          if visited1[new_pos2] || @maze[*new_pos2] == @maze.start
            draw_solution(visited1,visited2,new_pos2)
            return
          end
        end
      end
    end

    puts "No solution"
  end

  def draw_solution(visited1,visited2, pos)
# byebug
    @maze[*pos] = @maze.path
    current = pos
    until @maze[*visited1[current]] == @maze.start
      current = visited1[current]
      @maze[*current] = @maze.path
    end

    current = pos
    until @maze[*visited2[current]] == @maze.finish
      current = visited2[current]
      @maze[*current] = @maze.path
    end

    @maze.display()
  end

  def add_vector(pos,direction)
    [pos[0]+direction[0], pos[1]+direction[1]]
  end
end

test1 = MazeSolver.new("test1.txt",{
  :wall => "#",
  :start => "S",
  :finish => "F",
  :path => "P"
  })
test1.solve
