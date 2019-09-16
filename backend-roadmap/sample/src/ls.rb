begin
  if RUBY_VERSION.to_f >= 2.5
    Dir.children(ARGV[0]).each do |c|
      print "#{c}\t"
    end
  else
    Dir.entries(ARGV[0])[2..-1].each do |c|
      print "#{c}\t"
    end
  end
  puts
rescue Errno::ENOENT
  puts "ls: #{ARGV[0]}: No such file or directory"
end
