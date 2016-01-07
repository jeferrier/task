class Task

  def initialize
    @title = ""
    @description = Array.new
    @lines = Array.new
  end

  def title
    return @title
  end

  def title=(title)
    @title = title
  end

  def add_description_line(line)
    @description << line
  end

  def add_line(line)
    @lines << line
  end

  def print_task
  end

end