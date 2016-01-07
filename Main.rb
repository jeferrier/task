=begin
 This code was written by James Ferrier
 For more information find http://github.com/jeferrier
=end

require "pry"
require "pry-nav"
load "Task.rb"

class Main

  def initialize
    access_log_file(get_file_name)

    if @pre_parse
      parse_file_for_structures(@output_file)
    end

    @state_container = [
      "none",
      "task_decl",
      "task_input",
      "exit"
    ]
    @task_stack = Array.new
    @current_state = :none
    @current_task = nil
    @input = nil

  end

  def get_file_name
    #Get date info
    date = Time.now()
    date_string = date.strftime("%Y.%m.%d")

    #Assemble filename
    @file_name = date_string + "_log.txt"
  end

  def access_log_file(file_name)
    #Check to see if the file already exists. If it does,
    #we're probably going to want to parse it before we do anything else
    @pre_parse = File.exists?(file_name)

    #Open File
    @output_file = File.open(file_name, "a")
  end

  def parse_file_for_structures(output_file)

  end

  def main

    #Loop
    while true do

      #Read
      input = gets
      #Error situation, STDIN should never gets => nil
      return if input == nil
      @input = input.chomp

      #Eval
      begin
        state_transitioned = state_transition_function
      end while state_transitioned == true

      return if @current_state == :exit

      #Print each line with a timestamp
      stamp = Time.now().strftime("[%H:%M:%S] ")
      @output_file.write(stamp + input)
      @output_file.flush

    end

  end

  def visor
    return @input if @input.eql? "exit"
    return "task_decl" if @input =~ /^TASK/
    return ""
  end

  def state_transition_function

    new_state = ""

    @state_container.each do |state|
      if state.to_sym == @current_state
        state_function = self.method(@current_state)
        new_state = state_function.call().to_sym
        to_return = not(@current_state == new_state)
        @current_state = new_state
        return to_return
      end
    end

  end

  def none
    relinquish = visor()
    if relinquish.empty?
      return "none"
    else
      return relinquish
    end
  end

  def task_decl

    binding.pry()

    relinquish = visor()
    if relinquish.empty? || (relinquish.eql? "task_decl")

      #Normal task declaration
      if @input =~ /^TASK/

        @input = @input.sub(/^TASK/, "").strip()

        if @input.empty?
          if @current_task == nil
            #No sense creating a new empty task
            return "none"
          else
            #Return to the previous task's input chain
            return "task_input"
          end
        end

        unless @current_task == nil
          @task_stack.push(@current_task)
        end

        @current_task = Task.new
        @current_task.title = @input
        return "task_decl"

      elsif @input =~ /^    /
        @current_task.add_description_line(@input)
        return "task_decl"

      else
        return "task_input"
      end

    else
      #Wrap up task delcaration before handing off to next state
      # ...
      return relinquish
    end
  end

  def task_input
    relinquish = visor()
    if relinquish.empty?

      @current_task.add_line(@input)
      return "task_input"

    else
      #Wrap up task input before handing off to next state
      # ...
      return relinquish
    end
  end

  def exit
    #Checking for this state will happen in the main function
    #Do any wrap up before exiting the program
    # ...
    return "exit"
  end

end

main = Main.new
main.main