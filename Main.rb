=begin
 This code was written by James Ferrier
 For more information find http://github.com/jeferrier
=end

# File.open(ARGV[0]).each_line do |line|
# # Do something with line, ignore empty lines
# #...
# end

class Main

  def initialize
    access_log_file(get_file_name)

    if @pre_parse
      parse_file_for_structures(@output_file)
    end

  end

  def main

    #Loop
    while true do

      #Read
      input = gets
      return if input == nil

      #Eval
      return if input.chomp.eql? "exit"

      #Print each line with a timestamp
      stamp = Time.now().strftime("[%H:%M:%S] ")
      @output_file.write(stamp + input)
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

end

main = Main.new
main.main