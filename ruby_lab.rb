
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Carie Pointer
# cariepointer@yahoo.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Carie Pointer"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		IO.foreach(file_name) do |line|
			# call cleanup_title method to extract song titles
			line = cleanup_title(line)
		end

		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	end
end

# Get song title
def cleanup_title(line)
	line = line.gsub /(.*)>/, ''
	return line
end


# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
end

if __FILE__==$0
	main_loop()
end
