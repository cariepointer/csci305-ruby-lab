
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
			title = cleanup_title(line)

			#ignore non-english characters
			if title[/(\w|\s|\')*/] == title #filter out only english words?

				title = title.split
				i = 0;

				while i <= title.size-1 #loop through array of words
					hasKey = $bigrams[title[i]]
					hasChild = $bigrams[title[i]] && $bigrams[title[i]][title[i+1]]

					#break if title[i+1].nil? #break if this is the last word in the array --note: self test #4 fails when this is executed

					if hasChild #if child of primary key exists, add one to the count
						cur = $bigrams[title[i]][title[i+1]];
						$bigrams[title[i]][title[i+1]] = cur + 1;
					elsif hasKey #if primary key exists, add new child with initial count = 1
						$bigrams[title[i]][title[i+1]] = 1;
					else #if primary key does not exist, add it and child key
						$bigrams[title[i]] = {title[i+1] => 1};
					end
					i = i + 1;
				end
				#for each word in string
				# title.each { |word|
				# 	if $bigrams.key?(word)
				# 		#puts "YES"
				# 	end
				# }
			end
		end
		#puts $bigrams;
		puts "Finished. Bigram model built.\n"
	# rescue
	# 	STDERR.puts "Could not open file"
	# 	exit 4
	 end
end

# Get song title
def cleanup_title(line)
	title = line.gsub(/((.*)>)/, '') #strip everything in front of song title
	#Regex to filter multiple symbols
	title = title.gsub(/\(.*|\[.*|\{.*|\\.*|\/.*|\_.*|\-.*|\:.*|\".*|\`.*|\+.*|\=.*|feat..*|\?.*|\¿.*|\!.*|\¡.*|\..*|\;.*|\&.*|\@.*|\%.*|\#.*/, '')
	return title.downcase
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
