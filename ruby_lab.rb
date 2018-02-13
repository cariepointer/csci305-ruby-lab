
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

			#ignore titles with non-english characters
			if title[/(\w|\s|\')*/] == title
				title = title.split
				i = 0;

				while i <= title.size-1 #loop through array of words
					hasKey = $bigrams[title[i]] #first word
					hasChild = $bigrams[title[i]] && $bigrams[title[i]][title[i+1]] #second word that follows first
					break if title[i+1].nil?  #break if this is the last word in the array

					if hasChild #if child of primary key exists, add one to the count
						$bigrams[title[i]][title[i+1]] += 1;
					elsif hasKey #if primary key exists, add new child with initial count = 1
						$bigrams[title[i]][title[i+1]] = 1;
					else #if primary key does not exist, add it and child key
						$bigrams[title[i]] = {title[i+1] => 1};
					end
					i += 1;
				end
			end
		end
		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit 4
	 end
end

#Get most common word following a given word
def mcw(word)
	index = 0

	if $bigrams[word].nil? #if key doesn't exist, then there are no words that follow the given word
		return -1
	else
		max_val = $bigrams[word].max_by{|k,v| v}[1] #get max value
		top_keys = $bigrams[word].select{|k, v| v == max_val}.keys #get keys that contain max value
	end

	if !top_keys.empty? #if more than one key is the max, randomly pick one
		index = rand(0...top_keys.size)
	end
	return top_keys[index]
end

#Generate probable title based on common occurances of words following a given word
def create_title (word)
	p_title = word + ' '
	index = 0
	#do until word key does not exist
	while mcw(word) != -1
		p_array = p_title.split
		word = mcw(word)
		#If the sentence already contains word, break
		break if p_array.include? word
		p_title = p_title + word + ' ' #Concatenate new word to sentence
		index += 1
	end
	p_title.gsub!(/\s$/, '') #remove trailing whitespace
	return p_title
end

# Get song title using regular expressions
def cleanup_title(line)
	title = line.gsub(/.*>/, '') #strip everything in front of song title
	title.gsub!(/\(.*|\[.*|\{.*|\\.*|\/.*|\_.*|\-.*|\:.*|\".*|\`.*|\+.*|\=.*|\*.*|feat\..*/, "") #Remove rest of title following given characters
	title.gsub!(/(\?|\¿|\!|\¡|\.|\;|\&|\@|\%|\#|\|)*/, '') #remove special characters
	title = title.downcase
	title.gsub!(/\b(and|an|a|by|for|from|in|of|on|or|out|the|to|with)*\b/, '') #remove stop words
	title.gsub!(/\s\s+/, ' ') #add whitespace between words
	return title
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
	choice = ''
	while choice != 'q'
		print "Enter a word [Enter 'q' to quit]: "
		choice = $stdin.gets.chomp
		if choice == 'q'
			break
		else
			puts create_title(choice)
		end
	end
end

if __FILE__==$0
	main_loop()
end
