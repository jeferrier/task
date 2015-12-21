=begin
 This code was written by James Ferrier
 For more information find http://github.com/jeferrier
=end

require "pry"

class Main

  def initialize
    access_log_file(get_file_name)

    if @pre_parse
      parse_file_for_structures(@output_file)
    end

    @state_container = [
      "none",
      "task_declaration",
      "exit"
    ]
    @current_state = :none
    @input = nil

  end

  def main

    #Loop
    while true do

      #Read
      @input = gets
      #Error situation, STDIN should never gets => nil
      return if @input == nil
      @input = @input.chomp

      return if @input.eql? "exit"

      #Eval
      begin
        state_transitioned = state_transition_function
      end while state_transitioned == true

      #Print each line with a timestamp
      stamp = Time.now().strftime("[%H:%M:%S] ")
      @output_file.write(stamp + @input)
      @output_file.flush

    end

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
    return "none"
  end

  def exit
  end

end

main = Main.new
main.main