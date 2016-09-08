class Maze

  # Initialize a n-by-m array to store our relevant values
  # We do this by creating an array that contains n elements and make each element
  # an array of length m. This represents our n rows and m columns.
  # We also initialze an array maze_trace to hold our values for the trace method
  def initialize(n, m)
    @rows = n
    @columns = m
    @maze = Array.new(@rows){Array.new(@columns)}
    @maze_trace = []
  end

  # For each row in maze, it goes to each column and checks if the value is equal to 1.
  # If it is it prints "|". If it isn't it prints a blank space.
  # At the end of the column it moves the print line to the next line and then iterates
  # through the next row in the same manner.
  def displayMaze
    @maze.each do |x|
      x.each do |y|
        if y == "1"
          print "|"
        else
          print " "
        end
      end
      puts
    end
    # prints a blank line at the end for visibility if you're printing multiple mazes
    puts
  end

  # Method that accepts a string and loads the characters of the string into the maze array
  # First it checks if the string is a valid length and returns a prompt if it isn't
  # Otherwise it iterates through every row and column and adds the value at the corresponding string index
  def load(maze_string)
    count = 0;
    row = 0;
    column = 0;
    if maze_string.length != @rows*@columns
      puts "Did not enter a string of valid length"
      return
    end
    # while loop that goes through the rows
    while row < @rows do
      # while loop that goes through each column
      while column < @columns do
        @maze[row][column] = maze_string[count]
        count+=1
        column+=1
      end
      # note that we need to reset column count to 0 here otherwise it will only do the first row
      column = 0
      row+=1
    end
  end

  # Method that finds a solution to the maze using a breadth first search approach
  def solve(begX, begY, endX, endY)
    # set solution to false
    solution = false
    # create a temp array that is a copy of the maze
    temp = @maze
    # creates an empty queue
    queue = Queue.new
    # enqueue the beginning coordinates as an array
    queue.enq([begX, begY])
    while !queue.empty? && !solution
      # create a current value that is the array of the currently examined coordinates
      # get x and y separate for simplicity
      current = queue.pop
      x=current[0]
      y=current[1]
      # if x and y are the end coordinates, push them on to the maze trace array
      # and set solution to true to trigger an end to the while loop
      if x == endX && y == endY
        @maze_trace.push(current)
        solution = true
      else
        # else still push the coordinates to the trace array
        # set the corresponding value in the temp array to 1
        # enqueue the coordinates above, below, left and right of current
        # only enqueue the elements that pass the check_path method
        # note that we change the temp value to "1" so that previously visited coordinates
        # fail the check_path method. This ensures we don't revisit coordinates
        @maze_trace.push(current)
        temp[x][y] = "1"
        queue.enq([x+1,y]) if check_path(x+1,y,temp)
        queue.enq([x-1,y]) if check_path(x-1,y,temp)
        queue.enq([x,y+1]) if check_path(x,y+1,temp)
        queue.enq([x,y-1]) if check_path(x,y-1,temp)
      end
    end
    if solution
      puts "Path found from point #{begX},#{begY} to point #{endX},#{endY}"
    else
      puts "No path exists between given points"
      # If the path is not found clear the maze_trace array which has elements stored nonetheless
      @maze_trace.clear
    end
  end

  # This method calls the solve method. It then prints the maze_trace array if it's not empty
  def trace(begX, begY, endX, endY)
    solve(begX, begY, endX, endY)
    if @maze_trace.empty?
      return
    else
      @maze_trace.each do |i|
        print "#{i} -> "
      end
      print "exit"
    end
  end

  # This method checks whether a path is valid
  # It does this by checking if the associated coordinate is within the limits of the array
  # and whether it contains a zero or a one
  def check_path(x, y, matrix)
    return false if (x<0 || y<0 || x >= @rows || y >= @columns)
    return false if matrix[x][y] == "1"
    return true if matrix[x][y] == "0"
  end

  # Method that prints an individual cell
  # Just used for testing and checking
  def print_cell(x,y)
    puts @maze[x][y]
  end

  # Method that redesigns the array randomly
  # It randomly generates a 0 or 1 and appends it to a string.
  # The while loop is used to ensure the string is the same size as the original maze dimensions
  # Finally it calls the load method with this new random string
  def redesign()
    random = Random.new
    count = 0
    maze_new_string = ""
    while count < @rows*@columns
      num = random.rand(2)
      maze_new_string = maze_new_string + num.to_s
      count+=1
    end
    load(maze_new_string)
  end
end

# myMaze = Maze.new(9,9)
# maze_string = "111111111100010001111010101100010101101110101100000101111011101100000101111111111"
# myMaze.load(maze_string)
# myMaze.displayMaze
# myMaze.solve(0,0,7,7)
# myMaze.solve(1,1,7,7) # Note that this will destroy the maze so trace will not work
# myMaze.trace(1,1,7,7)
#myMaze.redesign()
#myMaze.displayMaze
