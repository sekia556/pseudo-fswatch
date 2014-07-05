#!/bin/env ruby

DEBUG = nil

def usage()
  puts "Usage: #{$0} <observed file> <action>"
  exit 1
end

def get_mtime(file)
  rval = nil
  if File.exist?(file)
    rval = File::mtime(file)
  end
  rval
end

def modified?(last_mod_time, observed)
  if last_mod_time && observed
    return observed - last_mod_time > 0
  elsif !last_mod_time && !observed
    return false
  end
    
  # either last_mod_time or observerd is changed 
  true
end

abort usage() if ARGV.size < 2


target = ARGV[0]
action = ARGV[1]
puts "target = #{target}" if DEBUG
puts "action = #{action}" if DEBUG

begin
  last_modified = get_mtime(target)
  while true
    #`touch #{target}`
    
    observed = get_mtime(target)
    if modified?(last_modified, observed)
      puts "observed_time=#{observed}" if DEBUG
      puts "last_modified=#{last_modified}" if DEBUG
      puts "detected and run action" if DEBUG
      system(action)
      last_modified = observed
    end
    
    sleep 1
  end
rescue Interrupt
  puts "Stopped."
end
