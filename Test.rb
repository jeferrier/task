=begin
 This code was written by James Ferrier
 For more information find http://github.com/jeferrier
=end

cmd = '| ruby Main.rb'

open(cmd, 'w+') do |subprocess|

  puts "Verify Eval of exit statment"

  test_command1 = "exit\n" 
  subprocess.write(test_command1)
  subprocess.close_write
  if subprocess.closed?
    puts "\tPass"
  else
    puts "\tFail"
    subprocess.close
  end

end