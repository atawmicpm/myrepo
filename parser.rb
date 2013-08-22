#!/usr/bin/env ruby

require 'date'
require 'rails'

class ParseLog

	def initialize(logfile, minutes)
		@log = logfile
		@errors = 0
		@valid_time = Time.now.utc - minutes.to_i.minutes
	end

	def count_errors
		entries = File.open(@log, 'r')
		entries.each {|entry| process(entry) }
		write_log
		@errors
	end

	def process(entry)
		if entry =~ /\[(\d{1,2})\/(.+)\/(\d{4}):(.*)\sUTC\].*HTTP.*\s(\d{3})\s/
			date = DateTime.parse("#{$1} #{$2} #{$3} #{$4}")
			status = $5.to_i
			if valid_entry?(date, status)
				@errors += 1
			end
		end
	end

	def valid_entry?(date, status)
		@valid_time < date && status != 200
	end

	def write_log
		File.open('error_count.log', 'a+') {|f| f.write("#{@errors}\n") }
	end

end

logfile = ARGV[0]
minutes = ARGV[1]

log = ParseLog.new(logfile, minutes)
p "#{log.count_errors} non 200 HTTP status codes in last #{minutes} minutes."
